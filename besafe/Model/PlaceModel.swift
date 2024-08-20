//
//  PlaceModel.swift
//  besafe
//
//  Created by Rifat Khadafy on 15/08/24.
//

import Foundation

struct PlaceModel: Codable {
    let businessStatus: String?
    let icon: String?
    let iconBackgroundColor: String?
    let iconMaskBaseURI: String?
    let name: String?
    let openingHours: OpeningHours?
    let placeID: String?
    let types: [String]?
    let userRatingsTotal: Int?
    let vicinity: String?

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case icon
        case iconBackgroundColor = "icon_background_color"
        case iconMaskBaseURI = "icon_mask_base_uri"
        case name
        case openingHours = "opening_hours"
        case placeID = "place_id"
        case types
        case userRatingsTotal = "user_ratings_total"
        case vicinity
    }
}

struct OpeningHours: Codable {
    let openNow: Bool?

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}
