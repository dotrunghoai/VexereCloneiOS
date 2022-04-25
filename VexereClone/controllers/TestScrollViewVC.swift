//
//  TestScrollViewVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 11/04/2022.
//

import UIKit

class TestScrollViewVC: UIViewController {
    let scrollView = UIScrollView()
    let dynamicSizeContent = UIStackView(arrangedSubviews: [])
    let text1 = "Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view.Do any additional setup after loading the view."
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var lbl2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        myScrollView.translatesAutoresizingMaskIntoConstraints = false
//        myStackView.translatesAutoresizingMaskIntoConstraints = false
        lbl2.text = text1
        
    }
    
    func sub() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemFill

        let scrollViewMargin:CGFloat = 24
        NSLayoutConstraint.activate([
          scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: scrollViewMargin),
          scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: scrollViewMargin),
          scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -scrollViewMargin),
          scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -scrollViewMargin)
        ])

        //
        scrollView.addSubview(dynamicSizeContent)

        dynamicSizeContent.translatesAutoresizingMaskIntoConstraints = false
        dynamicSizeContent.backgroundColor = .systemTeal
        dynamicSizeContent.distribution = .fill
        dynamicSizeContent.spacing = 16
        dynamicSizeContent.axis = .vertical

        //
        let contentMargin:CGFloat = 24
        // Width with margin
        dynamicSizeContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2*contentMargin).isActive = true
        // Optional
        dynamicSizeContent.centerXAnchor.constraint(
          equalTo: view.centerXAnchor
        ).isActive = true


        for _ in 0..<2 {
          addToDynamicContent()
        }

        let sa = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
          dynamicSizeContent.topAnchor.constraint(equalTo: sa.topAnchor, constant: contentMargin),
          dynamicSizeContent.leadingAnchor.constraint(equalTo: sa.leadingAnchor, constant: contentMargin),
          dynamicSizeContent.trailingAnchor.constraint(equalTo: sa.trailingAnchor, constant: -contentMargin),
          dynamicSizeContent.bottomAnchor.constraint(equalTo: sa.bottomAnchor, constant: -contentMargin)
        ])
    }
    
    func addToDynamicContent() {
        let uiv = UIView()
        uiv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        uiv.backgroundColor = .systemRed
        
        let lbl1 = UILabel()
        lbl1.text = text1
//            lbl1.topAnchor.constraint(equalTo: uiv.topAnchor).isActive = true
//            lbl1.leadingAnchor.constraint(equalTo: uiv.leadingAnchor).isActive = true
//            lbl1.frame.width = uiv.frame.width
//            lbl1.heightAnchor.constraint(equalTo: uiv.heightAnchor).isActive = true
        uiv.addSubview(lbl1)
        
        dynamicSizeContent.addArrangedSubview(uiv)
//        dynamicSizeContent.addSubview(<#T##view: UIView##UIView#>)
    }
    
    @IBAction func clicked(_ sender: UIButton) {
        addToDynamicContent()
    }
}
