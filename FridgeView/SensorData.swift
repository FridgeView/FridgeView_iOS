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
    @NSManaged var user : User?
    
    class func parseClassName() -> String  {
        return "SensorData"
    }
    
    class func queryForSensorData() -> PFQuery<PFObject> {
        let query = PFQuery(className: "SensorData")
        return query
    }
    
    class func getDataForUser(completion : @escaping ([String]) -> Void) {
        let query = queryForSensorData()
        query.whereKey("user", equalTo: PFUser.current())
        query.findObjectsInBackground { (datas, error) in
            if let data = datas as? [SensorData] {
                var arrayOfData = [String]()
                for d in data {
                    if let temp = d.temperature,
                        let humid = d.humidity {
                        arrayOfData.append("Temp: \(temp) Humid: \(humid)%")
                    }
                }
                completion(arrayOfData)
            } else {
                //error
                completion([String]())
            }
        }
    }


    
}
