//
//  TripModel.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 09/04/2022.
//

class Trip {
    var tripId: String = ""
    var departurePlace: String = ""
    var arrivalPlace: String = ""
    var departureTime = Date()
    var numberOfSeat: Int = 0
    var numberOfAvailableSeat: Int = 0
    var licensePlate: String = ""
    var price: Int = 0
    var departureProvince: String = ""
    var arrivalProvince: String = ""
    var brandName: String = ""
    var createdDate = Date()
    // Random
    var arrivalTime = Date()
    var star: Int = 0
    var rate: Double = 0
    
    func isValidTrip() -> String? {
        if departurePlace == "" {
            return "Phải chọn nơi khởi hành"
        }
        if arrivalPlace == "" {
            return "Phải chọn nơi đến"
        }
        if departureTime <= Date() {
            return "Phải chọn ngày và giờ trong tương lai"
        }
        if licensePlate == "" {
            return "Phải chọn xe"
        }
        if price <= 0 {
            return "Giá không hợp lệ"
        }
        return nil
    }
}
