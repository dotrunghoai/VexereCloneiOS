//
//  NewBrandVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 06/04/2022.
//

import UIKit
import Firebase

class NewBrandVC: UIViewController {
    @IBOutlet weak var stackviewErrorMessage: UIStackView!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var txtBrandName: UITextField!
    @IBOutlet weak var txtBrandAddress: UITextField!
    @IBOutlet weak var txtHotline: UITextField!
    @IBOutlet weak var snipper: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        snipper.hidesWhenStopped = true
        stackviewErrorMessage.isHidden = true
    }
    
    @IBAction func btnAddNewBrandClicked(_ sender: UIButton) {
        snipper.startAnimating()
        // Get max brand code
        var myMaxBrandCode = 0
        db.collection(K.Collection.brands).order(by: K.Field.brandCode, descending: true).limit(to: 1).getDocuments { snapshot, error in
            if let error = error {
                print(error)
                return
            } else {
                if snapshot!.documents.count > 0, let maxBrandCode = snapshot!.documents[0].data()[K.Field.brandCode]! as? String {
                    let fromIndex = maxBrandCode.index(maxBrandCode.startIndex, offsetBy: 1)
                    let toIndex = maxBrandCode.index(maxBrandCode.startIndex, offsetBy: 5)
                    myMaxBrandCode = Int(maxBrandCode[fromIndex...toIndex])!
                }
                
                let brand = Brand()
                brand.brandCode = "B\(String(myMaxBrandCode + 1).leftPadding(toLength: 5, withPad: "0"))"
                brand.brandName = self.txtBrandName.text!
                brand.brandAddress = self.txtBrandAddress.text!
                brand.hotline = self.txtHotline.text!
                brand.carIds = []
                
                if let errorMessage = brand.isValidBrand() {
                    self.lblErrorMessage.text = errorMessage
                    self.stackviewErrorMessage.isHidden = false
                    self.snipper.stopAnimating()
                } else {
                    self.lblErrorMessage.text = ""
                    self.stackviewErrorMessage.isHidden = true
                    var ref: DocumentReference? = nil
                    ref = self.db.collection(K.Collection.brands).addDocument(data: [
                        K.Field.brandCode: brand.brandCode,
                        K.Field.brandName: brand.brandName,
                        K.Field.brandAddress: brand.brandAddress,
                        K.Field.hotline: brand.hotline,
                        K.Field.statusActive: true,
                        K.Field.carIds: [],
                        K.Field.createdDate: Date().timeIntervalSince1970
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
//                            print("Document added with ID: \(ref!.documentID)")
                            self.snipper.stopAnimating()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}
