//
//  NewTripVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 09/04/2022.
//

import UIKit
import Firebase

class NewTripVC: UIViewController {
    @IBOutlet weak var pkvDeparturePlace: UIPickerView!
    @IBOutlet weak var pkvArrivalPlace: UIPickerView!
    @IBOutlet weak var dpkDepartureTime: UIDatePicker!
    @IBOutlet weak var pkvCar: UIPickerView!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var stackviewErrorMessage: UIStackView!
    @IBOutlet weak var snipper: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    var stations = [Station]()
    var cars = [Car]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackviewErrorMessage.isHidden = true
        snipper.hidesWhenStopped = true
        pkvDeparturePlace.dataSource = self
        pkvDeparturePlace.delegate = self
        pkvArrivalPlace.dataSource = self
        pkvArrivalPlace.delegate = self
        pkvCar.dataSource = self
        pkvCar.delegate = self
        dpkDepartureTime.minimumDate = Date()
        db.collection(K.Collection.stations).order(by: K.Field.stationName).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                for document in snapshot!.documents {
                    let station = Station()
                    station.stationName = document.data()[K.Field.stationName] as! String
                    station.province = document.data()[K.Field.province] as! String
                    self.stations.append(station)
                }
                self.pkvDeparturePlace.reloadAllComponents()
                self.pkvArrivalPlace.reloadAllComponents()
            }
        }
        db.collection(K.Collection.cars).order(by: K.Field.licensePlate).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                for document in snapshot!.documents {
                    let car = Car()
                    car.licensePlate = document.data()[K.Field.licensePlate] as! String
                    car.brandName = document.data()[K.Field.brandName] as! String
                    car.numberOfSeat = document.data()[K.Field.numberOfSeat] as! Int
                    self.cars.append(car)
                }
                self.pkvCar.reloadAllComponents()
            }
        }
    }
    
    @IBAction func btnAddNewTripClicked(_ sender: UIButton) {
        snipper.startAnimating()
        let trip = Trip()
        trip.departurePlace = stations[pkvDeparturePlace.selectedRow(inComponent: 0)].stationName
        trip.arrivalPlace = stations[pkvArrivalPlace.selectedRow(inComponent: 0)].stationName
        trip.departureTime = dpkDepartureTime.date
        trip.numberOfSeat = cars[pkvCar.selectedRow(inComponent: 0)].numberOfSeat
        trip.numberOfAvailableSeat = trip.numberOfSeat
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
            stackviewErrorMessage.isHidden = false
            self.snipper.stopAnimating()
        } else {
            lblErrorMessage.text = ""
            stackviewErrorMessage.isHidden = true
            var ref: DocumentReference? = nil
            ref = db.collection(K.Collection.trips).addDocument(data: [
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
                K.Field.arrivalTime: trip.arrivalTime,
                K.Field.star: trip.star,
                K.Field.rate: trip.rate,
                K.Field.createdDate: Date()
            ]) { error in
                if let err = error {
                    print("Error: \(err)")
                } else {
                    for index in 1...self.cars[self.pkvCar.selectedRow(inComponent: 0)].numberOfSeat {
                        let seat = Seat()
                        seat.tripId = ref!.documentID
                        seat.seatName = "A\(index)"
                        self.db.collection(K.Collection.seats).addDocument(data: [
                            K.Field.tripId: seat.tripId,
                            K.Field.seatName: seat.seatName,
                            K.Field.seatStatus: seat.seatStatus,
                            K.Field.username: seat.username,
                            K.Field.updatedDate: seat.updatedDate
                        ])
                    }
                    self.snipper.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension NewTripVC: UIPickerViewDataSource, UIPickerViewDelegate {
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
