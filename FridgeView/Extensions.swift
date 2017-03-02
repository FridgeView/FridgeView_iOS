//
//  Extensions.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/1/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import Foundation

extension NSNumber {
    func convertTemp() -> String {
        if User.current()?.isCelsius?.boolValue == false {
            return String(format: "%.1f",(((self as Float) * 1.8) + 32)) + "°F"
        } else {
            return String(format: "%.1f", (self)) + "°C"
        }
    }
}
