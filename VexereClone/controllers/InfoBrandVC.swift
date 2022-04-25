//
//  InfoBrandVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 21/04/2022.
//

import UIKit

class InfoBrandVC: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblNumberOfSeat: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addBottomBorderWithColor(color: .systemGray, width: 1)
        btnClose.underline()
        
        let bullet1 = "Yêu cầu đeo khẩu trang khi lên xe"
        let bullet2 = "Tạm ngưng phục vụ khách nước ngoài do diễn biến phức tạp của dịch Covid-19"
        let bullet3 = "Xuất trình Khai báo Y tế trước khi lên xe và tuân thủ quy tắc 5K của Bộ Y tế khi di chuyển"
        let bullet4 = "Có mặt tại văn phòng/quầy vé/bến xe trước 30 phút để làm thủ tục lên xe"
        let bullet5 = "Đổi vé giấy trước khi lên xe"
        let bullet6 = "Xuất trình SMS/Email đặt vé trước khi lên xe"
        let bullet7 = "Không mang đồ ăn, thức ăn có mùi lên xe"
        let strings = [bullet1, bullet2, bullet3, bullet4, bullet5, bullet6, bullet7]
        var fullString = ""
        for string in strings {
            let bulletPoint: String = "\u{2022}"
            let formattedString: String = "\(bulletPoint) \(string)\n"
            fullString = fullString + formattedString
        }
        lblContent.text = fullString
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
