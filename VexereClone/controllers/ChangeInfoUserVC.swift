//
//  ChangeInfoUserVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 12/04/2022.
//

import UIKit
import Firebase

class ChangeInfoUserVC: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var stvErrorMessage: UIStackView!
    @IBOutlet weak var lblErrorMessage: UILabel!
    
    let db = Firestore.firestore()
    var username: String = ""
    var documentId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        stvErrorMessage.isHidden = true
        txtUsername.text = username
        db.collection("users").whereField("username", in: [username]).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                if snapshot!.documents.count > 0 {
                    let data = snapshot!.documents[0]
                    self.documentId = data.documentID
                    self.txtEmail.text = data["email"] as? String
                    self.txtPhoneNumber.text = data["phoneNumber"] as? String
                }
            }
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        let user = User()
        user.username = txtUsername.text!
        user.email = txtEmail.text!
        user.phoneNumber = txtPhoneNumber.text!
        if user.email == "" || user.phoneNumber == "" {
            lblErrorMessage.text = "Các trường không được để trống"
            stvErrorMessage.isHidden = false
        } else if let error = user.isValidEmail() {
            lblErrorMessage.text = error
            stvErrorMessage.isHidden = false
        } else if let error = user.isValidPhoneNumber() {
            lblErrorMessage.text = error
            stvErrorMessage.isHidden = false
        } else {
            lblErrorMessage.text = ""
            stvErrorMessage.isHidden = true
            db.collection(K.Collection.users).document(documentId).setData([
                "email": user.email,
                "phoneNumber": user.phoneNumber
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
