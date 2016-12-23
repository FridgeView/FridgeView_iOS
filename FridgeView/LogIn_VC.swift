//
//  LogIn_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 11/15/16.
//  Copyright © 2016 Ben Cootner. All rights reserved.
//

import UIKit
import Parse

class LogIn_VC: UIViewController {

    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goButtonClicked(_ sender: Any){
        PFUser.logInWithUsername(inBackground: username.text ?? "", password: password.text ?? "" ) { (user, error) in
                if let error = error {
                    self.errorLabel.text = "\(error.localizedDescription)"
                } else {
                self.performSegue(withIdentifier: "logIn", sender: self)
            }
        }
    }
}
