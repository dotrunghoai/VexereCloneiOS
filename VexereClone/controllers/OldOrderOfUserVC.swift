//
//  OldOrderOfUserVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 23/04/2022.
//

import UIKit
import Firebase

class OldOrderOfUserVC: UIViewController {
    @IBOutlet weak var noLoginView: UIView!
    @IBOutlet weak var tbvView: UIView!
    @IBOutlet weak var tbvOldOrder: UITableView!
    
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    var username: String = ""
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvOldOrder.dataSource = self
        tbvOldOrder.delegate = self
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
                        if order.departureTime < Date() {
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
                    self.tbvOldOrder.reloadData()
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

extension OldOrderOfUserVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellOldOrder", for: indexPath)
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
}
