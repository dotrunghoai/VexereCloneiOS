//
//  OrderDetailVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 10/04/2022.
//

import UIKit

class OrderDetailVC: UIViewController {
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblTripId: UILabel!
    @IBOutlet weak var lblSeats: UILabel!
    @IBOutlet weak var lblDeparturePlace: UILabel!
    @IBOutlet weak var lblArrivalPlace: UILabel!
    @IBOutlet weak var lblLicensePlate: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblDepartureTime: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    var order = Order()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOrderId.text = order.orderId
        lblUsername.text = order.username
        lblTripId.text = order.tripId
        lblSeats.text = order.seats.joined(separator: ", ")
        lblDeparturePlace.text = order.departurePlace
        lblArrivalPlace.text = order.arrivalPlace
        lblLicensePlate.text = order.licensePlate
        lblTotalPrice.text = String(order.totalPrice)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MM-yyyy"
        lblDepartureTime.text = dateFormatter.string(from: order.departureTime)
        lblBrandName.text = order.brandName
        lblCreatedDate.text = dateFormatter.string(from: order.createdDate)
    }
}
