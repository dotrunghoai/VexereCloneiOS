//
//  CarModel.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 08/04/2022.
//

import UIKit

class Car {
    var carId: String = ""
    var brandId: String = ""
    var licensePlate: String = ""
    var numberOfSeat: Int = 0
    var statusActive: Bool = true
    var brandName: String = ""
    var createdDate: String = ""
    
    func isValidCar() -> String? {
        if brandId == "" {
            return "Phải chọn nhà xe"
        }
        if licensePlate == "" {
            return "Biển số xe không được để trống"
        }
        if numberOfSeat == 0 {
            return "Số ghế phải lớn hơn 0"
        }
        return nil
    }
}
