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
    var item : Any?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.blurView.alpha = 0.82
        self.blurView.alpha = 0
        self.tabBar.barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.black
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPopUp(segueName : String, item : Any?) {
        blurView.frame = self.view.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurView)
        UIView.animate(withDuration: 0.3, animations: {
             self.blurView.alpha = 0.82
        }, completion: { (isComplete) in
            self.performSegue(withIdentifier: segueName, sender: self)
        })
        self.item = item
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destingationVC = segue.destination as? PopUpView {
            destingationVC.delegate = self
            if let item = self.item {
                destingationVC.item = item
            }
        }
    }

}

extension TabBarController: popUpDelegate {
    func dismissBlur() {
        UIView.animate(withDuration: 0.3, animations: {
               self.blurView.alpha = 0
        }) { (isComplete) in
            self.blurView.removeFromSuperview()
        }
    }
}
