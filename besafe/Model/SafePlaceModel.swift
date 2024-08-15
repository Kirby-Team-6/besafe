import CoreLocation

struct SafePlace: Codable {
    let name: String
    let types: [String]
    let geometry: Geometry
    
    struct Geometry: Codable {
        let location: Location
        
        struct Location: Codable {
            let lat: Double
            let lng: Double
        }
    }
}
