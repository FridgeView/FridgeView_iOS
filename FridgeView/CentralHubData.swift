//
//  CentralHubData.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/23/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import Foundation
import Parse

class CentralHubData: PFObject, PFSubclassing {
    
    @NSManaged var photoFile: PFFile?
    @NSManaged var battery: NSNumber?
    @NSManaged var centralHub: CentralHub?
    
    class func parseClassName() -> String  {
        return "CentralHubData"
    }
    
    class func queryForCentralHubData() -> PFQuery<PFObject> {
        let query = PFQuery(className: "CentralHubData")
        return query
    }
    
    func refreshData(completion : @escaping (Bool) -> Void) {
        self.fetchInBackground { (centralHubData, error) in
            if let centralHubData = centralHubData as? CentralHubData {
                self.photoFile = centralHubData.photoFile
                self.battery = centralHubData.battery
                self.centralHub = centralHubData.centralHub
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    class func getCentralHubData(centralHubID: String, completion : @escaping ([CentralHubData]?) -> Void) {
        let query = queryForCentralHubData()
        query.whereKey("centralHub", equalTo: centralHubID)
        query.findObjectsInBackground { (centralHubDatas, error) in
            if let centralHubDatas = centralHubDatas as? [CentralHubData] {
                completion(centralHubDatas)
            } else {
                completion(nil)
            }
        }
    }
    
}
