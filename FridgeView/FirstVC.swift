//
//  FirstVC.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/13/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit
import AVFoundation

class FirstVC: UIViewController {

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    var avPlayer : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    var paused : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.blurView.alpha = 0.82
        self.blurView.alpha = 0
        
        let theURL = Bundle.main.url(forResource:"FridgeView", withExtension: "mov")
        
        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
        paused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
    
    func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
    
    deinit {
        print("First VC deinitalized")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        blurView.frame = self.view.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurView)
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.alpha = 0.82
        }, completion: { (isComplete) in
            self.performSegue(withIdentifier: "signUp", sender: self)
        })

        
    }
    
    @IBAction func logInClicked(_ sender: Any) {
        blurView.frame = self.view.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurView)
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.alpha = 0.82
        }, completion: { (isComplete) in
            self.performSegue(withIdentifier: "logIn", sender: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destingationVC = segue.destination as? PopUpView {
            destingationVC.delegate = self
        }
    }

}

extension FirstVC: popUpDelegate {
    func dismissBlur() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.alpha = 0
        }) { (isComplete) in
            self.blurView.removeFromSuperview()
        }
    }
}
