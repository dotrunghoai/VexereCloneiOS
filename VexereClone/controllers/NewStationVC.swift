//
//  NewStationVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 08/04/2022.
//

import UIKit
import Firebase

class NewStationVC: UIViewController {
    @IBOutlet weak var txtStationName: UITextField!
    @IBOutlet weak var txtStationAddress: UITextField!
    @IBOutlet weak var pkvProvince: UIPickerView!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var stackviewErrorMessage: UIStackView!
    @IBOutlet weak var snipper: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackviewErrorMessage.isHidden = true
        snipper.hidesWhenStopped = true
        pkvProvince.dataSource = self
        pkvProvince.delegate = self
    }
    
    @IBAction func btnAddNewStationClicked(_ sender: UIButton) {
        snipper.startAnimating()
        // Get max brand code
        var myMaxStationCode = 0
        db.collection(K.Collection.stations).order(by: K.Field.stationCode, descending: true).limit(to: 1).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                if snapshot!.documents.count > 0, let maxStationCode = snapshot!.documents[0].data()[K.Field.stationCode]! as? String {
                    let fromIndex = maxStationCode.index(maxStationCode.startIndex, offsetBy: 1)
                    let toIndex = maxStationCode.index(maxStationCode.startIndex, offsetBy: 5)
                    myMaxStationCode = Int(maxStationCode[fromIndex...toIndex])!
                }
                let station = Station()
                station.stationCode = "S\(String(myMaxStationCode + 1).leftPadding(toLength: 5, withPad: "0"))"
                station.stationName = self.txtStationName.text!
                station.stationAddress = self.txtStationAddress.text!
                station.province = K.provinces[self.pkvProvince.selectedRow(inComponent: 0)]
                if let errorMessage = station.isValidStation() {
                    self.lblErrorMessage.text = errorMessage
                    self.stackviewErrorMessage.isHidden = false
                    self.snipper.stopAnimating()
                } else {
                    self.lblErrorMessage.text = ""
                    self.stackviewErrorMessage.isHidden = true
                    self.db.collection(K.Collection.stations).addDocument(data: [
                        K.Field.stationCode: station.stationCode,
                        K.Field.stationName: station.stationName,
                        K.Field.stationAddress: station.stationAddress,
                        K.Field.province: station.province,
                        K.Field.statusActive: true,
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
    }
}

extension NewStationVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return K.provinces.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return K.provinces[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
