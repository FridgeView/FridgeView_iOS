//
//  TemperaturePrefPopUp.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/1/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit

class TemperaturePrefPopUp: PopUpView {

    @IBOutlet weak var fahrenButton: UIButton!
    @IBOutlet weak var celcButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        fahrenButton.layer.borderWidth = 1.0
        celcButton.layer.borderWidth = 1.0
        fahrenButton.layer.borderColor = UIColor.black.cgColor
        celcButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func fahClicked(_ sender: Any) {
        super.dismissPopUp()
    }
    @IBAction func celsClicked(_ sender: Any) {
        super.dismissPopUp()
    }
    
}
