//
//  SetUpWifi_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/13/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import QRCode

class SetUpWifi_VC: UIViewController {
    
    @IBOutlet weak var encryptionType: UIPickerView!
    let encryptionTypes = ["WPA2", "WEP", "WPA"]
    var userPassword = String()
    var userEmail = String()
    
    @IBOutlet weak var topBanner: UILabel!
    @IBOutlet weak var wifiName: UITextField!
    @IBOutlet weak var wifiPassword: UITextField!
    var isConnectedToWifi = false
    var timer = Timer()
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var qrLabel: UILabel!
    @IBOutlet weak var qrView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        overlayView.alpha = 0
        wifiPassword.delegate = self
        encryptionType.delegate = self
        encryptionType.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SetUpWifi_VC.timerMethod), userInfo: nil, repeats: true)
        refresh()
    }
    func timerMethod() {
        print (encryptionTypes[encryptionType.selectedRow(inComponent: 0)])
        if(overlayView.alpha == 1) {
            User.current()?.refreshUser(completion: { (success) in
                if ((User.current()?.defaultCentralHub) != nil) {
                    print("Hub found")
                    self.timer.invalidate()
                    self.performSegue(withIdentifier: "finishSetUp", sender: self)
                } else {
                    print("Hub not found")
                    self.refresh()
                }
            })
        } else {
            self.refresh()
        }
    }
    
    func refresh() {
        switch currentReachabilityStatus {
        case .notReachable:
            settingsButton.isHidden = false
            isConnectedToWifi = false
            topBanner.text = "Connect to Wifi to continue!"
            topBanner.backgroundColor = UIColor.red
            
        case .reachableViaWWAN:
            settingsButton.isHidden = false
            isConnectedToWifi = false
            topBanner.text = "Connect to Wifi to continue!"
            topBanner.backgroundColor = UIColor.orange
            
        case .reachableViaWiFi:
            settingsButton.isHidden = true
            isConnectedToWifi = true
            topBanner.text = "Currently connected to Wifi"
            topBanner.backgroundColor = UIColor.green
            getWifiName()
        }
        
        if isConnectedToWifi {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func continueClicked(_ sender: Any) {
        if isConnectedToWifi {
            if let password = wifiPassword.text,
                let name = wifiName.text {
                if password.isEmpty {
                    let alert = UIAlertController(title: "You must enter the password for your wifi network!", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    wifiPassword.resignFirstResponder()
                    let qrCode = QRCode("{'Type':'Wifi','WifiName':'\(name)',WifiPassword:'\(password),'WifiEncryption':'\(encryptionType.selectedRow(inComponent: 0))','UserEmail':'\(userEmail)','UserPassword':'\(userPassword)'}")
                    if let qrImage = qrCode?.image {
                        qrView.image = qrImage
                        UIView.animate(withDuration: 0.5) {
                            self.overlayView.alpha = 1
                        }
                    }
                }
            }
        }
    }
    @IBAction func reEnterClicked(_ sender: Any) {
        self.wifiPassword.text = nil
        refresh()
        UIView.animate(withDuration: 0.5) {
            self.overlayView.alpha = 0
        }
    }
    @IBAction func goToSettingsClicked(_ sender: Any) {
        let url:NSURL! = NSURL(string : "App-Prefs:root=WIFI")
        UIApplication.shared.openURL(url as URL)
    }
    
    func getWifiName(){
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    print(interfaceInfo)
                    if let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String {
                        self.wifiName.text = ssid
                    }
                    break
                }
            }
        }
    }
}
extension SetUpWifi_VC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return encryptionTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return encryptionTypes[row]
    }
    
}
extension SetUpWifi_VC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
