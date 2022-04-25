//
//  OverviewAdminVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 06/04/2022.
//

import UIKit

class OverviewAdminVC: UIViewController {
    @IBOutlet weak var btnMenuAdmin: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            btnMenuAdmin.target = self.revealViewController()!
            btnMenuAdmin.action = #selector(SWRevealViewController.revealToggle(animated:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
