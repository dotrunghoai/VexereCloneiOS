//
//  InfoCovidVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 23/04/2022.
//

import UIKit
import WebKit

class InfoCovidVC: UIViewController, UIWebViewDelegate, WKNavigationDelegate {
    @IBOutlet weak var wvCovidInfo: WKWebView!
    
    var loader = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wvCovidInfo.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loader = self.loader()
        let url = URL(string: "https://vexere.com/vi-VN/bai-viet/dat-dich-vu-test-covid-19-tham-kham-f0-tai-nha")
        // https://www.myenglishpages.com/english/vocabulary-lesson-base-strong-adjectives.php
        let request = URLRequest(url: url!)
        wvCovidInfo.load(request)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopLoader(loader: loader)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
