//
//  ViewController.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 26/03/2022.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var viewPlace: UIView!
    @IBOutlet weak var viewSelected: UIView!
    @IBOutlet weak var btnDeparturePlace: UIButton!
    @IBOutlet weak var btnArrivalPlace: UIButton!
    @IBOutlet weak var btnDepartureDate: UIButton!
    @IBOutlet weak var viewCovid: UIView!
    @IBOutlet weak var viewNews1: UIView!
    @IBOutlet weak var viewNews2: UIView!
    @IBOutlet weak var viewNews3: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()
    var myRole: String = ""
    var selectedDate = Date()
    var trips = [Trip]()
    var loader = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPlace.addBottomBorderWithColor(color: UIColor.gray, width: 0.5)
        viewSelected.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
//        viewSelected.layer.cornerRadius = 8
//        viewSelected.layer.masksToBounds = true  // optional
        viewCovid.addAllBorderWithColor(color: UIColor.blue, width: 1)
        viewNews1.addAllBorderWithColor(color: .gray, width: 0.4)
        viewNews2.addAllBorderWithColor(color: .gray, width: 0.4)
        viewNews3.addAllBorderWithColor(color: .gray, width: 0.4)
        spinner.hidesWhenStopped = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let safeUsername = defaults.string(forKey: "username") {
            btnLogin.underline3(title: "Hi \(safeUsername)")
            myRole = safeUsername
        } else {
            btnLogin.underline3(title: "Đăng nhập")
            myRole = ""
        }
        if let safeDeparturePlace = defaults.string(forKey: "departurePlace") {
            btnDeparturePlace.setTitle(safeDeparturePlace, for: .normal)
        }
        if let safeArrivalPlace = defaults.string(forKey: "arrivalPlace") {
            btnArrivalPlace.setTitle(safeArrivalPlace, for: .normal)
        }
        if let safeDepartureDate = defaults.object(forKey: "departureDate") as? Date {
            if safeDepartureDate > Date() {
                selectedDate = safeDepartureDate
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd - MM - yyyy"
            let displaySelectedDate = dateFormatter.string(from: selectedDate)
            btnDepartureDate.setTitle(displaySelectedDate, for: .normal)
        }
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if myRole == "admin" {
            let adminView = sb.instantiateViewController(identifier: "AdminView")
            adminView.modalPresentationStyle = .fullScreen
            self.present(adminView, animated: true, completion: nil)
        }
        else if myRole != "" && myRole != "admin" {
            self.tabBarController?.selectedIndex = 1
        } else {
            let loginView = sb.instantiateViewController(identifier: "LoginView")
            loginView.modalPresentationStyle = .fullScreen
            self.present(loginView, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnDeparturePlaceClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let searchPlaceView = sb.instantiateViewController(identifier: "SearchPlaceView") as! SearchPlaceVC
        searchPlaceView.myTag = sender.tag
        searchPlaceView.modalPresentationStyle = .fullScreen
        present(searchPlaceView, animated: true, completion: nil)
    }
    
    @IBAction func btnDepartureDateClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let selectDateView = sb.instantiateViewController(identifier: "SelectDateView")
        selectDateView.modalPresentationStyle = .fullScreen
        present(selectDateView, animated: true, completion: nil)
    }
    
    @IBAction func dpkDepartureDateClicked(_ sender: UIDatePicker) {
        print(sender.date)
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSearchTripClicked(_ sender: UIButton) {
        spinner.startAnimating()
        trips = []
        db.collection(K.Collection.trips).whereField(K.Field.departureProvince, in: [btnDeparturePlace.currentTitle!]).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let departureTime = data[K.Field.departureTime] as! Timestamp
                    let myDepartureTime = departureTime.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd - MM - yyyy"
                    let mySelectedDate = dateFormatter.string(from: myDepartureTime)
                    if data[K.Field.arrivalProvince] as! String == self.btnArrivalPlace.currentTitle! && self.btnDepartureDate.currentTitle! == mySelectedDate {
                        let trip = Trip()
                        trip.tripId = document.documentID
                        trip.departurePlace = data[K.Field.departurePlace] as! String
                        trip.arrivalPlace = data[K.Field.arrivalPlace] as! String
                        let myDepartureTime = data[K.Field.departureTime] as! Timestamp
                        trip.departureTime = myDepartureTime.dateValue()
                        trip.numberOfSeat = data[K.Field.numberOfSeat] as! Int
                        trip.numberOfAvailableSeat = data[K.Field.numberOfAvailableSeat] as! Int
                        trip.licensePlate = data[K.Field.licensePlate] as! String
                        trip.price = data[K.Field.price] as! Int
                        trip.departureProvince = data[K.Field.departureProvince] as! String
                        trip.arrivalProvince = data[K.Field.arrivalProvince] as! String
                        trip.brandName = data[K.Field.brandName] as! String
                        let myArrivalTime = data[K.Field.arrivalTime] as! Timestamp
                        trip.arrivalTime = myArrivalTime.dateValue()
                        trip.star = data[K.Field.star] as! Int
                        trip.rate = data[K.Field.rate] as! Double
                        let myCreatedDate = data[K.Field.createdDate] as! Timestamp
                        trip.createdDate = myCreatedDate.dateValue()
                        self.trips.append(trip)
                    }
                }
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let searchTripVC = sb.instantiateViewController(identifier: "SearchTripVC") as! SearchTripVC
                searchTripVC.trips = self.trips
                searchTripVC.departurePlace = self.btnDeparturePlace.currentTitle!
                searchTripVC.arrivalPlace = self.btnArrivalPlace.currentTitle!
                searchTripVC.selectedDate = self.selectedDate
                searchTripVC.modalPresentationStyle = .fullScreen
                self.present(searchTripVC, animated: true, completion: nil)
                self.spinner.stopAnimating()
            }
        }
    }
    
    @IBAction func btnInfoCovidClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: K.Storyboard.Main, bundle: nil)
        let infoCovidVC = sb.instantiateViewController(identifier: "InfoCovidVC")
        infoCovidVC.modalPresentationStyle = .fullScreen
        present(infoCovidVC, animated: true, completion: nil)
    }
}
