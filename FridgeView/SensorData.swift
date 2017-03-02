//
//  SensorData.swift
//  FridgeView
//
//  Created by Ben Cootner on 11/15/16.
//  Copyright © 2016 Ben Cootner. All rights reserved.
//

import Foundation
import Parse

class SensorData: PFObject, PFSubclassing {
    @NSManaged var temperature: NSNumber?
    @NSManaged var humidity: NSNumber?
    @NSManaged var cube: Cube?
    @NSManaged var battery: NSNumber?
    
    class func parseClassName() -> String  {
        return "SensorData"
    }
    
    class func queryForSensorData() -> PFQuery<PFObject> {
        let query = PFQuery(className: "SensorData")
        query.includeKey("cube")
        return query
    }
}
