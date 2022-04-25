//
//  UpdatePasswordVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 13/04/2022.
//

import UIKit
import Firebase

class UpdatePasswordVC: UIViewController {
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmNewPassword: UITextField!
    @IBOutlet weak var stvErrorMessage: UIStackView!
    @IBOutlet weak var lblErrorMessage: UILabel!
    
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stvErrorMessage.isHidden = true
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        let currentPassword = txtCurrentPassword.text!
        let newPassword = txtNewPassword.text!
        let confirmNewPassword = txtConfirmNewPassword.text!
        let localPassword = defaults.string(forKey: "password")
        let user = User()
        user.password = newPassword
        if currentPassword == "" || newPassword == "" || confirmNewPassword == "" {
            lblErrorMessage.text = "Mật khẩu không được để trống"
            stvErrorMessage.isHidden = false
        } else if newPassword != confirmNewPassword {
            lblErrorMessage.text = "Xác nhận mật khẩu cũ không đúng"
            stvErrorMessage.isHidden = false
        } else if localPassword! != currentPassword {
            lblErrorMessage.text = "Mật khẩu cũ không đúng"
            stvErrorMessage.isHidden = false
        } else if let error = user.isValidPassword() {
            lblErrorMessage.text = error
            stvErrorMessage.isHidden = false
        } else {
            lblErrorMessage.text = ""
            stvErrorMessage.isHidden = true
            db.collection("users").whereField("username", in: [defaults.string(forKey: "username")!]).getDocuments { snapshot, error in
                if let err = error {
                    print("Error: \(err)")
                } else {
                    if snapshot!.documents.count > 0 {
                        self.db.collection("users").document(snapshot!.documents[0].documentID).setData([
                            "password": user.hashPassword
                        ], merge: true) { error in
                            if let err = error {
                                print("Error: \(err)")
                            } else {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
}
