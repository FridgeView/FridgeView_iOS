//
//  Inventory_Item_VC.swift
//  FridgeView
//
//  Created by Deok Kwon Kim on 3/15/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit

class Inventory_Item_VC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedItem : UserFoodItem?
    var userCreatedAt: Date?
    let titles = ["Description","Created At", "Expiration Date", "Days since created"]
    var information = [String?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension 
        self.title = selectedItem?.foodItem?.foodName ?? "Item"
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let createdDate: String = formatter.string(from: userCreatedAt!)
            var expiredDate: String
        let expirationDate: Date?
        if(selectedItem?.foodItem?.expDays != nil){
            expirationDate = Calendar.current.date(byAdding: .day, value: selectedItem?.foodItem?.expDays as! Int, to: (selectedItem?.createdAt)!)
            expiredDate = formatter.string(from: expirationDate!)
            let expDays = Double((selectedItem?.foodItem?.expDays) ?? 0)
        }else {
            expiredDate = "None"
        }
        
        
        let daysPassed = Date().days(from: userCreatedAt!)
        information = [selectedItem?.foodItem?.foodDescription, createdDate, expiredDate, String(daysPassed)]
    }
}

//MARK: UITableView Delegate and Data Source Methods
extension Inventory_Item_VC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemInfoCell") as! Inventory_ItemCell
        let currentItem =  selectedItem
        cell.titleLabel.text = titles[indexPath.item]
        cell.infoLabel.text = information[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
}

extension Date {
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {

        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        return ""
    }
}

