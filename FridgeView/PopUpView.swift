//
//  PopUpView.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/1/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit

protocol popUpDelegate {
    func dismissBlur()
}

class PopUpView: UIViewController {

    var item: Any?
    
    var delegate: popUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissPopUp() {
        delegate?.dismissBlur()
        dismiss(animated: true, completion: nil)
    }

}
