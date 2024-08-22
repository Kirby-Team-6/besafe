//
//  RouteModel.swift
//  besafe
//
//  Created by Rifat Khadafy on 22/08/24.
//

import Foundation

struct RouteModel {
    let distance: Double
    let time: TimeInterval
    let steps: [StepsRoute]
    let polyLine: [RoutePolyline]
}

struct RoutePolyline {
    let latitude: Double
    let longitude: Double
    init(_ latitude: Double,_ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct StepsRoute {
    let instruction: String
    let latitude: Double
    let longitude: Double
}
