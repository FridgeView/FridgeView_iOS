//
//  Profile_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/28/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit
import ParseUI

class Profile_VC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cubes = [Cube]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let view = UIView()
        view.backgroundColor = UIColor.red
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        User.current()?.refreshUser(completion: { (isComplete) in
            if (isComplete) {
                Cube.getCubesForCentralHub(deviceType: nil, completion: { (cubesForCentralHub) in
                    if let cubesForCentralHub = cubesForCentralHub {
                        self.cubes = cubesForCentralHub
                        self.tableView.reloadData()
                    }
                })
            }
        })
    }
    
    func getBatteryImage(battery : NSNumber?) -> String {
        if let battery = battery as? Int{
            if(battery <= 20) {
                return "battery20.png"
            } else if (battery <= 40) {
                return "battery40.png"
            } else if (battery <= 60) {
                return "batter60.png"
            } else if (battery <= 80) {
                return "battery80.png"
            }
            return "battery100.png"
        }
        return "nil"
    }
    
}

//MARK: Tableview delegate and data source method

extension Profile_VC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return cubes.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! ProfileHeaderCell
                cell.selectionStyle = .none
                cell.mainLabel.text = "Account"
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell
                cell.mainLabel.text = "Email: \(User.current()?.username ?? "")"
                return cell
            } else if indexPath.row == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell
                cell.mainLabel.text = "Password: ********"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell
                cell.mainLabel.text = "Temperature Units: Celsius"
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! ProfileHeaderCell
                cell.selectionStyle = .none
                cell.mainLabel.text = "My FridgeView"
                return cell
            }else if(indexPath.row == 1) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cubeInfo", for: indexPath) as! CubeInfoCell
                cell.cubeTitle.text = User.current()?.defaultCentralHub?.deviceName ?? ""
                cell.icon.image = UIImage(named: "centralHubIcon.png")
                cell.batteryIcon.image = UIImage(named: "battery80.png")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cubeInfo", for: indexPath) as! CubeInfoCell
                let currentCube = cubes[indexPath.row - 2] //2 cells down
                cell.cubeTitle.text = currentCube.deviceName
                if(currentCube.deviceType == 2) {
                    cell.icon.image = UIImage(named: "sensorCubeIcon.png")
                    if let sensorData = currentCube.sensorData?[0] {
                        cell.batteryIcon.image = UIImage(named: getBatteryImage(battery: sensorData.battery))
                    }
                    
                } else if (currentCube.deviceType == 1) {
                    cell.icon.image = UIImage(named: "cameraCubeIcon.png")
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            if indexPath.row == 0 {
                return 45
            } else {
                return 38
            }
        } else {
            if indexPath.row == 0 {
                return 45
            } else {
                return 60
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                if let tabBarController  = self.tabBarController as? TabBarController {
                    tabBarController.showPopUp(segueName: "showTempPrefPopUp")
                }
            }
        }
       
    }
}
