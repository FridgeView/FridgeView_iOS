//
//  SignUpPopUp.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/6/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit
import Parse

class SignUpPopUp: PopUpView {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        self.dismissPopUp()
    }

    @IBAction func signUpClicked(_ sender: Any) {
        if password.text != confirmPassword.text {
            self.errorLabel.isHidden = false
            self.errorLabel.text = "Passwords do not match"
        } else if (password.text?.characters.count ?? 0) > 6{
            self.errorLabel.isHidden = false
            self.errorLabel.text = "Password must be greater than 6 characters"
        } else {
            let newUser = PFUser()
            newUser.username = username.text ?? ""
            newUser.email = username.text ?? ""
            newUser.password = password.text ?? ""
            newUser.signUpInBackground { (success, error) in
                if success == true {
                    print("new user made!")
                    self.performSegue(withIdentifier: "setUp", sender: self)
                } else {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "\(error?.localizedDescription ?? "There was an error. Try again")"
                    print("error making new user :(")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "setUp") {
            if let destinationVC = segue.destination as? SetUpWifi_VC {
                destinationVC.userEmail = username.text ?? ""
                destinationVC.userPassword = password.text ?? ""
            }
        }
    }

}
