//
//  ChangeDeviceNamePopUp.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/7/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit

class ChangeDeviceNamePopUp: PopUpView {

    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        if let cube = item as? Cube {
           name.text = cube.deviceName
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissClicked(_ sender: Any) {
        dismissPopUp()
    }
    @IBAction func saveClicked(_ sender: Any) {
        dismissPopUp()
        if let cube = item as? Cube {
            cube.rename(name: self.name.text ?? "", completion: { (sucess) in
                print("done")
            })
        }
    }

}
