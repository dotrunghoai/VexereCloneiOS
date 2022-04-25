//
//  SearchTripVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 16/04/2022.
//

import UIKit

class SearchTripVC: UIViewController {
    @IBOutlet weak var tbvTrips: UITableView!
    @IBOutlet weak var viewNoResult: UIView!
    @IBOutlet weak var lblTour: UILabel!
    @IBOutlet weak var lblDepartureTime: UILabel!
    
    var trips = [Trip]()
    var departurePlace: String = ""
    var arrivalPlace: String = ""
    var selectedDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        tbvTrips.dataSource = self
        tbvTrips.delegate = self
        lblTour.text = "\(departurePlace) -> \(arrivalPlace)"
        lblDepartureTime.text = "\(selectedDate.getWeekday()), \(selectedDate.formatDate())"
        if trips.count > 0 {
            viewNoResult.isHidden = true
        } else {
            tbvTrips.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchTripVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellSearchTrip", for: indexPath) as! SearchTripTableViewCell
        let departureTime = trips[indexPath.row].departureTime
        let arrivalTime = trips[indexPath.row].arrivalTime
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        cell.lblDepartureTime.text = dateFormater.string(from: departureTime)
        cell.lblArrivalTime.text = dateFormater.string(from: arrivalTime)
        let detal = arrivalTime.timeIntervalSince(departureTime)
        cell.lblTotalTime.text = "\(detal.getTime().0) giờ \(detal.getTime().1) phút"
        cell.lblDeparturePlace.text = trips[indexPath.row].departurePlace
        cell.lblArrivalPlace.text = trips[indexPath.row].arrivalPlace
        cell.lblBrandName.text = trips[indexPath.row].brandName
        cell.lblNumberOfSeat.text = "Limousine \(trips[indexPath.row].numberOfSeat) giường"
        cell.lblRate.text = String(trips[indexPath.row].rate)
        cell.lblVote.text = "\(trips[indexPath.row].star) đánh giá"
        cell.lblNumberOfAvailableSeat.text = "còn \(trips[indexPath.row].numberOfAvailableSeat) chỗ trống"
        cell.lblPrice.text = "\(trips[indexPath.row].price)đ"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: K.Storyboard.Main, bundle: nil)
        let selectSeatVC = sb.instantiateViewController(identifier: "SelectSeatVC") as! SelectSeatVC
        selectSeatVC.trip = trips[indexPath.row]
        selectSeatVC.modalPresentationStyle = .fullScreen
        present(selectSeatVC, animated: true, completion: nil)
    }
}
