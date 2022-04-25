//
//  UserModel.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 03/04/2022.
//

import UIKit
import BCryptSwift

class User: NSObject {
    var username: String = ""
    var password: String = ""
    var hashPassword: String {
        let mySalt = BCryptSwift.generateSaltWithNumberOfRounds(4)
        return BCryptSwift.hashPassword(password, withSalt: mySalt)!
    }
    var email: String = ""
    var phoneNumber: String = ""
    var role: String = ""
    var tokens = [String]()
    var avatar: String = ""
    var createdDate = Date()
    
    func isValidSignUp() -> String? {
        if username.count < 5 {
            return "Tên tài khoản phải lớn hơn 5 ký tự"
        }
        
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let isValidPassword = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        if !isValidPassword {
            return "Mật khẩu phải lớn hơn 8 ký tự, đủ chữ thường, chữ hoa, số và ký tự đặc biệt"
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let isValidEmail = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        if !isValidEmail {
            return "Email chưa đúng định dạng"
        }
        
        let phoneNumberRegex = "^[0-9+]{0,1}+[0-9]{9,10}$"
        let isValidPhoneNumber = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex).evaluate(with: phoneNumber)
        if !isValidPhoneNumber {
            return "SĐT phải là số và lớn hơn 10"
        }
        return nil
    }
    
    func isValidSignIn() -> String? {
        if username == "" {
            return "Tên tài khoản không được để trống"
        }
        if password == "" {
            return "Mật khẩu không được để trống"
        }
        return nil
    }
    
    func isValidEmail() -> String? {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let isValidEmail = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        if !isValidEmail {
            return "Email chưa đúng định dạng"
        }
        return nil
    }
    
    func isValidPhoneNumber() -> String? {
        let phoneNumberRegex = "^[0-9+]{0,1}+[0-9]{9,10}$"
        let isValidPhoneNumber = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex).evaluate(with: phoneNumber)
        if !isValidPhoneNumber {
            return "SĐT phải là số và lớn hơn 10"
        }
        return nil
    }
    
    func isValidPassword() -> String? {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let isValidPassword = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        if !isValidPassword {
            return "Mật khẩu phải lớn hơn 8 ký tự, đủ chữ thường, chữ hoa, số và ký tự đặc biệt"
        }
        return nil
    }
}
