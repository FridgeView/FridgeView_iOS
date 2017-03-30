//
//  MyFridge_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/27/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit
import ParseUI

protocol MyFridgeProtocol: class {
    func removeWhatsNew()
}

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
    
    @IBOutlet weak var xButton: UIButton!
    
    var clickedData = SensorData()
    var plotPoints = [String : [plotPoint]]()
    var fridgeItems = [MyFridgeItem]()
    
    let dateFormatter = DateFormatter()

    var showWhatsNewCell = 0
    var newItems = [newItem]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd/YY hh:mm a"
        xButton.alpha = 1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        fetchCubesForTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        blackBackground.frame = self.view.frame
        
//        if let originalPhoto = originalPhoto,
//        let startingFrame = originalPhoto.superview?.convert(originalPhoto.frame, to: nil) {
//            let startingWidth = startingFrame.width
//            let startingHeight = startingFrame.height
//            let newHeight = (self.view.frame.width / startingWidth) * startingHeight
//            let yPosition =  (self.view.frame.height / 2) - (newHeight / 2)
//            self.openedImage.frame = CGRect(x: 0, y: yPosition, width: self.view.frame.width, height: newHeight)
//            panTouchPoint = CGPoint()
//        }
    }
    
    @IBAction func xClicked(_ sender: Any) {
        dismissPhoto()
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
            group.enter()
            User.current()?.refreshUser(completion: { [unowned self] (success) in
                print("done refreshing user")
                self.group.leave()
                self.fetchSensorCubesData()
                self.fetchCameraCubesData()
                self.fetchCentralHubData()
            })
            group.notify(queue: DispatchQueue.main) {
                print("done with dispatch")
                self.fridgeItems.sort(by: {$0.date > $1.date})
                UserFoodItem.getNewItemsForUser(completion: {[unowned self] (addedArray, deletedArray) in
                    self.newItems.removeAll()
                    if (addedArray.count != 0 || deletedArray.count != 0) {
                        self.showWhatsNewCell = 1
                        for i in 0..<addedArray.count {
                            self.newItems.append(newItem(isCorrect: true, userFoodItem: addedArray[i]))
                        }
                        for i in 0..<deletedArray.count {
                            self.newItems.append(newItem(isCorrect: true, userFoodItem: deletedArray[i]))
                        }
                        
                    } else {
                        self.showWhatsNewCell = 0
                    }
                    self.isLoading = false
                    self.tableView.reloadData()
                })
            }
        }
    }

    
    func fetchCameraCubesData() {
        //get sensorData
        print("get camera data")
        Cube.getCubesForCentralHub(deviceType: .CameraCube) { (cubesLinkedToHub) in
            if let cubesLinkedToHub = cubesLinkedToHub {
                for cube in cubesLinkedToHub {
                    if let cameraData = cube.cameraData {
                        self.fridgeItems.append(MyFridgeItem(dataType: .CameraData, data: cameraData, date: cameraData.createdAt ?? Date()))
                    }
                }
                print("done getting camera")
                self.group.leave()
            }
        }
        
    }

    
    func fetchSensorCubesData() {
        //get sensorData
        print("get sensor data")
        Cube.getCubesForCentralHub(deviceType: .SensorCube) { (cubesLinkedToHub) in
            if let cubesLinkedToHub = cubesLinkedToHub {
                self.plotPoints.removeAll()
                for cube in cubesLinkedToHub {
                    var tempPlotArray = self.plotPoints[cube.objectId ?? ""]
                    if let sensorDatasForCube = cube.sensorData {
                        for sensorData in sensorDatasForCube {
                            self.fridgeItems.append(MyFridgeItem(dataType: .SensorData, data: sensorData, date: sensorData.createdAt ?? Date()))
                            
                            if tempPlotArray != nil {
                                tempPlotArray!.append(plotPoint(huimidty: sensorData.humidity as Double? ?? 0, temperature: sensorData.temperature as? Double ?? 0, date: sensorData.createdAt ?? Date()))
                            } else {
                                tempPlotArray = [plotPoint(huimidty: sensorData.humidity as Double? ?? 0, temperature: sensorData.temperature as? Double ?? 0, date: sensorData.createdAt ?? Date())]
                            }
                        }
                    }
                    self.plotPoints[cube.objectId ?? ""] = tempPlotArray
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
                self.fridgeItems.append(MyFridgeItem(dataType: .CentralHubData, data: centralHubData, date: centralHubData.createdAt ?? Date()))
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
                self.xButton.alpha = 0
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
            UIApplication.shared.keyWindow?.addSubview(self.xButton)
            
            openedImage.contentMode = .scaleAspectFill
            openedImage.clipsToBounds = true
            openedImage.isUserInteractionEnabled = true
            openedImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MyFridge_VC.dismissPhoto)))
            
            openedImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(MyFridge_VC.panPhoto(_:))))
            
            openedImage.file = imgSender.file
            openedImage.frame = startingFrame
            UIApplication.shared.keyWindow?.addSubview(openedImage)
            
            //let startingWidth = imgSender.frame.width
            //let startingHeight = imgSender.frame.height
            let newHeight = self.view.frame.width * (480/800)
            let yPosition =  (self.view.frame.height / 2) - (newHeight / 2)
    
            imgSender.alpha = 0
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.xButton.alpha = 1
                self.blackBackground.alpha = 1
                self.openedImage.frame = CGRect(x: 0, y: yPosition, width: self.view.frame.width, height: newHeight)
            }, completion: { (isComplete) in
               self.originalCenterY = self.openedImage.center.y
            })
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "moreDetail") {
            if let destination_VC = segue.destination as? InDetail_VC {
                destination_VC.passedData = clickedData
                destination_VC.plots.removeAll()    
                if let plotPoints = self.plotPoints[clickedData.cube?.objectId ?? ""] {
                    destination_VC.plots = plotPoints
                }
            }
        }
    }

}

