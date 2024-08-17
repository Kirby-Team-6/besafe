//
//  RemoteDataSource.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation

protocol RemoteDataSource {
    func getNearbyPlaces() async -> Result<[PlaceModel], Error>
}

class RemoteDataSourceImpl: RemoteDataSource {
    func getNearbyPlaces() async -> Result<[PlaceModel], Error> {
        do {
            let urlString = "https://a287ae43-2c35-45ae-aa01-39781319dc3a.mock.pstmn.io/maps/api/place/nearbysearch/json?location=-6.299127463352122,106.6716764147274&radius=1500&type=hospital&opennow=true"
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let (data, response) = try await URLSession.shared.data(for: request)
            
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            
            if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let resultDict = jsonDict["results"]
                
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
