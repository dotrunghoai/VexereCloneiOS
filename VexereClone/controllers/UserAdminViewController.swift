//
//  UserAdminViewController.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 12/04/2022.
//

import UIKit
import Firebase
import SkeletonView

class UserAdminViewController: UIViewController {
    @IBOutlet weak var btnMenuAdmin: UIBarButtonItem!
    @IBOutlet weak var tbvUsers: UITableView!
    
    let db = Firestore.firestore()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            btnMenuAdmin.target = self.revealViewController()!
            btnMenuAdmin.action = #selector(SWRevealViewController.revealToggle(animated:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tbvUsers.dataSource = self
        tbvUsers.delegate = self
        tbvUsers.rowHeight = 43.5
        tbvUsers.isSkeletonable = true
        tbvUsers.showAnimatedGradientSkeleton()
        tbvUsers.showSkeleton(usingColor: .concrete, transition: .crossDissolve(0.25))
        db.collection(K.Collection.users).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let user = User()
                    user.username = data[K.Field.username] as! String
                    user.email = data[K.Field.email] as! String
                    user.phoneNumber = data[K.Field.phoneNumber] as! String
                    let myCreatedDate = data[K.Field.createdDate] as! Timestamp
                    user.createdDate = myCreatedDate.dateValue()
                    self.users.append(user)
                }
                self.tbvUsers.stopSkeletonAnimation()
                self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                self.tbvUsers.reloadData()
            }
        }
    }
}

extension UserAdminViewController: SkeletonTableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "myCellUserAdmin"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellUserAdmin", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: K.Storyboard.Main, bundle: nil)
        let userDetailVC = sb.instantiateViewController(identifier: "UserAdminDetailVC") as! UserDetailVC
        userDetailVC.user = users[indexPath.row]
        navigationController?.pushViewController(userDetailVC, animated: true)
    }
}
