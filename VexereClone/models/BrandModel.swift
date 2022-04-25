//
//  BrandModel.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 07/04/2022.
//

import Foundation

class Brand {
    var brandId: String = ""
    var brandCode: String = ""
    var brandName: String = ""
    var brandAddress: String = ""
    var hotline: String = ""
    var statusActive: Bool = true
    var carIds = [String]()
    var createdDate: String = ""
    
    func isValidBrand() -> String? {
        if brandName == "" {
            return "Tên nhà xe không được để trống"
        }
        if brandAddress == "" {
            return "Địa chỉ nhà xe không được để trống"
        }
        if hotline == "" {
            return "SĐT nhà xe không được để trống"
        }
        return nil
    }
}
