//
//  StationViewController.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 08/04/2022.
//

import UIKit
import Firebase
import SwipeCellKit
import SkeletonView

class StationViewController: UIViewController {
    @IBOutlet weak var btnMenuAdmin: UIBarButtonItem!
    @IBOutlet weak var tbvStations: UITableView!
    
    let db = Firestore.firestore()
    var stations = [Station]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            btnMenuAdmin.target = self.revealViewController()!
            btnMenuAdmin.action = #selector(SWRevealViewController.revealToggle(animated:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tbvStations.rowHeight = 43.5
        tbvStations.dataSource = self
        tbvStations.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tbvStations.isSkeletonable = true
        tbvStations.showAnimatedGradientSkeleton()
        tbvStations.showSkeleton(usingColor: .concrete, transition: .crossDissolve(0.25))
        stations = []
        db.collection(K.Collection.stations).order(by: K.Field.stationName).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let station = Station()
                    station.stationId = document.documentID
                    station.stationCode = data[K.Field.stationCode] as! String
                    station.stationName = data[K.Field.stationName] as! String
                    station.stationAddress = data[K.Field.stationAddress] as! String
                    station.province = data[K.Field.province] as! String
                    self.stations.append(station)
                }
                self.tbvStations.stopSkeletonAnimation()
                self.tbvStations.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self.tbvStations.reloadData()
            }
        }
    }
}

extension StationViewController: UITableViewDelegate, SkeletonTableViewDataSource, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "myCellStation"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellStation", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = stations[indexPath.row].stationName
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let editStationVC = sb.instantiateViewController(identifier: "EditStationVC") as! EditStationVC
        editStationVC.station = stations[indexPath.row]
        navigationController?.pushViewController(editStationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Xóa") { action, indexPath in
            let alert = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn muốn xóa bến xe này ?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Xác nhận", style: .default) { action in
                self.db.collection(K.Collection.stations).document(self.stations[indexPath.row].stationId).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        self.stations.remove(at: indexPath.row)
                        self.tbvStations.reloadData()
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
