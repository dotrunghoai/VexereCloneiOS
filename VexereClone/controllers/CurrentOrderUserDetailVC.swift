//
//  CurrentOrderUserDetailVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 22/04/2022.
//

import UIKit

class CurrentOrderUserDetailVC: UIViewController {
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblDeparturePlace: UILabel!
    @IBOutlet weak var lblArrivalPlace: UILabel!
    @IBOutlet weak var lblDepartureTime: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblLicensePlate: UILabel!
    @IBOutlet weak var lblSeats: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    var order = Order()

    override func viewDidLoad() {
        super.viewDidLoad()
        lblOrderId.text = order.orderId
        lblDeparturePlace.text = order.departurePlace
        lblArrivalPlace.text = order.arrivalPlace
        lblDepartureTime.text = order.departureTime.formatDateAndTime()
        lblBrandName.text = order.brandName
        lblLicensePlate.text = order.licensePlate
        lblSeats.text = order.seats.joined(separator: ", ")
        lblTotalPrice.text = "\(String(order.totalPrice))đ"
        lblCreatedDate.text = order.createdDate.formatDateAndTime()
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