extension MyFridge_VC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fridgeItems.count + 1 + showWhatsNewCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "spacerCell", for: indexPath) 
            return cell
        }
        if indexPath.row == 1 && showWhatsNewCell == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastChecked", for: indexPath) as! LastCheckedCell
            cell.itemsArray = self.newItems
            cell.delegate = self
            cell.tableView.flashScrollIndicators()
            cell.tableView.delegate = cell
            cell.tableView.dataSource = cell
            cell.tableView.reloadData() 
            return cell
        }
        let currentFridgeItem = fridgeItems[indexPath.row - 1 - showWhatsNewCell]
        if currentFridgeItem.dataType == .SensorData {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sensorDataCell", for: indexPath) as! SensorDataCell
           
            if let sensorData =  currentFridgeItem.data as? SensorData {
                cell.cellTitle.text = "\(sensorData.cube?.deviceName ?? "")"
                cell.temperature.text = sensorData.temperature?.formatTemp()
                cell.humidity.text = sensorData.humidity?.formatHum()
                cell.dateLabel.text = "\(dateFormatter.string(from: sensorData.createdAt ?? Date()))"
            }
            return cell
        } else if currentFridgeItem.dataType == .CameraData {
            let cell = tableView.dequeueReusableCell(withIdentifier: "photoDataCell", for: indexPath) as! PhotoDataCell
            
            if let cameraData =  currentFridgeItem.data as? CameraData {
                cell.cellTitle.text = "\(cameraData.cube?.deviceName ?? "")"
                cell.mainImage.file = cameraData.photoFile
                cell.mainImage.loadInBackground()
                cell.mainImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MyFridge_VC.animatePhoto(_:))))
                cell.mainImage.isUserInteractionEnabled = true
                cell.mainImage.clipsToBounds = true
                cell.dateLabel.text = "\(dateFormatter.string(from: cameraData.createdAt ?? Date()))"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "photoDataCell", for: indexPath) as! PhotoDataCell
            
            if let photoData =  currentFridgeItem.data as? CentralHubData {
                cell.cellTitle.text = "\(User.current()?.defaultCentralHub?.deviceName ?? "")"
                cell.mainImage.file = photoData.photoFile
                cell.mainImage.loadInBackground()
                cell.mainImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MyFridge_VC.animatePhoto(_:))))
                cell.mainImage.isUserInteractionEnabled = true
                cell.mainImage.clipsToBounds = true
                cell.dateLabel.text = "\(dateFormatter.string(from: photoData.createdAt ?? Date()))"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 10.0
        } else if showWhatsNewCell == 1 {
            if(indexPath.row == 1) {
                return 195.0
            }
            else if fridgeItems[indexPath.row - 2].dataType == .SensorData {
                return 95.0
            }
        } else if fridgeItems[indexPath.row - 1].dataType == .SensorData {
            return 95.0
        }
        return 195.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
             return
        }
        if showWhatsNewCell == 1  {
            if indexPath.row == 1 {
                return
            } else {
                if(fridgeItems[indexPath.row - 2].dataType == .SensorData) {
                    if let sensorData = fridgeItems[indexPath.row - 2].data as? SensorData {
                        clickedData = sensorData
                        self.performSegue(withIdentifier: "moreDetail", sender: self)
                    }
                }
            }
        } else if(fridgeItems[indexPath.row - 1].dataType == .SensorData) {
            if let sensorData = fridgeItems[indexPath.row - 1].data as? SensorData {
                clickedData = sensorData
                self.performSegue(withIdentifier: "moreDetail", sender: self)
            }
        }
    }

}

extension MyFridge_VC: MyFridgeProtocol {
    func removeWhatsNew() {
        if showWhatsNewCell == 1 {
            showWhatsNewCell = 0
            let indexPath = IndexPath(row: 1, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
}
