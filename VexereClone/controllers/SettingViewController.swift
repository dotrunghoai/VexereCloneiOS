//
//  SettingViewController.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 13/04/2022.
//

import UIKit

class SettingViewController: UIViewController {
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnUpdatePasswordClicked(_ sender: UITapGestureRecognizer) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let updatePasswordView = sb.instantiateViewController(identifier: "UpdatePasswordView")
        updatePasswordView.modalPresentationStyle = .fullScreen
        present(updatePasswordView, animated: true, completion: nil)
    }
    
    @IBAction func btnLogoutClicked(_ sender: UITapGestureRecognizer) {
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "password")
        dismiss(animated: true, completion: nil)
    }
}
