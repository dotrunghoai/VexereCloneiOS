//
//  EditBrandVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 07/04/2022.
//

import UIKit
import Firebase

class EditBrandVC: UIViewController {
    @IBOutlet weak var lblBrandCode: UILabel!
    @IBOutlet weak var txtBrandName: UITextField!
    @IBOutlet weak var txtBrandAddress: UITextField!
    @IBOutlet weak var txtHotline: UITextField!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var stackviewErrorMessage: UIStackView!
    @IBOutlet weak var snipper: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    var brand = Brand()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackviewErrorMessage.isHidden = true
        snipper.hidesWhenStopped = true
        lblBrandCode.text = brand.brandCode
        txtBrandName.text = brand.brandName
        txtBrandAddress.text = brand.brandAddress
        txtHotline.text = brand.hotline
    }
    
    @IBAction func btnSaveClicked(_ sender: UIBarButtonItem) {
        snipper.startAnimating()
        brand.brandName = txtBrandName.text!
        brand.brandAddress = txtBrandAddress.text!
        brand.hotline = txtHotline.text!
        if let errorMessage = brand.isValidBrand() {
            self.lblErrorMessage.text = errorMessage
            self.stackviewErrorMessage.isHidden = false
            self.snipper.stopAnimating()
        } else {
            self.lblErrorMessage.text = ""
            self.stackviewErrorMessage.isHidden = true
            db.collection(K.Collection.brands).document(brand.brandId).setData([
                K.Field.brandName: brand.brandName,
                K.Field.brandAddress: brand.brandAddress,
                K.Field.hotline: brand.hotline
            ], merge: true) { error in
                if let err = error {
                    print("Error: \(err)")
                } else {
                    self.snipper.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
