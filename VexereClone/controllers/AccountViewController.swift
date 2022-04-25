//
//  AccountViewController.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 12/04/2022.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUserStatus: UILabel!
    @IBOutlet weak var btnChangeInfoAcc: UIButton!
    
    var isLogged: Bool = true
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let safeUsername = defaults.string(forKey: "username") {
            lblUsername.text = safeUsername
            if safeUsername != "admin" {
                lblUserStatus.text = "Thành viên mới"
            } else {
                lblUserStatus.text = "Admin"
            }
            btnChangeInfoAcc.underlineWithFontsize(title: "Thay đổi", fontSize: CGFloat(14))
            isLogged = true
        } else {
            lblUsername.text = "Trở thành thành viên"
            lblUserStatus.text = "Để tận hưởng nhiều ưu đãi"
            btnChangeInfoAcc.underlineWithFontsize(title: "Đăng nhập", fontSize: CGFloat(14))
            isLogged = false
        }
    }
    
    @IBAction func btnChangeInfoAccClicked(_ sender: UIButton) {
        if isLogged {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let changeInfoUserView = sb.instantiateViewController(identifier: "ChangeInfoUserView") as! ChangeInfoUserVC
            changeInfoUserView.username = lblUsername.text!
            changeInfoUserView.modalPresentationStyle = .fullScreen
            present(changeInfoUserView, animated: true, completion: nil)
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let loginView = sb.instantiateViewController(identifier: "LoginView")
            loginView.modalPresentationStyle = .fullScreen
            self.present(loginView, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnSettingClicked(_ sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let settingView = sb.instantiateViewController(identifier: "SettingView")
        settingView.modalPresentationStyle = .fullScreen
        present(settingView, animated: true, completion: nil)
    }
}
