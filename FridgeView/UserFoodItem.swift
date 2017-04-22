//
//  UserFoodItem.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/15/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import Foundation
import Parse

class UserFoodItem: PFObject, PFSubclassing {
    @NSManaged var foodItem: FoodItem?
    @NSManaged var user : User?
    @NSManaged var probability: NSNumber?
    @NSManaged var status: NSNumber?

    class func parseClassName() -> String  {
        return "UserFoodItem"
    }
    
    class func queryForUserFoodItem() -> PFQuery<PFObject> {
        let query = PFQuery(className: "UserFoodItem")
        query.order(byDescending: "probability")
        return query
    }
    class func getNewItemsForUser(completion : @escaping ([UserFoodItem], [UserFoodItem]) -> Void){
        let query = PFQuery(className: "UserFoodItem")
        query.whereKey("user", equalTo: PFUser.current())
        query.whereKey("status", notEqualTo: 0)
        query.includeKey("foodItem")
        var addedItems = [UserFoodItem]()
        var deleteItems = [UserFoodItem]()
        query.findObjectsInBackground { (userFoodItems, error) in
            if let userFoodItems = userFoodItems as? [UserFoodItem] {
                for item in userFoodItems {
                    if (item.status?.intValue == -1) {
                        deleteItems.append(item)
                    } else {
                        addedItems.append(item)
                    }
                }
                print(addedItems.count)
                completion(addedItems, deleteItems)
            } else {
                completion([UserFoodItem]()
                    , [UserFoodItem]())
            }
        }
    }
    class func getInventoryForUser(completion : @escaping ([UserFoodItem]?) -> Void){
        let query = queryForUserFoodItem()
        query.whereKey("user", equalTo: PFUser.current())
        query.whereKey("status", equalTo: 0)
        query.includeKey("foodItem")
        query.findObjectsInBackground { (userFoodItems, error) in
            if let userFoodItems = userFoodItems as? [UserFoodItem] {
                completion(userFoodItems)
            } else {
                completion(nil)
            }
        }
    }
    
    class func deleteItems(arrayOfIds: [String], completion : @escaping (Bool) -> Void) {
        PFCloud.callFunction(inBackground: "deleteItems", withParameters: ["items" : arrayOfIds]) { (success, error) in
            if let error = error {
                print(error)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    class func confirmItems(arrayOfIds: [String], completion : @escaping (Bool) -> Void) {
        PFCloud.callFunction(inBackground: "changeItemsToStatus0", withParameters: ["items" : arrayOfIds]) { (success, error) in
            if let error = error {
                print(error)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    class func addItem(nameOfItem: String, completion: @escaping (Bool) -> Void) {
        PFCloud.callFunction(inBackground: "addUserItem", withParameters: ["item" : nameOfItem, "userID" : User.current()?.objectId ?? "" ]) { (success, error) in
            if let error = error {
                print(error)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func deleteItem(completion : @escaping (Bool) -> Void) {
        self.deleteInBackground { (success, error) in
            if let error = error {
                print(error)
                completion(false)
            } else {
                completion(success)
            }
        }
    }

}
