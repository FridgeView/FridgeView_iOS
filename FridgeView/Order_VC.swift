//
//  Order_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/1/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit

class Order_VC: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://www.amazon.com/pantry")  {
            let request = URLRequest(url: url)
            webView.scalesPageToFit = true
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
