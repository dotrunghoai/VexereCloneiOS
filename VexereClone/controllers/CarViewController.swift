//
//  CarViewController.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 08/04/2022.
//

import UIKit
import Firebase
import SwipeCellKit
import SkeletonView

class CarViewController: UIViewController {
    @IBOutlet weak var btnMenuAdmin: UIBarButtonItem!
    @IBOutlet weak var tbvCars: UITableView!
    
    let db = Firestore.firestore()
    var cars = [Car]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            btnMenuAdmin.target = self.revealViewController()!
            btnMenuAdmin.action = #selector(SWRevealViewController.revealToggle(animated:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tbvCars.rowHeight = 43.5
        tbvCars.dataSource = self
        tbvCars.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tbvCars.isSkeletonable = true
        tbvCars.showAnimatedGradientSkeleton()
        tbvCars.showSkeleton(usingColor: .concrete, transition: .crossDissolve(0.25))
        cars = []
        db.collection(K.Collection.cars).order(by: K.Field.licensePlate).getDocuments { snapshot, error in
            if let error = error {
                print(error)
                return
            } else {
                if snapshot!.documents.count > 0 {
                    for document in snapshot!.documents {
                        let data = document.data()
                        let car = Car()
                        car.carId = document.documentID
                        car.brandId = data[K.Field.brandId] as! String
                        car.licensePlate = data[K.Field.licensePlate] as! String
                        car.numberOfSeat = data[K.Field.numberOfSeat] as! Int
                        self.cars.append(car)
                    }
                }
                self.tbvCars.stopSkeletonAnimation()
                self.tbvCars.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self.tbvCars.reloadData()
            }
        }
    }
}

extension CarViewController: SkeletonTableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "myCellCar"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellCar", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = cars[indexPath.row].licensePlate
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let editCarVC = sb.instantiateViewController(identifier: "EditCarVC") as! EditCarVC
        editCarVC.car = cars[indexPath.row]
        navigationController?.pushViewController(editCarVC, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Xóa") { action, indexPath in
            let alert = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn muốn xóa xe này", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Xác nhận", style: .default) { action in
                self.db.collection("cars").document(self.cars[indexPath.row].carId).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        self.cars.remove(at: indexPath.row)
                        self.tbvCars.reloadData()
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
