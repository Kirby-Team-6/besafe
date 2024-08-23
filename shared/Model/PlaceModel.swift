//
//  PlaceModel.swift
//  besafe
//
//  Created by Rifat Khadafy on 15/08/24.
//

import Foundation

struct PlaceModel: Codable {
    let id: String
    let location: Location?
    let currentOpeningHours: CurrentOpeningHours?
    let primaryType: String
    let displayName: DisplayName?
    let shortFormattedAddress: String?
}

struct DisplayName: Codable {
    let text, languageCode: String?
}

struct CurrentOpeningHours: Codable {
    let openNow: Bool?
}


struct Location: Codable {
    let latitude, longitude: Double?
}

extension PlaceModel {
    
    // Encode PlaceModel to JSON string
    func toJSONString() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Failed to encode PlaceModel: \(error)")
            return nil
        }
    }
    
    // Decode JSON string to PlaceModel
    static func fromJSONString(_ jsonString: String) -> PlaceModel? {
        let decoder = JSONDecoder()
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to create Data from JSON string")
            return nil
        }
        do {
            let placeModel = try decoder.decode(PlaceModel.self, from: jsonData)
            return placeModel
        } catch {
            print("Failed to decode JSON string: \(error)")
            return nil
        }
    }
}
