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
