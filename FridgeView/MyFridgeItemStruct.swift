//
//  MyFridgeItemStruct.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/27/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import Foundation

enum dataType {
    case CentralHubData
    case CameraData
    case SensorData
}


struct MyFridgeItem {
    var dataType : dataType
    var data : AnyObject?
    var date : Date
    
}
