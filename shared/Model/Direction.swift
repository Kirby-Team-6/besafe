//
//  Direction.swift
//  besafe
//
//  Created by Rifat Khadafy on 19/08/24.
//

import Foundation

enum Direction {
    case turnRight
    case turnLeft
    case bearLeft
    case bearRight
    case straight
    case done
    case none
    
    static func fromInstruction(_ value: String) -> Direction {
        if value.lowercased().contains("bear left") {
            return Direction.bearLeft
        } else if value.lowercased().contains("turn right") {
            return Direction.turnRight
        } else if value.lowercased().contains("turn left") {
            return Direction.turnLeft
        } else if value.lowercased().contains("bear right") {
            return Direction.bearRight
        } else if value.lowercased().contains("continue") {
            return Direction.straight
        } else if value.lowercased().contains("the destination is on") {
            return Direction.done
        } else {
            return Direction.none
        }
    }
    
    func toImageName() -> String? {
        switch self {
        case .turnRight:
            return "turn-right"
        case .turnLeft:
            return "turn-left"
        case .bearLeft:
            return "bear-left"
        case .bearRight:
            return "bear-right"
        case .straight:
            return "straight"
        case .done:
            return "direction-done"
        case .none:
            return nil
        }
    }
}
