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
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    func refresh() {
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
            return 5
        } else {
            return cubes.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 && indexPath.row != 0 {
            return true
        }
        return false
    }

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Remove") { (action, indexPath) in
            if (indexPath.section == 1 && indexPath.row == 1) {
                //remove Central Hub
                let alert = UIAlertController(title: "Are you sure?", message: "Removing this Central Hub will log you out!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (clicked) in
                    User.current()?.removeCentralHub(completion: { (success) in
                        if success == true {
                            User.current()?.logUserOut(completion: { (success2) in
                                if(success2) {
                                    self.performSegue(withIdentifier: "logOut", sender: self)
                                }
                            })
                        }
                    })
                }))
                self.present(alert, animated: true, completion: {
                    self.tableView.setEditing(false, animated: true)
                })
            } else if (indexPath.section == 1 && indexPath.row != 0) {
                //remove cube
                let currentCube = self.cubes[indexPath.row - 2]
                currentCube.removeCube(completion: { (success) in
                    if(success) {
                        self.refresh()
                    }
                })
            }
        }
        return [deleteAction]
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
            } else if indexPath.row == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell
                if User.current()?.isCelsius?.boolValue == false {
                    cell.mainLabel.text = "Temperature Units: Fahrenheit"
                } else {
                    cell.mainLabel.text = "Temperature Units: Celsius"
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell
                cell.mainLabel.text = "Log Out"
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
                cell.icon.image = UIImage(named: "centralHubIcon")
                cell.batteryIcon.image = nil
                //cell.batteryIcon.image = UIImage(named: "battery80.png")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cubeInfo", for: indexPath) as! CubeInfoCell
                let currentCube = cubes[indexPath.row - 2] //2 cells down
                cell.cubeTitle.text = currentCube.deviceName
                if(currentCube.deviceType == 2) {
                    cell.icon.image = UIImage(named: "sensorCubeIcon")
                    cell.batteryIcon.image = nil
//                    if currentCube.sensorData?.count > 0 {
//                        if let sensorData = currentCube.sensorData?[0] {
//                          cell.batteryIcon.image = UIImage(named: getBatteryImage(battery: sensorData.battery))
//                        }
//                    }
                    
                } else if (currentCube.deviceType == 1) {
                    cell.batteryIcon.image = nil
                    cell.icon.image = UIImage(named: "cameraCubeIcon")
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
                let alert = UIAlertController(title: "Are you in the USA or the rest of the world?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Fahrenheit", style: .default, handler: { (complete) in
                    User.current()?.changeTempUnits(isCelsius: false, completion: { (success) in
                        if (success) {
                            let indexPath = IndexPath(row: 3 , section: 0)
                            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                        }
                    })
                   
                }))
                alert.addAction(UIAlertAction(title: "Celsius", style: .default, handler: { (complete) in
                    User.current()?.changeTempUnits(isCelsius: true, completion: { (success) in
                        if (success) {
                            let indexPath = IndexPath(row: 3 , section: 0)
                            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                        }
                    })
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
            if indexPath.row == 4 {
                let alert = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (complete) in
                        User.current()?.logUserOut(completion: { (didLogOut) in
                            if(didLogOut) {
                                self.performSegue(withIdentifier: "logOut", sender: self)
                            }
                        })
                    }))
                self.present(alert, animated: true, completion: nil)
            }
        } else if indexPath.section == 1 {
            if indexPath.row != 0 {
                if indexPath.row == 1 {
                    //Central Hub 
                    let centralHub = User.current()?.defaultCentralHub
                    let alert = UIAlertController(title: "Change Central Hub Name", message: "Enter the new name for your Central Hub", preferredStyle: .alert)
                    alert.addTextField(configurationHandler: { (textField) in
                        textField.text = "\(centralHub?.deviceName ?? "")"
                        textField.clearButtonMode = UITextFieldViewMode.always
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                    alert.addAction(UIAlertAction(title: "Change Name", style: .default, handler: { (didClick) in
                        let textField = alert.textFields![0] as UITextField
                        centralHub?.rename(name: textField.text ?? "", completion: { (sucess) in
                            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                        })
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let currentCube = self.cubes[indexPath.row - 2]
                    let alert = UIAlertController(title: "Change Cube Name", message: "Enter the new name for this Cube", preferredStyle: .alert)
                    alert.addTextField(configurationHandler: { (textField) in
                        textField.text = "\(currentCube.deviceName ?? "")"
                        textField.clearButtonMode = UITextFieldViewMode.always
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                    alert.addAction(UIAlertAction(title: "Change Name", style: .default, handler: { (didClick) in
                        let textField = alert.textFields![0] as UITextField
                        currentCube.rename(name: textField.text ?? "", completion: { (sucess) in
                            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                        })
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
