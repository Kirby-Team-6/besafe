//
//  Extension.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation

extension Double {
    func toStringWithDecimals(_ decimals: Int) -> String {
        return String(format: "%.\(decimals)f", self)
    }
    func secTimeFormatted() -> TimeFormated {
        if self < 60 {
            return TimeFormated(time: Int(self.rounded()), type: TimeFormatedType.sec)
        } else if self < 3600 {
            let minutes = self / 60
            return TimeFormated(time: Int(minutes.rounded()), type: TimeFormatedType.min)
        } else if self < 86400 {
            let hours = self / 3600
            return TimeFormated(time:  Int(hours.rounded()), type: TimeFormatedType.hours)
        } else {
            let days = self / 86400
            return TimeFormated(time:  Int(days.rounded()), type: TimeFormatedType.days)
        }
    }

}

