//
//  Inventory_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/2/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit

class Inventory_VC: UIViewController {
    
    @IBOutlet weak var InventoryCollectionView : UICollectionView!
    var userInventory = [UserFoodItem]()
    var clickedItem : FoodItem?
    var clickedName : String?
    var clickedDescription : String?
    var editFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InventoryCollectionView.delegate = self
        InventoryCollectionView.dataSource = self
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        self.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userInventory.removeAll()
        UserFoodItem.getInventoryForUser { (userFoodItems) in
            if let userFoodItems = userFoodItems {
                for userFoodItem in userFoodItems {
                    self.userInventory += [userFoodItem]
                }
                self.InventoryCollectionView.reloadData()
            }
        }
        
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        self.navigationItem.leftBarButtonItem = addButton
        editFlag = !editFlag
        self.InventoryCollectionView.reloadData()
    }
    
    //    this is a function that calls the alert message with title and message inputs
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addItem(){
        let alert = UIAlertController(title: "Add Item", message: "Enter the new name for the item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.text = ""
            textField.clearButtonMode = UITextFieldViewMode.always
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (didClick) in
            let textField = alert.textFields![0] as UITextField
            
            }))
        self.present(alert, animated: true, completion: nil)
    }
}



//MARK: UICollectionView Delegate and Data Source Methods
extension Inventory_VC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userInventory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:InventoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "invenCell", for: indexPath) as!InventoryCell
        
        let currentItem = userInventory[indexPath.item]
        
        var formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let createdDate: String = formatter.string(from: (currentItem.foodItem?.createdAt)!)
        let expirationDate: Date?
        let percentPassed: Double
        if(currentItem.foodItem?.expDays != nil){
            expirationDate = Calendar.current.date(byAdding: .day, value: currentItem.foodItem?.expDays as! Int, to: (currentItem.foodItem?.createdAt)!)
            let expiredDate: String = formatter.string(from: expirationDate!)
            let daysPassed = Date().days(from: (currentItem.foodItem?.createdAt)!)
            let expDays = Double((currentItem.foodItem?.expDays)!)
            percentPassed = Double(daysPassed)/expDays
        }else {
            percentPassed = 0.0
        }
        
        // this checks if it is in editing mode and display the delete icon or not
        if(editFlag == true) {
            cell.deleteButton.setImage(UIImage(named: "deleteIcon.png"), for: .normal)
            cell.deleteButton.isHidden = false
            cell.deleteButton.tag = indexPath.item
            cell.deleteButton.layer.setValue(indexPath, forKey: "itemDelete")
            cell.deleteButton.addTarget(self, action: #selector(deleteItem), for: UIControlEvents.touchUpInside)
        }else{
            cell.deleteButton.isHidden = true
        }
        
        cell.itemLabel.text = currentItem.foodItem?.foodName
        cell.percentLabel.text = String(format: "%.2f", currentItem.probability!.doubleValue) + "%"
        print(percentPassed)
        
        if(percentPassed > 0.85){
            cell.backgroundColor = UIColor(colorLiteralRed: 1, green: 0.4, blue: 0.4, alpha: 1)
        }else if(percentPassed < 0.80 && percentPassed > 0.50){
            cell.backgroundColor = UIColor(colorLiteralRed: 0.92, green: 0.67, blue: 0.46, alpha: 1)
        }else{
            cell.backgroundColor = UIColor(colorLiteralRed: 0.8, green: 0.95, blue: 0.78, alpha: 1)
        }
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        let cell:InventoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "invenCell", for: indexPath) as!InventoryCell
        let currentItem = userInventory[indexPath.item]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        clickedItem = userInventory[indexPath.item].foodItem
        self.performSegue(withIdentifier: "itemSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "itemSegue") {
            if let dest = segue.destination as? Inventory_Item_VC {
                dest.selectedItem = clickedItem
            }
            
        }
    }
    
    func deleteItem(sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to remove this item from your fridge", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [unowned self] (didClick)  in
            let indexPath:IndexPath = (sender.layer.value(forKey: "itemDelete")) as! IndexPath
            let item = self.userInventory[indexPath.item]
            self.InventoryCollectionView.reloadData()
            item.deleteItem { (success) in
                if (success) {
                    print("deleted item from backend")
                    self.userInventory.remove(at: indexPath.item)
                    self.InventoryCollectionView.reloadData()
                } else {
                    print("didn't work")
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
