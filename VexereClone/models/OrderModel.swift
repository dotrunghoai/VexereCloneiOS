//
//  OrderModel.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 10/04/2022.
//

class Order {
    var orderId: String = ""
    var username: String = ""
    var tripId: String = ""
    var departurePlace: String = ""
    var arrivalPlace: String = ""
    var departureTime = Date()
    var brandName: String = ""
    var licensePlate: String = ""
    var seats = [String]()
    var totalPrice: Int = 0
    var createdDate = Date()
}
