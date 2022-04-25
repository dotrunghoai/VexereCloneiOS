//
//  MenuAdminVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 06/04/2022.
//

import UIKit

class MenuAdminVC: UIViewController {
    @IBOutlet weak var myTableviewMenu: UITableView!
    
    let defaults = UserDefaults.standard
    fileprivate var data = ["Tổng quan", "Nhà xe", "Xe", "Bến xe", "Chuyến đi", "Đặt vé", "Tài khoản", "Đăng xuất", "Thoát"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableviewMenu.dataSource = self
        myTableviewMenu.delegate = self
        myTableviewMenu.selectRow(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .none)
    }
}

extension MenuAdminVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 0:
            self.performSegue(withIdentifier: "NaviOverview", sender: self)
        case 1:
            self.performSegue(withIdentifier: "NaviBrand", sender: self)
        case 2:
            self.performSegue(withIdentifier: "NaviCar", sender: self)
        case 3:
            self.performSegue(withIdentifier: "NaviStation", sender: self)
        case 4://NaviOrderAdmin
            self.performSegue(withIdentifier: "NaviTripAdmin", sender: self)
        case 5:
            self.performSegue(withIdentifier: "NaviOrderAdmin", sender: self)
        case 6:
            self.performSegue(withIdentifier: "NaviUserAdmin", sender: self)
        case 7:
            defaults.removeObject(forKey: "username")
            defaults.removeObject(forKey: "password")
            self.dismiss(animated: true, completion: nil)
        case 8:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}
