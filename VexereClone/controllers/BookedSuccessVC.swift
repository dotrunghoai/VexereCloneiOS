//
//  BookedSuccessVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 20/04/2022.
//

import UIKit

class BookedSuccessVC: UIViewController {
    var order = Order()
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblDepartureDate: UILabel!
    @IBOutlet weak var lblDepartureTime: UILabel!
    @IBOutlet weak var lblSeats: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblOrderId.text = "Mã vé: \(order.orderId)"
        lblBrandName.text = "Hãng xe: \(order.brandName)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        lblDepartureDate.text = "Ngày khởi hành: \(dateFormatter.string(from: order.departureTime))"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        lblDepartureTime.text = "Giờ khởi hành: \(timeFormatter.string(from: order.departureTime))"
        lblSeats.text = "Danh sách ghế: \(order.seats.joined(separator: ", "))"
        lblTotalPrice.text = "Tổng giá: \(order.totalPrice)đ"
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBackToHomeClicked(_ sender: UIButton) {
//        navigationController?.popToRootViewController(animated: true)
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
