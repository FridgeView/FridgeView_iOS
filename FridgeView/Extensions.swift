//
//  Extensions.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/1/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import Foundation
import SystemConfiguration

extension NSNumber {
    func formatTemp() -> String {
        if User.current()?.isCelsius?.boolValue == false {
            return String(format: "%.1f",(((self as Float) * 1.8) + 32)) + "°F"
        } else {
            return String(format: "%.1f", (self as Float)) + "°C"
        }
    }
    
    func formatHum() -> String {
        return String(format: "%.1f", (self as Float)) + "%"
    }
}

extension Double {
    func convertTemp() -> Double{
        if(User.current()?.isCelsius?.boolValue == false) {
            return ((((self) ) * 1.8) + 32)
        } else {
            return self
        }
    }
    func formatTemp() -> String {
        if User.current()?.isCelsius?.boolValue == false {
            return String(format: "%.1f",(((self) * 1.8) + 32)) + "°F"
        } else {
            return String(format: "%.1f", (self)) + "°C"
        }
    }
}

protocol Utilities {
}

extension NSObject:Utilities{
    
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
}
