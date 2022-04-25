//
//  EditTripVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 10/04/2022.
//

import UIKit
import Firebase

class EditTripVC: UIViewController {
    @IBOutlet weak var pkvDeparturePlace: UIPickerView!
    @IBOutlet weak var pkvArrivalPlace: UIPickerView!
    @IBOutlet weak var dpkDepartureTime: UIDatePicker!
    @IBOutlet weak var pkvCar: UIPickerView!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var stvErrorMessage: UIStackView!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var snipper: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    var trip = Trip()
    var stations = [Station]()
    var cars = [Car]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stvErrorMessage.isHidden = true
        snipper.hidesWhenStopped = true
        pkvDeparturePlace.dataSource = self
        pkvDeparturePlace.delegate = self
        pkvArrivalPlace.dataSource = self
        pkvArrivalPlace.delegate = self
        pkvCar.dataSource = self
        pkvCar.delegate = self
        db.collection(K.Collection.stations).order(by: K.Field.stationName).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                if snapshot!.documents.count > 0 {
                    for document in snapshot!.documents {
                        let station = Station()
                        station.stationName = document.data()[K.Field.stationName] as! String
                        station.province = document.data()[K.Field.province] as! String
                        self.stations.append(station)
                    }
                    self.pkvDeparturePlace.reloadAllComponents()
                    self.pkvArrivalPlace.reloadAllComponents()
                    if let i = self.stations.firstIndex(where: { $0.stationName == self.trip.departurePlace}) {
                        self.pkvDeparturePlace.selectRow(i, inComponent: 0, animated: false)
                    }
                    if let i = self.stations.firstIndex(where: { $0.stationName == self.trip.arrivalPlace}) {
                        self.pkvArrivalPlace.selectRow(i, inComponent: 0, animated: false)
                    }
                }
            }
        }
        db.collection(K.Collection.cars).order(by: K.Field.licensePlate).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                if snapshot!.documents.count > 0 {
                    for document in snapshot!.documents {
                        let car = Car()
                        car.licensePlate = document.data()["licensePlate"] as! String
                        car.brandName = document.data()["brandName"] as! String
                        car.numberOfSeat = document.data()["numberOfSeat"] as! Int
                        self.cars.append(car)
                    }
                    self.pkvCar.reloadAllComponents()
                    if let i = self.cars.firstIndex(where: { $0.licensePlate == self.trip.licensePlate }) {
                        self.pkvCar.selectRow(i, inComponent: 0, animated: false)
                    }
                }
            }
        }
        
        dpkDepartureTime.date = trip.departureTime
        txtPrice.text = String(trip.price)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIBarButtonItem) {
        snipper.startAnimating()
        trip.departurePlace = stations[pkvDeparturePlace.selectedRow(inComponent: 0)].stationName
        trip.arrivalPlace = stations[pkvArrivalPlace.selectedRow(inComponent: 0)].stationName
        trip.departureTime = dpkDepartureTime.date
        trip.numberOfSeat = cars[pkvCar.selectedRow(inComponent: 0)].numberOfSeat
        trip.numberOfAvailableSeat = cars[pkvCar.selectedRow(inComponent: 0)].numberOfSeat
        trip.licensePlate = cars[pkvCar.selectedRow(inComponent: 0)].licensePlate
        let myPrice = txtPrice.text! == "" ? "0" : txtPrice.text!
        trip.price = myPrice.isNumber ? Int(myPrice)! : 0
        trip.departureProvince = stations[pkvDeparturePlace.selectedRow(inComponent: 0)].province
        trip.arrivalProvince = stations[pkvArrivalPlace.selectedRow(inComponent: 0)].province
        trip.brandName = cars[pkvCar.selectedRow(inComponent: 0)].brandName
        let minuteGoRandom = Int.random(in: 1...1440)
        let calendar = Calendar.current
        trip.arrivalTime = calendar.date(byAdding: .minute, value: minuteGoRandom, to: trip.departureTime)!
        trip.star = Int.random(in: 0...500)
        trip.rate = Double(round(10 * Double.random(in: 0.1...5)) / 10)
        trip.createdDate = Date()
        if let errorMessage = trip.isValidTrip() {
            lblErrorMessage.text = errorMessage
            stvErrorMessage.isHidden = false
            self.snipper.stopAnimating()
        } else {
            lblErrorMessage.text = ""
            stvErrorMessage.isHidden = true
            db.collection(K.Collection.trips).document(trip.tripId).setData([
                K.Field.departurePlace: trip.departurePlace,
                K.Field.arrivalPlace: trip.arrivalPlace,
                K.Field.departureTime: trip.departureTime,
                K.Field.numberOfSeat: trip.numberOfSeat,
                K.Field.numberOfAvailableSeat: trip.numberOfAvailableSeat,
                K.Field.licensePlate: trip.licensePlate,
                K.Field.price: trip.price,
                K.Field.departureProvince: trip.departureProvince,
                K.Field.arrivalProvince: trip.arrivalProvince,
                K.Field.brandName: trip.brandName,
                K.Field.arrivalTime: trip.arrivalTime
            ], merge: true){ error in
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

extension EditTripVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return cars.count
        }
        return stations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return cars[row].licensePlate
        }
        return stations[row].stationName
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
