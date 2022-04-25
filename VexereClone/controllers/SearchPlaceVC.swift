//
//  SearchPlaceVC.swift
//  VexereClone
//
//  Created by Đỗ Trung Hoài on 16/04/2022.
//

import UIKit

class SearchPlaceVC: UIViewController {
    @IBOutlet weak var tbvProvinces: UITableView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var searchBarProvinces: UISearchBar!
    
    let defaults = UserDefaults.standard
    var myTag: Int = 0
    let provinces = K.provinces
    var filterProvinces = K.provinces
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvProvinces.dataSource = self
        tbvProvinces.delegate = self
        searchBarProvinces.delegate = self
        if myTag == 0 {
            lblHeaderTitle.text = "Chọn nơi xuất phát"
        } else {
            lblHeaderTitle.text = "Chọn nơi đến"
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchPlaceVC: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterProvinces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellProvince", for: indexPath)
        cell.textLabel?.text = filterProvinces[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if myTag == 0 {
            defaults.setValue(filterProvinces[indexPath.row], forKey: "departurePlace")
        } else {
            defaults.setValue(filterProvinces[indexPath.row], forKey: "arrivalPlace")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterProvinces = []
        if searchText == "" {
            filterProvinces = provinces
        } else {
            provinces.forEach { province in
                if province.lowercased().contains(searchText.lowercased()) {
                    filterProvinces.append(province)
                }
            }
        }
        tbvProvinces.reloadData()
    }
}
