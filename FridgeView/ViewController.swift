//
//  ViewController.swift
//  FridgeView
//
//  Created by Ben Cootner on 11/12/16.
//  Copyright © 2016 Ben Cootner. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet var mainImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showPhoto()
    }
    
    func showPhoto() {
        Photos.getPhotoForUser { (encryptStrings) in
            if (encryptStrings.count == 0) {
                print("error no images")
            } else {
                //for i in 0..<encryptStrings.count
                if let imageData = NSData(base64Encoded: encryptStrings[encryptStrings.count - 15], options: []) as? Data
                {
                    if let decodedImageData = UIImage(data: imageData) {
                        //self.mainImg.image = decodedImageData
                        //self.mainImg.layer.setAffineTransform(CGAffineTransform (rotationAngle: 1.5708))
                        let rect = CGRect(x: -145, y: 110, width: self.view.frame.size.height, height: self.view.frame.size.width)
                        let newImg = UIImageView(frame: rect)
                        newImg.image = decodedImageData
                        newImg.layer.setAffineTransform(CGAffineTransform (rotationAngle: 1.5708))
                        self.view.addSubview(newImg)
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

