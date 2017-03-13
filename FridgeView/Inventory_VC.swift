//
//  Inventory_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/2/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
// color of the box as it ages red=old -> orange -> green
// popup => description, probability,
// foodItem.createdAt = when it is made
//
//Kwon work on this!

import UIKit

class Inventory_VC: UIViewController {

    @IBOutlet weak var InventoryCollectionView: UICollectionView!
    
    
    var userInventory = [UserFoodItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InventoryCollectionView.delegate = self
        InventoryCollectionView.dataSource = self
        UserFoodItem.getInventoryForUser { (userFoodItems) in
            if let userFoodItems = userFoodItems {
                for userFoodItem in userFoodItems {
//                    add Items to the userInventory
                    self.userInventory += [userFoodItem]
                }
                self.InventoryCollectionView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

//MARK: UICollectionViewControllerDelegate & DataSource Methods
extension  Inventory_VC : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userInventory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:InventoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "invenCell", for: indexPath) as! InventoryCell
        
        UserFoodItem.getInventoryForUser { (userFoodItem) in
            if let userFoodItem = userFoodItem {
                let currentItem = self.userInventory[indexPath.item]
//                currentItem.createdAt?.timeIntervalSinceNow //output is the ms?? and convert it into date
                let name = currentItem.foodItem?.foodName
                cell.itemLabel.text = name
            }
        }
        return cell
    }

}
