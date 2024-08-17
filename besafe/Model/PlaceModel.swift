//
//  PlaceModel.swift
//  besafe
//
//  Created by Rifat Khadafy on 15/08/24.
//

import Foundation

struct PlaceModel: Codable {
    let businessStatus: String
    let geometry: Geometry
    let icon: String
    let iconBackgroundColor: String
    let iconMaskBaseUri: String
    let name: String
    let openingHours: OpeningHours?
    let photos: [Photo]?
    let placeId: String
    let plusCode: PlusCode
    let rating: Double?
    let reference: String
    let scope: String
    let types: [String]
    let userRatingsTotal: Int?
    let vicinity: String

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry
        case icon
        case iconBackgroundColor = "icon_background_color"
        case iconMaskBaseUri = "icon_mask_base_uri"
        case name
        case openingHours = "opening_hours"
        case photos
        case placeId = "place_id"
        case plusCode = "plus_code"
        case rating
        case reference
        case scope
        case types
        case userRatingsTotal = "user_ratings_total"
        case vicinity
    }
}

 struct Geometry: Codable {
    let location: Location
    let viewport: Viewport
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}

struct Viewport: Codable {
    let northeast: Location
    let southwest: Location
}

struct OpeningHours: Codable {
    let openNow: Bool

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}

struct Photo: Codable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}

struct PlusCode: Codable {
    let compoundCode: String
    let globalCode: String

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}
