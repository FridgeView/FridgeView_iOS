//
//  CentralHub.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/23/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import Foundation
import Parse

class CentralHub: PFObject, PFSubclassing {
    
    @NSManaged var deviceName: String?
    @NSManaged var macAddress: String?
    @NSManaged var user: User?
    @NSManaged var centralHubData: CentralHubData?
    
    class func parseClassName() -> String  {
        return "CentralHub"
    }
    
    class func queryForCentralHub() -> PFQuery<PFObject> {
        let query = PFQuery(className: "CentralHub")
        return query
    }

}
