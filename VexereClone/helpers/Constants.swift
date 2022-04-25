//
//  Constants.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 06/04/2022.
//

import Foundation

class K {
    class Storyboard {
        static let Main = "Main"
    }
    
    class Collection {
        static let users = "users"
        static let brands = "brands"
        static let cars = "cars"
        static let seats = "seats"
        static let stations = "stations"
        static let trips = "trips"
        static let orders = "orders"
    }
    
    class Field {
        // User
        static let username = "username"
        static let password = "password"
        static let email = "email"
        static let phoneNumber = "phoneNumber"
        static let role = "role"
        static let tokens = "tokens"
        static let avatar = "avatar"
        static let createdDate = "createdDate"
        // Brand
        static let brandId = "brandId"
        static let brandCode = "brandCode"
        static let brandName = "brandName"
        static let brandAddress = "brandAddress"
        static let hotline = "hotline"
        static let carIds = "carIds"
        static let statusActive = "statusActive"
        // Car
        static let licensePlate = "licensePlate"
        static let numberOfSeat = "numberOfSeat"
        static let numberOfAvailableSeat = "numberOfAvailableSeat"
        // Seat
        static let seatName = "seatName"
        static let seatStatus = "seatStatus"
        static let updatedDate = "updatedDate"
        // Station
        static let stationCode = "stationCode"
        static let stationName = "stationName"
        static let stationAddress = "stationAddress"
        static let province = "province"
        // Trip
        static let tripId = "tripId"
        static let departurePlace = "departurePlace"
        static let arrivalPlace = "arrivalPlace"
        static let departureTime = "departureTime"
        static let price = "price"
        static let departureProvince = "departureProvince"
        static let arrivalProvince = "arrivalProvince"
        static let arrivalTime = "arrivalTime"
        static let star = "star"
        static let rate = "rate"
        // Order
        static let seats = "seats"
        static let totalPrice = "totalPrice"
    }
    static let provinces: [String] = [
        "Hà Nội",     "Hồ Chí Minh", "Đà Nẵng",    "An Giang",
        "Bạc Liêu",   "Bắc Kạn",     "Bắc Giang",  "Bắc Ninh",
        "Bến Tre",    "Bình Dương",  "Bình Định",  "Bình Phước",
        "Bình Thuận", "Cà Mau",      "Cao Bằng",   "Cần Thơ",
        "Đắk Lắk",    "Đắk Nông",    "Điện Biên",  "Đồng Nai",
        "Đồng Tháp",  "Gia Lai",     "Hà Giang",   "Hà Nam",
        "Hà Tây",     "Hà Tĩnh",     "Hải Dương",  "Hải Phòng",
        "Hòa Bình",   "Hậu Giang",   "Huế",        "Hưng Yên",
        "Khánh Hòa",  "Kiên Giang",  "Kon Tum",    "Lai Châu",
        "Lào Cai",    "Lạng Sơn",    "Lâm Đồng",   "Long An",
        "Nam Định",   "Nghệ An",     "Ninh Bình",  "Ninh Thuận",
        "Phú Thọ",    "Phú Yên",     "Quảng Bình", "Quảng Nam",
        "Quảng Ngãi", "Quảng Ninh",  "Quảng Trị",  "Sóc Trăng",
        "Sơn La",     "Tây Ninh",    "Thái Bình",  "Thái Nguyên",
        "Thanh Hóa",  "Tiền Giang",  "Trà Vinh",   "Tuyên Quang",
        "Vĩnh Long",  "Vĩnh Phúc",   "Vũng Tàu",   "Yên Bái"
    ]
}
