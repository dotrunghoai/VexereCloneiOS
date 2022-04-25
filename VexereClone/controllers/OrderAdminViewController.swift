//
//  OrderAdminViewController.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 10/04/2022.
//

import UIKit
import Firebase
import SkeletonView

class OrderAdminViewController: UIViewController {
    @IBOutlet weak var btnMenuAdmin: UIBarButtonItem!
    @IBOutlet weak var tbvOrders: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    let db = Firestore.firestore()
    var orders = [Order]()
    var filterData = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            btnMenuAdmin.target = self.revealViewController()!
            btnMenuAdmin.action = #selector(SWRevealViewController.revealToggle(animated:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tbvOrders.dataSource = self
        tbvOrders.delegate = self
        tbvOrders.rowHeight = 43.5
        mySearchBar.delegate = self
        
        tbvOrders.isSkeletonable = true
        tbvOrders.showAnimatedGradientSkeleton()
        tbvOrders.showSkeleton(usingColor: .concrete, transition: .crossDissolve(0.25))
        db.collection(K.Collection.orders).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let order = Order()
                    order.orderId = document.documentID
                    order.username = data[K.Field.username] as! String
                    order.tripId = data[K.Field.tripId] as! String
                    order.seats = data[K.Field.seats] as! [String]
                    order.departurePlace = data[K.Field.departurePlace] as! String
                    order.arrivalPlace = data[K.Field.arrivalPlace] as! String
                    order.brandName = data[K.Field.brandName] as! String
                    order.licensePlate = data[K.Field.licensePlate] as! String
                    order.totalPrice = data[K.Field.totalPrice] as! Int
                    let myDepartureTime = data[K.Field.departureTime] as! Timestamp
                    order.departureTime = myDepartureTime.dateValue()
                    let myCreatedDate = data[K.Field.createdDate] as! Timestamp
                    order.createdDate = myCreatedDate.dateValue()
                    self.orders.append(order)
                }
                self.filterData = self.orders
                self.tbvOrders.stopSkeletonAnimation()
                self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self.tbvOrders.reloadData()
            }
        }
        filterData = orders
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension OrderAdminViewController: SkeletonTableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "myCellOrderAdmin"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellOrderAdmin", for: indexPath)
        cell.textLabel?.text = filterData[indexPath.row].orderId
        cell.detailTextLabel?.text = filterData[indexPath.row].username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: K.Storyboard.Main, bundle: nil)
        let orderDetailVC = sb.instantiateViewController(identifier: "OrderDetailVC") as! OrderDetailVC
        orderDetailVC.order = orders[indexPath.row]
        navigationController?.pushViewController(orderDetailVC, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = []
        if searchText == "" {
            filterData = orders
        } else {
            for order in orders {
                if order.username.lowercased().contains(searchText.lowercased()) {
                    filterData.append(order)
                }
            }
        }
        tbvOrders.reloadData()
    }
}
