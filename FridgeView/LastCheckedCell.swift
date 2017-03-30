//
//  LastCheckedCell.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/27/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit


struct newItem {
    var isCorrect : Bool
    var statusOf1: Bool {
        if userFoodItem.status?.intValue == 1 {
            return true 
        } else {
            return false
        }
    }
    var shouldBeAdded : Bool {
        if (statusOf1) {
            return isCorrect
        } else {
            return !isCorrect
        }
    }
    var userFoodItem : UserFoodItem
}
class LastCheckedCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    var itemsArray = [newItem]()
    weak var delegate: MyFridgeProtocol?
  
    @IBAction func segChanged(_ sender: Any) {
        if (sender as! UISegmentedControl).selectedSegmentIndex == 0 {
            itemsArray[(sender as AnyObject).tag].isCorrect = true
        } else{
            itemsArray[(sender as AnyObject).tag].isCorrect = false
        }
    }
    
}

extension LastCheckedCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  itemsArray.count + 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == itemsArray.count {
            var addArray = [String]()
            var deleteArray = [String]()
            for i in 0..<itemsArray.count {
                if itemsArray[i].shouldBeAdded {
                    addArray.append(itemsArray[i].userFoodItem.objectId!)
                } else {
                    deleteArray.append(itemsArray[i].userFoodItem.objectId!)
                }
            }
            UserFoodItem.deleteItems(arrayOfIds: deleteArray, completion: { (success) in
                UserFoodItem.confirmItems(arrayOfIds: addArray, completion: {[unowned self] (success) in
                    self.delegate?.removeWhatsNew()
                })
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < (itemsArray.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemChangedCell
            //should be added
            let item = itemsArray[indexPath.row]
            cell.segController.tag = indexPath.row
            
            if(itemsArray[indexPath.row].shouldBeAdded) {
                print("\(itemsArray[indexPath.row].userFoodItem.foodItem?.foodName) should be added")
            } else {
                print("\(itemsArray[indexPath.row].userFoodItem.foodItem?.foodName) should NOT be added")
            }
            
            if(item.isCorrect){
                cell.segController.selectedSegmentIndex = 0
            } else {
                cell.segController.selectedSegmentIndex = 1
            }
            
            if(item.statusOf1) {
                cell.itemName.text = "Added \(itemsArray[indexPath.row].userFoodItem.foodItem?.foodName ?? "")"
            } else {
                cell.itemName.text = "Finished \(itemsArray[indexPath.row].userFoodItem.foodItem?.foodName ?? "")"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "doneCell", for: indexPath) as! DoneCell
            return cell
        }
    }
}
