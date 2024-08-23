//
//  TimeFormated.swift
//  besafe
//
//  Created by Rifat Khadafy on 18/08/24.
//

import Foundation

enum TimeFormatedType {
    case hours
    case sec
    case min
    case days
    
    var stringValue: String {
        switch self {
        case .hours:
            return "hours"
        case .sec:
            return "sec"
        case .min:
            return "min"
        case .days:
            return "days"
        }
    }
}

struct TimeFormated {
    let time: Int
    let type: TimeFormatedType
}
