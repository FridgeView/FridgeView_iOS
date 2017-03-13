//
//  FoodItem.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/15/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import Foundation
import Parse

class FoodItem: PFObject, PFSubclassing {
    @NSManaged var foodName: String?
    @NSManaged var foodDescription: String?
    @NSManaged var expDays: NSNumber? // days
    
    class func parseClassName() -> String  {
        return "FoodItem"
    }
    
    class func queryForFoodItem() -> PFQuery<PFObject> {
        let query = PFQuery(className: "FoodItem")
        return query
    }
}
