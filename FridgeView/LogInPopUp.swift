//
//  LogInPopUp.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/6/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit
import Parse

var count = 0

class LogInPopUp: PopUpView {

    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        count += 1
        print("log in view init Count \(count)")
      
    }
    
    deinit {
        count -= 1
        print ("log in view deinit. Count \(count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "setUp") {
            if let destinationVC = segue.destination as? SetUpWifi_VC {
                destinationVC.userEmail = username.text ?? ""
                destinationVC.userPassword = password.text ?? ""
            }
        }
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        self.dismissPopUp()
    }
    
    @IBAction func logInClicked(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: username.text ?? "", password: password.text ?? "" ) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.errorLabel.isHidden = false
                self.errorLabel.text = "\(error.localizedDescription)"
            } else {
                if ((user as? User)?.defaultCentralHub == nil) {
                    self.performSegue(withIdentifier: "setUp", sender: self)
                } else {
                    self.performSegue(withIdentifier: "logIn", sender: self)
                }
            }
    
        }
    }
}
