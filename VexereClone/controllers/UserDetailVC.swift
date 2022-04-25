//
//  UserDetailVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 12/04/2022.
//

import UIKit

class UserDetailVC: UIViewController {
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblCreatedDate: UILabel!

    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUsername.text = user.username
        lblEmail.text = user.email
        lblPhoneNumber.text = user.phoneNumber
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MMM-yyyy"
        lblCreatedDate.text = dateFormatter.string(from: user.createdDate)
    }
}
