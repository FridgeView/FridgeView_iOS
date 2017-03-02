//
//  TabBarController.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/10/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    //27 9 39
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.blurView.alpha = 0.82
        self.blurView.alpha = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPopUp(segueName : String) {
        blurView.frame = self.view.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurView)
        UIView.animate(withDuration: 0.3, animations: {
             self.blurView.alpha = 0.82
        }, completion: { (isComplete) in
            self.performSegue(withIdentifier: segueName, sender: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destingationVC = segue.destination as? PopUpView {
            destingationVC.delegate = self 
        }
    }

}

extension TabBarController: tabBarDelegate {
    func dismissBlur() {
        UIView.animate(withDuration: 0.3, animations: {
               self.blurView.alpha = 0
        }) { (isComplete) in
            self.blurView.removeFromSuperview()
        }
    }
}
