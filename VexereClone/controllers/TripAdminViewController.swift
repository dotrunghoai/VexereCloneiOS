//
//  TripAdminViewController.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 09/04/2022.
//

import UIKit
import Firebase
import SwipeCellKit
import SkeletonView

class TripAdminViewController: UIViewController {
    @IBOutlet weak var btnMenuAdmin: UIBarButtonItem!
    @IBOutlet weak var tbvTrips: UITableView!
    
    let db = Firestore.firestore()
    var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            btnMenuAdmin.target = self.revealViewController()!
            btnMenuAdmin.action = #selector(SWRevealViewController.revealToggle(animated:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tbvTrips.dataSource = self
        tbvTrips.delegate = self
        tbvTrips.rowHeight = 43.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tbvTrips.isSkeletonable = true
        tbvTrips.showAnimatedGradientSkeleton()
        tbvTrips.showSkeleton(usingColor: .concrete, transition: .crossDissolve(0.25))
        trips = []
        db.collection(K.Collection.trips).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                for document in snapshot!.documents {
                    let trip = Trip()
                    trip.tripId = document.documentID
                    trip.departurePlace = document.data()[K.Field.departurePlace] as! String
                    trip.arrivalPlace = document.data()[K.Field.arrivalPlace] as! String
                    let myDepartureTime = document.data()[K.Field.departureTime] as! Timestamp
                    trip.departureTime = myDepartureTime.dateValue()
                    trip.licensePlate = document.data()[K.Field.licensePlate] as! String
                    trip.price = document.data()[K.Field.price] as! Int
                    trip.departureProvince = document.data()[K.Field.departureProvince] as! String
                    trip.arrivalProvince = document.data()[K.Field.arrivalProvince] as! String
                    trip.brandName = document.data()[K.Field.brandName] as! String
                    let myArrivalTime = document.data()[K.Field.arrivalTime] as! Timestamp
                    trip.arrivalTime = myArrivalTime.dateValue()
                    trip.star = document.data()[K.Field.star] as! Int
                    trip.rate = document.data()[K.Field.rate] as! Double
                    self.trips.append(trip)
                }
                self.tbvTrips.stopSkeletonAnimation()
                self.tbvTrips.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self.tbvTrips.reloadData()
            }
        }
    }
}

extension TripAdminViewController: SkeletonTableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "myCellTripAdmin"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellTripAdmin", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = trips[indexPath.row].licensePlate
        // parse departureTime to hour, minute to display to cell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm - dd/MMM/yyyy"
        cell.detailTextLabel?.text = dateFormatter.string(from: trips[indexPath.row].departureTime)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let editTripVC = sb.instantiateViewController(identifier: "EditTripVC") as! EditTripVC
        editTripVC.trip = trips[indexPath.row]
        navigationController?.pushViewController(editTripVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let alert = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn muốn xóa chuyến đi này", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Xác nhận", style: .default) { action in
                self.db.collection("trips").document(self.trips[indexPath.row].tripId).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        self.db.collection("seats").whereField("tripId", isEqualTo: self.trips[indexPath.row].tripId).getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    document.reference.delete()
                                }
                            }
                        }
                        self.trips.remove(at: indexPath.row)
                        self.tbvTrips.reloadData()
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
