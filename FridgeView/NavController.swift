//
//  NavController.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/7/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit

class NavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationBar.barTintColor = UIColor(red:0.42, green:0.40, blue:0.68, alpha:1.0)
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 23)!]
    }
}
