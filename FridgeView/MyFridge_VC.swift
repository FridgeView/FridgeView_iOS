//
//  MyFridge_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/27/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit
import ParseUI

class MyFridge_VC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    //handler for asycn function
    let group = DispatchGroup()
    var isLoading = false
    
    //items needed for photos zooming in
    let blackBackground = UIView()
    let openedImage = PFImageView()
    var originalPhoto : PFImageView?
    var panTouchPoint = CGPoint()
    var originalCenterY = CGFloat()
    
    
    var fridgeItems = [MyFridgeItem]()
    
    let dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/YY hh:mm a"
        tableView.delegate = self
        tableView.dataSource = self
        fetchCubesForTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blackBackground.frame = self.view.frame
        
        if let originalPhoto = originalPhoto,
        let startingFrame = originalPhoto.superview?.convert(originalPhoto.frame, to: nil) {
            let startingWidth = startingFrame.width
            let startingHeight = startingFrame.height
            let newHeight = (self.view.frame.width / startingWidth) * startingHeight
            let yPosition =  (self.view.frame.height / 2) - (newHeight / 2)
            self.openedImage.frame = CGRect(x: 0, y: yPosition, width: self.view.frame.width, height: newHeight)
            panTouchPoint = CGPoint()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCubesForTable()
    }
    
    func fetchCubesForTable() {
        if isLoading {
            return
        } else {
            isLoading = true
            fridgeItems.removeAll()
            print("fetchForTable")
            group.enter()
            group.enter()
            group.enter()
            User.current()?.refreshUser(completion: { (success) in
                print("done refreshing user")
                self.group.leave()
                self.fetchSensorCubesData()
                self.fetchCentralHubData()
            })
            group.notify(queue: DispatchQueue.main) {
                print("done with dispatch")
                self.fridgeItems.sort(by: {$0.date > $1.date})
                self.isLoading = false
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchSensorCubesData() {
        //get sensorData
        print("get sensor data")
        Cube.getCubesForCentralHub(deviceType: .SensorCube) { (cubesLinkedToHub) in
            if let cubesLinkedToHub = cubesLinkedToHub {
                for cube in cubesLinkedToHub {
                    if let sensorDatasForCube = cube.sensorData {
                        for sensorData in sensorDatasForCube {
                            self.fridgeItems.append(MyFridgeItem(dataType: .SensorData, sensorData: sensorData, centralHubData: nil, date: sensorData.createdAt ?? Date()))
                        }
                    }
                }
                print("done getting sensor")
                self.group.leave()
            }
        }

    }
    
    func fetchCentralHubData() {
        //get central hub data
        print("get central hub data")
        User.current()?.defaultCentralHub?.centralHubData?.refreshData(completion: { (success) in
            if let centralHubData = User.current()?.defaultCentralHub?.centralHubData {
                self.fridgeItems.append(MyFridgeItem(dataType: .CentralHubData, sensorData: nil, centralHubData: centralHubData, date: centralHubData.createdAt ?? Date()))
            }
            print("done getting central hub")
            self.group.leave()
        })

    }
    
    func panPhoto(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            panTouchPoint = panGesture.location(in: panGesture.view)
        case .changed:
            let delta = (panGesture.location(in: panGesture.view).y) - panTouchPoint.y
            panGesture.view?.center.y += delta
        case .ended:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                   self.openedImage.center.y = self.originalCenterY
            }, completion: nil)
        default:
            break
        }
    }
    
    func dismissPhoto() {
        if let originalPhoto = originalPhoto,
        let startingFrame = originalPhoto.superview?.convert(originalPhoto.frame, to: nil){
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.openedImage.frame = startingFrame
                self.blackBackground.alpha = 0

            }, completion: { (isComplete) in
                self.openedImage.removeFromSuperview()
                self.blackBackground.removeFromSuperview()
                originalPhoto.alpha = 1
            })
        }
    }
    
    func animatePhoto(_ sender : UIGestureRecognizer) {
        
        if let imgSender = sender.view as? PFImageView,
            let startingFrame = imgSender.superview?.convert(imgSender.frame, to: nil) {
            
            originalPhoto = imgSender
            
            blackBackground.backgroundColor = UIColor.black
            blackBackground.alpha = 0
            UIApplication.shared.keyWindow?.addSubview(blackBackground)
            
            openedImage.contentMode = .scaleAspectFill
            openedImage.clipsToBounds = true
            openedImage.isUserInteractionEnabled = true
            openedImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MyFridge_VC.dismissPhoto)))
            
            openedImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(MyFridge_VC.panPhoto(_:))))
            
            openedImage.file = imgSender.file
            openedImage.frame = startingFrame
            UIApplication.shared.keyWindow?.addSubview(openedImage)
            
            let startingWidth = imgSender.frame.width
            let startingHeight = imgSender.frame.height
            let newHeight = (self.view.frame.width / startingWidth) * startingHeight
            let yPosition =  (self.view.frame.height / 2) - (newHeight / 2)
    
            imgSender.alpha = 0
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.blackBackground.alpha = 1
                self.openedImage.frame = CGRect(x: 0, y: yPosition, width: self.view.frame.width, height: newHeight)
            }, completion: { (isComplete) in
               self.originalCenterY = self.openedImage.center.y
            })
            
        }
        
        
    }

}

extension MyFridge_VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fridgeItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentFridgeItem = fridgeItems[indexPath.row]
        if currentFridgeItem.dataType == .SensorData {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sensorDataCell", for: indexPath) as! SensorDataCell
           
            if let sensorData =  currentFridgeItem.sensorData {
                cell.cellTitle.text = "\(sensorData.cube?.deviceName ?? "")"
                cell.temperature.text = sensorData.temperature?.convertTemp()
                cell.humidity.text = "\(Double(round(CGFloat(sensorData.humidity ?? 0) * 10)/10))%"
                cell.dateLabel.text = "\(dateFormatter.string(from: sensorData.createdAt ?? Date()))"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "photoDataCell", for: indexPath) as! PhotoDataCell
            
            if let photoData =  currentFridgeItem.centralHubData {
                cell.cellTitle.text = "\(User.current()?.defaultCentralHub?.deviceName ?? "")"
                cell.mainImage.file = photoData.photoFile
                cell.mainImage.loadInBackground()
                cell.mainImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MyFridge_VC.animatePhoto(_:))))
                cell.mainImage.isUserInteractionEnabled = true
                cell.clipsToBounds = true
                cell.dateLabel.text = "\(dateFormatter.string(from: photoData.createdAt ?? Date()))"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if fridgeItems[indexPath.row].dataType == .SensorData {
            return 95.0
        }
        return 185.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(fridgeItems[indexPath.row].dataType == .SensorData) {
            
        }
    }

}
