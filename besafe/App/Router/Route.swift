//
//  Route.swift
//  besafe
//
//  Created by Rifat Khadafy on 15/08/24.
//

import Foundation

enum Screen: Identifiable, Hashable {
    case page1
    case page2
    case direction
    
    var id: Self { return self }
}

enum Sheet: Identifiable, Hashable {
    case detailTask
    
    var id: Self { return self }
}

enum FullScreenCover: Identifiable, Hashable {
    case addHabit

    var id: Self { return self }
}

extension FullScreenCover {
    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .addHabit:
            hasher.combine("addHabit")
        }
    }
    
    // Conform to Equatable
    static func == (lhs: FullScreenCover, rhs: FullScreenCover) -> Bool {
        switch (lhs, rhs) {
        case (.addHabit, .addHabit):
            return true
        }
    }
}

