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

    class func parseClassName() -> String  {
        return "UserFoodItem"
    }
    
    class func queryForUserFoodItem() -> PFQuery<PFObject> {
        let query = PFQuery(className: "UserFoodItem")
        query.order(byDescending: "probability")
        return query
    }
    
    class func getInventoryForUser(completion : @escaping ([UserFoodItem]?) -> Void){
        let query = queryForUserFoodItem()
        query.whereKey("user", equalTo: PFUser.current())
        query.includeKey("foodItem")
        query.findObjectsInBackground { (userFoodItems, error) in
            if let userFoodItems = userFoodItems as? [UserFoodItem] {
                completion(userFoodItems)
            } else {
                completion(nil)
            }
        }
    }
}
