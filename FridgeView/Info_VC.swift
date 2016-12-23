//
//  Info_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 11/15/16.
//  Copyright © 2016 Ben Cootner. All rights reserved.
//

import UIKit

class Info_VC: UIViewController {

    @IBOutlet var mainLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        SensorData.getDataForUser { (dataString) in
            if (dataString.count == 0) {
                print("error no data")
            } else {
                self.mainLabel.text = dataString[dataString.count - 1]
            }
        }

    }
}
