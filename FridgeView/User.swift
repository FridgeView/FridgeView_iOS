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
