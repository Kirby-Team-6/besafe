//
//  RouteModel.swift
//  besafe
//
//  Created by Rifat Khadafy on 22/08/24.
//

import Foundation

struct RouteModel: Codable {
    let distance: Double
    let placeDirectionName: String
    let time: TimeInterval
    let steps: [StepsRoute]
    let polyLine: [RoutePolyline]
}

struct RoutePolyline: Codable {
    let latitude: Double
    let longitude: Double

    init(_ latitude: Double, _ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct StepsRoute: Codable {
    let instruction: String
    let latitude: Double
    let longitude: Double
}

extension RouteModel {
    
    // Encoding function to convert RouteModel to JSON data
    func encodeToJSON() -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // To make the JSON output readable
        do {
            let jsonData = try encoder.encode(self)
            return jsonData
        } catch {
            print("Error encoding RouteModel: \(error)")
            return nil
        }
    }
    
    // Encoding function to convert RouteModel to JSON string
    func encodeToJSONString() -> String? {
        if let jsonData = self.encodeToJSON() {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
    
    // Decoding function to convert JSON data back to RouteModel
    static func decodeFromJSON(jsonData: Data) -> RouteModel? {
        let decoder = JSONDecoder()
        do {
            let routeModel = try decoder.decode(RouteModel.self, from: jsonData)
            return routeModel
        } catch {
            print("Error decoding RouteModel: \(error)")
            return nil
        }
    }
    
    // Decoding function to convert JSON string back to RouteModel
    static func decodeFromJSONString(jsonString: String) -> RouteModel? {
        if let jsonData = jsonString.data(using: .utf8) {
            return decodeFromJSON(jsonData: jsonData)
        }
        return nil
    }
}
