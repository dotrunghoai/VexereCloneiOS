//
//  OrderCurrentUserVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 22/04/2022.
//

import UIKit
import Firebase
import SwipeCellKit

class OrderCurrentUserVC: UIViewController {
    @IBOutlet weak var noLoginView: UIView!
    @IBOutlet weak var tbvView: UIView!
    @IBOutlet weak var tbvCurrentOrder: UITableView!
    
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    var username: String = ""
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvCurrentOrder.dataSource = self
        tbvCurrentOrder.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let safeUsername = defaults.string(forKey: "username") {
            username = safeUsername
            noLoginView.isHidden = true
            tbvView.isHidden = false
            orders = []
            db.collection(K.Collection.orders).whereField(K.Field.username, in: [username]).getDocuments { snapshot, error in
                if let err = error {
                    print("Error: \(err)")
                } else {
                    for document in snapshot!.documents {
                        let data = document.data()
                        let order = Order()
                        order.departureTime = (data[K.Field.departureTime] as! Timestamp).dateValue()
                        if order.departureTime > Date() {
                            order.orderId = document.documentID
                            order.username = data[K.Field.username] as! String
                            order.tripId = data[K.Field.tripId] as! String
                            order.departurePlace = data[K.Field.departurePlace] as! String
                            order.arrivalPlace = data[K.Field.arrivalPlace] as! String
                            order.brandName = data[K.Field.brandName] as! String
                            order.licensePlate = data[K.Field.licensePlate] as! String
                            order.seats = data[K.Field.seats] as! [String]
                            order.totalPrice = data[K.Field.totalPrice] as! Int
                            order.createdDate = (data[K.Field.createdDate] as! Timestamp).dateValue()
                            self.orders.append(order)
                        }
                    }
                    self.tbvCurrentOrder.reloadData()
                }
            }
        } else {
            tbvView.isHidden = true
            noLoginView.isHidden = false
        }
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: K.Storyboard.Main, bundle: nil)
        let loginVC = sb.instantiateViewController(identifier: "LoginView")
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: K.Storyboard.Main, bundle: nil)
        let loginVC = sb.instantiateViewController(identifier: "LoginView") as! LoginController
        loginVC.isSignUp = true
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}

extension OrderCurrentUserVC: UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if orders.count == 0 {
            self.tbvCurrentOrder.setEmptyMessage("Chưa có vé nào sắp đi")
        } else {
            self.tbvCurrentOrder.restore()
        }
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellCurrentOrder", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = orders[indexPath.row].departurePlace
        cell.detailTextLabel?.text = orders[indexPath.row].departureTime.formatDateAndTime()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: K.Storyboard.Main, bundle: nil)
        let currentOrderDetailVC = sb.instantiateViewController(identifier: "OrderDetailOfUserVC") as! CurrentOrderUserDetailVC
        currentOrderDetailVC.modalPresentationStyle = .fullScreen
        currentOrderDetailVC.order = orders[indexPath.row]
        present(currentOrderDetailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Hủy vé") { action, indexPath in
            let alert = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn muốn hủy vé ?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Không", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Xác nhận", style: .default, handler: {_ in
                self.db.collection(K.Collection.orders).document(self.orders[indexPath.row].orderId).delete { error in
                    if let err = error {
                        print("Error: \(err)")
                    } else {
                        self.db.collection(K.Collection.seats).whereField(K.Field.tripId, in: [self.orders[indexPath.row].tripId]).getDocuments { snapshot, error in
                            if let err = error {
                                print("Error: \(err)")
                            } else {
                                for document in snapshot!.documents {
                                    let data = document.data()
                                    let seatOfTrip = data["seatName"] as! String
                                    for seatOfUser in self.orders[indexPath.row].seats {
                                        if seatOfTrip == seatOfUser {
                                            self.db.collection(K.Collection.seats).document(document.documentID).setData([
                                                K.Field.seatStatus: "Available",
                                                K.Field.username: "",
                                                K.Field.updatedDate: Date()
                                            ], merge: true)
                                        }
                                    }
                                }
                                self.orders.remove(at: self.orders.count - 1)
                                self.tbvCurrentOrder.reloadData()
                            }
                        }
                    }
                }
            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
//        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
