//
//  LoginController.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 03/04/2022.
//

import UIKit
import Firebase
import BCryptSwift

class LoginController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var lblErrorMessage: PaddingLabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblChangeStatus: UILabel!
    @IBOutlet weak var btnChangeStatus: UIButton!
    @IBOutlet weak var stackviewSignUp: UIStackView!
    @IBOutlet weak var stackviewErrorMessage: UIStackView!
    
    let db = Firestore.firestore()
    let defaults = UserDefaults.standard
    var isSignUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackviewErrorMessage.isHidden = true
        if !isSignUp {
            btnSubmit.setTitle("Đăng nhập", for: .normal)
            lblChangeStatus.text = "Bạn chưa có tài khoản ?"
            btnChangeStatus.setTitle("Đăng ký", for: .normal)
            stackviewSignUp.isHidden = true
        }
        
//        let bottomPhoneNumber = txtPhoneNumber.layoutMarginsGuide
//        btnSubmit.topAnchor.constraint(equalTo: bottomPhoneNumber.bottomAnchor, constant: 25).isActive = true
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        let user = User()
        user.username = txtUsername.text!
        user.password = txtPassword.text!
        let confirmPassword = txtConfirmPassword.text!
        user.email = txtEmail.text!
        user.phoneNumber = txtPhoneNumber.text!
        if isSignUp {
            if let errorMessage = user.isValidSignUp() {
                lblErrorMessage.text = errorMessage
                stackviewErrorMessage.isHidden = false
            } else if (user.password != confirmPassword) {
                lblErrorMessage.text = "Xác nhận mật khẩu không đúng"
                stackviewErrorMessage.isHidden = false
            } else {
                lblErrorMessage.text = ""
                stackviewErrorMessage.isHidden = true
                db.collection("users").whereField("username", in: [user.username]).getDocuments { snapshot, error in
                    if let err = error {
                        print("Error: \(err)")
                    } else {
                        if snapshot!.documents.count > 0 {
                            self.lblErrorMessage.text = "Tên tài khoản đã tồn tại"
                            self.stackviewErrorMessage.isHidden = false
                        } else {
                            // Insert User to Firestore
                            self.db.collection("users").addDocument(data: [
                                "username": user.username,
                                "password": user.hashPassword,
                                "email": user.email,
                                "phoneNumber": user.phoneNumber,
                                "role": "user",
                                "tokens": [],
                                "avatar": "",
                                "createdDate": user.createdDate
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
            //                        print("Document added with ID: \(ref!.documentID)")
                                    self.defaults.setValue(user.username, forKey: "username")
                                    self.defaults.setValue(user.password, forKey: "password")
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            if let errorMessage = user.isValidSignIn() {
                lblErrorMessage.text = errorMessage
                stackviewErrorMessage.isHidden = false
            } else {
                lblErrorMessage.text = ""
                stackviewErrorMessage.isHidden = true
                // Login
                db.collection("users").whereField("username", in: [user.username]).getDocuments { snapshot, error in
                    if let err = error {
                        print("Error: \(err)")
                    } else {
                        if snapshot!.documents.count > 0 {
                            let hashPassword = snapshot!.documents[0].data()["password"] as! String
                            if BCryptSwift.verifyPassword(user.password, matchesHash: hashPassword)! {
                                self.defaults.setValue(user.username, forKey: "username")
                                self.defaults.setValue(user.password, forKey: "password")
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                self.lblErrorMessage.text = "Tài khoản hoặc mật khẩu không đúng"
                                self.stackviewErrorMessage.isHidden = false
                            }
                        } else {
                            self.lblErrorMessage.text = "Tài khoản hoặc mật khẩu không đúng"
                            self.stackviewErrorMessage.isHidden = false
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnChangeStatusClicked(_ sender: UIButton) {
        if !isSignUp {
            btnSubmit.setTitle("Đăng ký", for: .normal)
            lblChangeStatus.text = "Bạn đã có tài khoản ?"
            sender.setTitle("Đăng nhập", for: .normal)
            stackviewSignUp.isHidden = false
            isSignUp = true
        } else {
            btnSubmit.setTitle("Đăng nhập", for: .normal)
            lblChangeStatus.text = "Bạn chưa có tài khoản ?"
            sender.setTitle("Đăng ký", for: .normal)
            stackviewSignUp.isHidden = true
            isSignUp = false
        }
    }
}
