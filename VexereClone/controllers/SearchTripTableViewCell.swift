//
//  SearchTripTableViewCell.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 16/04/2022.
//

import UIKit

class SearchTripTableViewCell: UITableViewCell {
    @IBOutlet weak var ctView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var lblDepartureTime: UILabel!
    @IBOutlet weak var lblArrivalTime: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblDeparturePlace: UILabel!
    @IBOutlet weak var lblArrivalPlace: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblNumberOfSeat: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblVote: UILabel!
    @IBOutlet weak var lblNumberOfAvailableSeat: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ctView.addAllBorderWithColor(color: .systemGray, width: 0.5)
        headerView.addBottomBorderWithColor(color: .systemGray, width: 0.5)
        bodyView.addBottomBorderWithColor(color: .systemGray, width: 0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
