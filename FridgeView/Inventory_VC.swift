//
//  Inventory_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/2/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

//Kwon work on this!

import UIKit

class Inventory_VC: UIViewController {

    var userInventory = [UserFoodItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserFoodItem.getInventoryForUser { (userFoodItem) in
            if let userFoodItem = userFoodItem {
                    self.userInventory = userFoodItem
                    /* Ex:
                        self.collectionView.reloadData()
                        --in collection view --
                 
                        let currentItem = userInventory[indexPath.item]
                        let name = currentItem.foodItem.foodName
                        let description = currentItem.foodItem.description
                        let name = currentItem.foodItem.expdays
                 
                    */
            }
        }
    }
}
