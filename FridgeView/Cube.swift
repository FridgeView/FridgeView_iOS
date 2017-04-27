//
//  Cube.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/20/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import Foundation
import Parse

enum deviceType { 
    case CentralHub
    case CameraCube
    case SensorCube
}

class Cube: PFObject, PFSubclassing {
    @NSManaged var deviceName: String?
    @NSManaged var macAddress: NSNumber?
    @NSManaged var deviceType: NSNumber?
    @NSManaged var centralHub : CentralHub?
    @NSManaged var sensorData: [SensorData]?
    @NSManaged var cameraData: CameraData?

    
    class func parseClassName() -> String  {
        return "Cube"
    }
    
    class func queryForCubes() -> PFQuery<PFObject> {
        let query = PFQuery(className: "Cube")
        return query
    }
    
    func removeCube(completion : @escaping (Bool) -> Void) {
        self.centralHub = nil
        self.saveInBackground { (success, error) in
            completion(success)
        }

    }
    
    
    func rename(name: String, completion : @escaping (Bool) -> Void) {
        self.deviceName = name
        self.saveInBackground { (success, error) in
            completion(success)
        }
    }
    
    //Given a central hub - find all cubes currently linked to central hub
    class func getCubesForCentralHub(deviceType: deviceType?, completion : @escaping ([Cube]?) -> Void){
        let query = queryForCubes()
        //if a device type was specified limit cubes to that device
        if let deviceType = deviceType {
            query.whereKey("deviceType", equalTo: deviceType.hashValue)
            if(deviceType == .SensorCube) {
                query.includeKey("sensorData")
                query.includeKey("sensorData.cube")
            }
            if(deviceType == .CameraCube) {
                query.includeKey("cameraData")
                query.includeKey("cameraData.cube")
            }
        } else {
            query.order(byAscending: "deviceType")
            query.includeKey("sensorData")
            query.includeKey("sensorData.cube")
            query.includeKey("cameraData")
            query.includeKey("cameraData.cube")

        }
        query.whereKey("centralHub", equalTo: User.current()?.defaultCentralHub as Any)
        query.findObjectsInBackground { (cubes, error) in
            if let cubes = cubes as? [Cube] {
                completion(cubes)
            } else {
                completion(nil)
            }

        }
        
    }
    
    
    
}
