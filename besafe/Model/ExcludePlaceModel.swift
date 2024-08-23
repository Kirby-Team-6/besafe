//
//  ExcludePlaceModel.swift
//  besafe
//
//  Created by Rifat Khadafy on 21/08/24.
//

import Foundation
import SwiftData

@Model
class ExcludePlaceModel {
    let id: String
    let timeStamp: Date
    
    init(id: String, timeStamp: Date) {
        self.id = id
        self.timeStamp = timeStamp
    }
    
}
