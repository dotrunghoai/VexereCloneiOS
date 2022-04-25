//
//  SeletedDateVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 16/04/2022.
//

import UIKit

class SelectDateVC: UIViewController {
    @IBOutlet weak var dpkDepartureDate: UIDatePicker!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dpkDepartureDate.minimumDate = Date()
        if let safeDepartureDate = defaults.object(forKey: "departureDate") as? Date {
            dpkDepartureDate.date = safeDepartureDate
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectedClicked(_ sender: UIButton) {
        defaults.set(dpkDepartureDate.date, forKey: "departureDate")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dpkDepartureDateSelected(_ sender: UIDatePicker) {
//        defaults.set(sender.date, forKey: "departureDate")
//        dismiss(animated: true, completion: nil)
//        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
