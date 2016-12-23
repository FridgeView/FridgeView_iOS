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

    override class func current() -> User? {
        return PFUser.current() as? User
    }
    
    //MARK: Querys
    class func userQuery() -> PFQuery<PFObject> {
        let query = self.query()!
        return query
    }
}
