//
//  SelectSeatVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 17/04/2022.
//

import UIKit
import Firebase

class SelectSeatVC: UIViewController {
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblDepartureTime: UILabel!
    @IBOutlet weak var btnBrandInfo: UIButton!
    @IBOutlet weak var promiseView: UIView!
    @IBOutlet weak var cltvSeats: UICollectionView!
    @IBOutlet weak var btnBookTicket: UIButton!
    @IBOutlet weak var lblSeatsSelectedCount: UILabel!
    @IBOutlet weak var lblSeatsSelected: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    var seats = [Seat]()
    var trip = Trip()
    let db = Firestore.firestore()
    var seatsSelected = [Seat]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnBrandInfo.underline()
        promiseView.layer.cornerRadius = 5
        cltvSeats.dataSource = self
        cltvSeats.delegate = self
        lblBrandName.text = trip.brandName
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        let myTime = f.string(from: trip.departureTime)
        lblDepartureTime.text = "\(myTime), \(trip.departureTime.getWeekday()), \(trip.departureTime.formatDate())"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        btnBookTicket.isHidden = true
        lblSeatsSelectedCount.text = "Đã chọn 0 vé"
        lblSeatsSelected.text = ""
        lblTotalPrice.text = "0đ"
        seats = []
        seatsSelected = []
        db.collection(K.Collection.seats).order(by: K.Field.seatName, descending: false).whereField(K.Field.tripId, in: [trip.tripId]).getDocuments { snapshot, error in
            if let err = error {
                print("Error: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let seat = Seat()
                    seat.seatId = document.documentID
                    seat.seatName = data[K.Field.seatName] as! String
                    seat.seatStatus = data[K.Field.seatStatus] as! String
                    self.seats.append(seat)
                }
                for seat in self.seats {
                    let mySeatNameString = seat.seatName.replacingOccurrences(of: "A", with: "")
                    seat.seatNameInt = Int(mySeatNameString)!
                }
                self.seats = self.seats.sorted(by: { $0.seatNameInt < $1.seatNameInt })
                self.cltvSeats.reloadData()
            }
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBookTicketClicked(_ sender: UIButton) {
        if let safeUsername = defaults.string(forKey: "username") {
            let order = Order()
            order.username = safeUsername
            order.tripId = trip.tripId
            order.departurePlace = trip.departurePlace
            order.arrivalPlace = trip.arrivalPlace
            order.departureTime = trip.departureTime
            order.brandName = trip.brandName
            order.licensePlate = trip.licensePlate
            order.seats = seatsSelected.map{ return $0.seatName }
            order.totalPrice = trip.price * seatsSelected.count
            var ref: DocumentReference? = nil
            ref = db.collection(K.Collection.orders).addDocument(data: [
                K.Field.username: order.username,
                K.Field.tripId: order.tripId,
                K.Field.departurePlace: order.departurePlace,
                K.Field.arrivalPlace: order.arrivalPlace,
                K.Field.departureTime: order.departureTime,
                K.Field.brandName: order.brandName,
                K.Field.licensePlate: order.licensePlate,
                K.Field.seats: order.seats,
                K.Field.totalPrice: order.totalPrice,
                K.Field.createdDate: Date()
            ]) { error in
                if let err = error {
                    print("Error: \(err)")
                } else {
                    order.orderId = ref!.documentID
                    for seat in self.seatsSelected {
                        self.db.collection(K.Collection.seats).document(seat.seatId).setData([
                            K.Field.username: order.username,
                            K.Field.seatStatus: "Booked"
                        ], merge: true) { error in
                            if let err = error {
                                print("Error: \(err)")
                            } else {
                                let sb = UIStoryboard(name: "Main", bundle: nil)
                                let bookedSuccessVC = sb.instantiateViewController(identifier: "BookedSuccessVC") as! BookedSuccessVC
                                bookedSuccessVC.modalPresentationStyle = .fullScreen
                                bookedSuccessVC.order = order
                                self.present(bookedSuccessVC, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        } else {
            // alert
            let alert = UIAlertController(title: "Cảnh báo", message: "Vui lòng đăng nhập để đặt vé", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Đăng nhập", style: .default) { action in
                let sb = UIStoryboard(name: K.Storyboard.Main, bundle: nil)
                let loginVC = sb.instantiateViewController(identifier: "LoginView")
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension SelectSeatVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCellSeat", for: indexPath)
        let myImageView = UIImageView(image: UIImage(systemName: "bed.double"))
        myImageView.tintColor = .systemGray3
        if seats[indexPath.row].seatStatus == "Booked" {
            myImageView.tintColor = .systemRed
        } else if seats[indexPath.row].seatStatus == "Selected" {
            myImageView.tintColor = .systemGreen
        }
        cell.backgroundView = myImageView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myImageView = collectionView.cellForItem(at: indexPath)?.backgroundView as! UIImageView
        if seats[indexPath.row].seatStatus == "Available" {
            myImageView.tintColor = .systemGreen
            seats[indexPath.row].seatStatus = "Selected"
            seatsSelected.append(seats[indexPath.row])
        } else if seats[indexPath.row].seatStatus == "Selected" {
            myImageView.tintColor = .systemGray3
            seats[indexPath.row].seatStatus = "Available"
            if let index = seatsSelected.firstIndex(where: { $0.seatId == seats[indexPath.row].seatId }) {
                seatsSelected.remove(at: index)
            }
        }
        if seatsSelected.count > 0 {
            lblSeatsSelectedCount.text = "Đã chọn \(seatsSelected.count) vé"
            let seatsName = seatsSelected.map{ return $0.seatName }
            lblSeatsSelected.text = seatsName.joined(separator: ", ")
            lblTotalPrice.text = "\(trip.price * seatsSelected.count)đ"
            btnBookTicket.isHidden = false
        } else {
            lblSeatsSelectedCount.text = "Đã chọn 0 vé"
            lblSeatsSelected.text = ""
            lblTotalPrice.text = "0đ"
            btnBookTicket.isHidden = true
        }
    }
}
