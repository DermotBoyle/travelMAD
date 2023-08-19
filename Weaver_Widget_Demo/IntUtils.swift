//
//  IntUtils.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 4/4/23.
//

import Foundation


extension Int {
    func secondsToMinutes() -> Int {
          return self / 60
      }
    
    func metersToKilometers(places: Int) -> String {
        return String(format:"%.\(places)f", Double(self) / 1000)
    }
}

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
