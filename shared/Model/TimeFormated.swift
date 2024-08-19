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
}

struct TimeFormated {
    let time: Int
    let type: TimeFormatedType
}
