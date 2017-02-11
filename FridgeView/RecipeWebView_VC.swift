//
//  RecipeWebView_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/10/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit

class RecipeWebView_VC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var url : URL?

    override func viewDidLoad() {
        super.viewDidLoad()

                if let url = url {
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
