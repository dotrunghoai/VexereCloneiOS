//
//  EditCarVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 08/04/2022.
//

import UIKit
import Firebase

class EditCarVC: UIViewController {
    @IBOutlet weak var txtBrandName: UITextField!
    @IBOutlet weak var txtLicensePlate: UITextField!
    @IBOutlet weak var txtNumberOfSeat: UITextField!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var stackviewErrorMessage: UIStackView!
    @IBOutlet weak var snipper: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    var car = Car()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        snipper.hidesWhenStopped = true
        stackviewErrorMessage.isHidden = true
        db.collection(K.Collection.brands).document(car.brandId).getDocument { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                if !snapshot!.data()!.isEmpty {
                    self.txtBrandName.text = snapshot!.data()![K.Field.brandName]! as? String
                }
            }
        }
        txtLicensePlate.text = car.licensePlate
        txtNumberOfSeat.text = String(car.numberOfSeat)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIBarButtonItem) {
        snipper.startAnimating()
        let myNumberOfSeat = txtNumberOfSeat.text! == "" ? "0" : txtNumberOfSeat.text!
        car.numberOfSeat = myNumberOfSeat.isNumber ? Int(myNumberOfSeat)! : 0
        if car.numberOfSeat == 0 {
            self.lblErrorMessage.text = "Số ghế phải lớn hơn 0"
            self.stackviewErrorMessage.isHidden = false
            self.snipper.stopAnimating()
        } else {
            self.lblErrorMessage.text = ""
            self.stackviewErrorMessage.isHidden = true
            db.collection(K.Collection.cars).document(car.carId).setData([
                K.Field.numberOfSeat: car.numberOfSeat
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
