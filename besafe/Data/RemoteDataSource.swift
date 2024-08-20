//
//  RemoteDataSource.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation

protocol RemoteDataSource {
    func getNearbyPlaces(_ latitude: Double, longitude: Double) async -> Result<[PlaceModel], Error>
}

class RemoteDataSourceImpl: RemoteDataSource {
    func getNearbyPlaces(_ latitude: Double, longitude: Double) async -> Result<[PlaceModel], Error> {
        do {
            let baseUrl = if true {
                "https://places.googleapis.com"
            } else {
                "https://a287ae43-2c35-45ae-aa01-39781319dc3a.mock.pstmn.io"
            }
            
            let urlComps = URLComponents(string: "\(baseUrl)/v1/places:searchNearby")!
            
            guard let url = urlComps.url else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("AIzaSyABab06jHMfr3Od5-WYiJzxajdBrQh6odA", forHTTPHeaderField: "X-Goog-Api-Key")
            request.setValue("places.id,places.primaryType,places.location,places.currentOpeningHours.openNow,places.shortFormattedAddress,places.displayName", forHTTPHeaderField:"X-Goog-FieldMask")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "includedTypes": [
                    "police", "hospital", "church", "convenience_store", "department_store", "fire_station", "gas_station", "hindu_temple", "mosque", "shopping_mall", "synagogue", "university", "hotel", "resort_hotel", "bank", "supermarket"
                ],
                "maxResultCount": 15,
                "locationRestriction": [
                    "circle": [
                        "center": [
                            "latitude": latitude,
                            "longitude": longitude,
                        ],
                        "radius": 1000
                    ]
                ]
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            
            if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let resultDict = jsonDict["places"]
                
                let resultData = try JSONSerialization.data(withJSONObject: resultDict as Any, options: [])
                
                let places = try JSONDecoder().decode([PlaceModel].self, from: resultData)
                
                return .success(places)
            } else {
                throw URLError(.cannotDecodeRawData)
            }
            
            
        } catch {
            return .failure(error)
        }
    }
    
    
}
