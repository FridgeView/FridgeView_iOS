//
//  CameraData.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/23/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import Foundation
import Parse

class CameraData: PFObject, PFSubclassing {
    
    @NSManaged var photoFile: PFFile?
    @NSManaged var battery: NSNumber?
    @NSManaged var cube: Cube?
    
    class func parseClassName() -> String  {
        return "CameraData"
    }
    
    class func queryForSensorData() -> PFQuery<PFObject> {
        let query = PFQuery(className: "CameraData")
        query.includeKey("cube")
        return query
    }

    
}
