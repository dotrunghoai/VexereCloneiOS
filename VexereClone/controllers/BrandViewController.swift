//
//  BrandViewController.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 06/04/2022.
//

import UIKit
import Firebase
import SwipeCellKit
import SkeletonView

class BrandViewController: UIViewController {
    @IBOutlet weak var btnMenuAdmin: UIBarButtonItem!
    @IBOutlet weak var tbvBrands: UITableView!
    
    let db = Firestore.firestore()
    var brands = [Brand]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            btnMenuAdmin.target = self.revealViewController()!
            btnMenuAdmin.action = #selector(SWRevealViewController.revealToggle(animated:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tbvBrands.dataSource = self
        tbvBrands.delegate = self
        tbvBrands.rowHeight = 43.55
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tbvBrands.isSkeletonable = true
        tbvBrands.showAnimatedGradientSkeleton()
        tbvBrands.showSkeleton(usingColor: .concrete, transition: .crossDissolve(0.25))
        brands = []
        db.collection(K.Collection.brands).order(by: K.Field.brandCode).getDocuments { snapshot, error in
            if let error = error {
                print(error)
                return
            } else {
                if snapshot!.documents.count > 0 {
                    for document in snapshot!.documents {
                        let data = document.data()
                        let brand = Brand()
                        brand.brandId = document.documentID
                        brand.brandCode = data[K.Field.brandCode] as! String
                        brand.brandName = data[K.Field.brandName] as! String
                        brand.brandAddress = data[K.Field.brandAddress] as! String
                        brand.hotline = data[K.Field.hotline] as! String
                        self.brands.append(brand)
                    }
                }
                self.tbvBrands.stopSkeletonAnimation()
                self.tbvBrands.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self.tbvBrands.reloadData()
            }
        }
    }
}

extension BrandViewController: SkeletonTableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "myCellBrand"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellBrand", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = brands[indexPath.row].brandName
        cell.detailTextLabel?.text = brands[indexPath.row].brandCode
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: K.Storyboard.Main, bundle: nil)
        let editBrandVC = sb.instantiateViewController(identifier: "EditBrandVC") as! EditBrandVC
        editBrandVC.brand = brands[indexPath.row]
        navigationController?.pushViewController(editBrandVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Xóa") { action, indexPath in
            let alert = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn muốn xóa nhà xe này ?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Xác nhận", style: .default) { action in
                self.db.collection(K.Collection.brands).document(self.brands[indexPath.row].brandId).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        self.brands.remove(at: indexPath.row)
                        self.tbvBrands.reloadData()
                    }
                }
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
}
