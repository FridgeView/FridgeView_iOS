//
//  User.swift
//  FridgeView
//
//  Created by Ben Cootner on 11/12/16.
//  Copyright © 2016 Ben Cootner. All rights reserved.
//

import Foundation
import Parse

class User: PFUser {

    @NSManaged var defaultCentralHub : CentralHub?
    @NSManaged var isCelsius : NSNumber?
    
    override class func current() -> User? {
        return PFUser.current() as? User
    }
    
    //MARK: Querys
    class func userQuery() -> PFQuery<PFObject> {
        let query = self.query()!
        query.includeKey("defaultCentralHub")
        query.includeKey("defaultCentralHub.CentralHubData")
        return query
    }
    
    func changeTempUnits(isCelsius : Bool, completion: @escaping (Bool) -> Void) {
        User.current()?.isCelsius = isCelsius as NSNumber?
        User.current()?.saveInBackground(block: { (success, error) in
            completion(success)
        })
    }
    
    func logUserOut(completion : @escaping (Bool) -> Void) {
        User.logOutInBackground { (error) in
            if let error = error {
                print(error)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func removeCentralHub(completion : @escaping (Bool) -> Void) {
        let oldCentralHub = self.defaultCentralHub
        self.defaultCentralHub = nil
        self.saveInBackground { (userSuccess, error) in
            if userSuccess == true {
                oldCentralHub?.removeUser(completion: { (hubSuccess) in
                    completion(hubSuccess)
                })
            } else {
                completion(false)
            }
        }
    }
    
    
    func refreshUser(completion : @escaping (Bool) -> Void) {
        let query = User.userQuery()
        User.current()?.fetchIfNeededInBackground(block: { (user, error) in
            if let user = user {
                query.getObjectInBackground(withId: user.objectId ?? "") { (user: PFObject?, error: Error?) -> Void in
                    if let user = user as? User {
                        self.username = user.username
                        self.defaultCentralHub = user.defaultCentralHub
                        self.isCelsius = user.isCelsius
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        })
    }
}
