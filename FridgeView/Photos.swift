//
//  File.swift
//  FridgeView
//
//  Created by Ben Cootner on 11/12/16.
//  Copyright © 2016 Ben Cootner. All rights reserved.
//

import Foundation
import Parse

class Photos: PFObject, PFSubclassing {
    @NSManaged var encrypStr: String?
    @NSManaged var user : User?
    @NSManaged var device: NSNumber?
    
    class func parseClassName() -> String  {
        return "Photos"
    }
    
    class func queryForPhoto() -> PFQuery<PFObject> {
        let query = PFQuery(className: "Photos")
        return query
    }
    
    class func getPhotoForUser(completion : @escaping ([String]) -> Void) {
        let query = queryForPhoto()
        query.whereKey("user", equalTo: PFUser.current())
        query.findObjectsInBackground { (photos, error) in
            if let photos = photos as? [Photos] {
                var arrayOfEncryp = [String]()
                for photo in photos {
                    if let encrypString = photo.encrypStr {
                        arrayOfEncryp.append(encrypString)
                    }
                }
                completion(arrayOfEncryp)
            } else {
                //error 
                completion([String]())
            }
        }
    }
}
