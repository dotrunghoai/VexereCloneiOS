//
//  EditStationVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 09/04/2022.
//

import UIKit
import Firebase

class EditStationVC: UIViewController {
    @IBOutlet weak var lblStationCode: UILabel!
    @IBOutlet weak var txtStationName: UITextField!
    @IBOutlet weak var txtStationAddress: UITextField!
    @IBOutlet weak var pkvProvince: UIPickerView!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var stackviewErrorMessage: UIStackView!
    @IBOutlet weak var snipper: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    var station = Station()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pkvProvince.dataSource = self
        pkvProvince.delegate = self
        stackviewErrorMessage.isHidden = true
        snipper.hidesWhenStopped = true
        lblStationCode.text = station.stationCode
        txtStationName.text = station.stationName
        txtStationAddress.text = station.stationAddress
        let myIndex = K.provinces.firstIndex(of: station.province)
        pkvProvince.selectRow(Int(myIndex!), inComponent: 0, animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIBarButtonItem) {
        snipper.startAnimating()
        station.stationName = txtStationName.text!
        station.stationAddress = txtStationAddress.text!
        station.province = K.provinces[pkvProvince.selectedRow(inComponent: 0)]
        if let errorMessage = station.isValidStation() {
            lblErrorMessage.text = errorMessage
            stackviewErrorMessage.isHidden = false
            self.snipper.stopAnimating()
        } else {
            lblErrorMessage.text = ""
            stackviewErrorMessage.isHidden = true
            db.collection(K.Collection.stations).document(station.stationId).setData([
                K.Field.stationName: station.stationName,
                K.Field.stationAddress: station.stationAddress,
                K.Field.province: station.province
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

extension EditStationVC: UIPickerViewDataSource, UIPickerViewDelegate {
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
