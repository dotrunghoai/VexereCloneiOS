//
//  NewCarVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 08/04/2022.
//

import UIKit
import Firebase

class NewCarVC: UIViewController {
    @IBOutlet weak var pickerviewBrandName: UIPickerView!
    @IBOutlet weak var txtLicensePlate: UITextField!
    @IBOutlet weak var txtNumberOfSeat: UITextField!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var stackviewErrorMessage: UIStackView!
    @IBOutlet weak var snipper: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    var brands = [Brand]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackviewErrorMessage.isHidden = true
        pickerviewBrandName.dataSource = self
        pickerviewBrandName.delegate = self
        snipper.hidesWhenStopped = true
        db.collection(K.Collection.brands).order(by: K.Field.brandName).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                for document in snapshot!.documents {
                    let brand = Brand()
                    brand.brandId = document.documentID
                    brand.brandName = document.data()[K.Field.brandName]! as! String
                    self.brands.append(brand)
                }
                self.pickerviewBrandName.reloadAllComponents()
            }
        }
    }
    
    @IBAction func btnAddNewCarClicked(_ sender: UIButton) {
        snipper.startAnimating()
        let car = Car()
        car.brandId = brands.count > 0 ? brands[pickerviewBrandName.selectedRow(inComponent: 0)].brandId : ""
        car.licensePlate = txtLicensePlate.text!
        let myNumberOfSeat = txtNumberOfSeat.text! == "" ? "0" : txtNumberOfSeat.text!
        car.numberOfSeat = myNumberOfSeat.isNumber ? Int(myNumberOfSeat)! : 0
        car.brandName = brands[pickerviewBrandName.selectedRow(inComponent: 0)].brandName
        
        if let errorMessage = car.isValidCar() {
            self.lblErrorMessage.text = errorMessage
            self.stackviewErrorMessage.isHidden = false
            self.snipper.stopAnimating()
        } else {
            self.lblErrorMessage.text = ""
            self.stackviewErrorMessage.isHidden = true
            self.db.collection(K.Collection.cars).addDocument(data: [
                K.Field.brandId: car.brandId,
                K.Field.licensePlate: car.licensePlate,
                K.Field.numberOfSeat: car.numberOfSeat,
                K.Field.statusActive: true,
                K.Field.brandName: car.brandName,
                K.Field.createdDate: Date().timeIntervalSince1970
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    self.snipper.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension NewCarVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return brands[row].brandName
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}
