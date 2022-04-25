//
//  StationModel.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 08/04/2022.
//

import UIKit

class Station {
    var stationId: String = ""
    var stationCode: String = ""
    var stationName: String = ""
    var stationAddress: String = ""
    var province: String = ""
    var statusActive: Bool = true
    var createdDate: String = ""
    
    func isValidStation () -> String? {
        if stationName == "" {
            return "Tên bến xe không được để trống"
        }
        if stationAddress == "" {
            return "Địa chỉ bến xe không được để trống"
        }
        if province == "" {
            return "Phải chọn tên Tỉnh/Thành phố"
        }
        return nil
    }
}
