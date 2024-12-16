import XCTest
import CoreLocation
@testable import besafe // Replace with the name of your main project

class SafePlaceUtilsTests: XCTestCase {
    
//    func testSortSafePlaces_withOpenPlaces() {
//        // Arrange
//        let userLocation = CLLocation(latitude: -6.200000, longitude: 106.816666)
//        let dummyPlaces = [
//            PlaceModel(id: "1", location: Location(latitude: -6.200000, longitude: 106.816666), currentOpeningHours: CurrentOpeningHours(openNow: true), primaryType: "police", displayName: DisplayName(text: "Police Station", languageCode: "en"), shortFormattedAddress: "Jakarta"),
//            PlaceModel(id: "2", location: Location(latitude: -6.214621, longitude: 106.84513), currentOpeningHours: CurrentOpeningHours(openNow: true), primaryType: "fire_station", displayName: DisplayName(text: "Fire Station", languageCode: "en"), shortFormattedAddress: "Jakarta"),
//            PlaceModel(id: "3", location: Location(latitude: -6.217, longitude: 106.83), currentOpeningHours: CurrentOpeningHours(openNow: false), primaryType: "hospital", displayName: DisplayName(text: "Hospital", languageCode: "en"), shortFormattedAddress: "Jakarta"),
//            PlaceModel(id: "4", location: Location(latitude: -6.22, longitude: 106.82), currentOpeningHours: CurrentOpeningHours(openNow: true), primaryType: "hotel", displayName: DisplayName(text: "Hotel", languageCode: "en"), shortFormattedAddress: "Jakarta")
//        ]
//        
//        let dummyCustomPlaces = [
//            MapPoint(name: "Custom Place 1", coordinate: CLLocationCoordinate2D(latitude: -6.22, longitude: 106.85), markerIndex: 0),
//            MapPoint(name: "Custom Place 2", coordinate: CLLocationCoordinate2D(latitude: -6.22, longitude: 106.813), markerIndex: 0)
//        ]
//        
//        // Act
//        let sortedPlaces = SafePlaceUtils.sortSafePlaces(dummyPlaces, customPlaces: dummyCustomPlaces, from: userLocation)
//        
//        // Assert
//        XCTAssertEqual(sortedPlaces.count, 5, "Expected 5 places in the sorted list, including 2 custom places.")
//        XCTAssertEqual(sortedPlaces.first?.displayName?.text, "Custom Place 1", "Custom places should be prioritized.")
//        XCTAssertEqual(sortedPlaces.last?.displayName?.text, "Hotel", "The last place should be the hotel.")
//    }
    
    func testSortSafePlaces_withNoOpenPlaces() {
        // Arrange
        let userLocation = CLLocation(latitude: -6.200000, longitude: 106.816666)
        let dummyPlaces = [
            PlaceModel(id: "1", location: Location(latitude: -6.200000, longitude: 106.816666), currentOpeningHours: CurrentOpeningHours(openNow: false), primaryType: "police", displayName: DisplayName(text: "Police Station", languageCode: "en"), shortFormattedAddress: "Jakarta"),
            PlaceModel(id: "2", location: Location(latitude: -6.214621, longitude: 106.84513), currentOpeningHours: CurrentOpeningHours(openNow: false), primaryType: "fire_station", displayName: DisplayName(text: "Fire Station", languageCode: "en"), shortFormattedAddress: "Jakarta"),
            PlaceModel(id: "3", location: Location(latitude: -6.217, longitude: 106.83), currentOpeningHours: CurrentOpeningHours(openNow: false), primaryType: "hospital", displayName: DisplayName(text: "Hospital", languageCode: "en"), shortFormattedAddress: "Jakarta")
        ]
        
        let dummyCustomPlaces = [
            MapPoint(name: "Custom Place 1", coordinate: CLLocationCoordinate2D(latitude: -6.22, longitude: 106.85), markerIndex: 0)
        ]
        
        // Act
        let sortedPlaces = SafePlaceUtils.sortSafePlaces(dummyPlaces, customPlaces: dummyCustomPlaces, from: userLocation)
        
        // Assert
        XCTAssertEqual(sortedPlaces.count, 1, "Expected 1 place in the sorted list, which is the custom place.")
        XCTAssertEqual(sortedPlaces.first?.displayName?.text, "Custom Place 1", "Custom places should be prioritized when no other places are open.")
    }
    
    func testSortSafePlaces_withEqualDistanceDifferentPriority() {
        // Arrange
        let userLocation = CLLocation(latitude: -6.200000, longitude: 106.816666)
        let dummyPlaces = [
            PlaceModel(id: "1", location: Location(latitude: -6.200000, longitude: 106.816666), currentOpeningHours: CurrentOpeningHours(openNow: true), primaryType: "police", displayName: DisplayName(text: "Police Station", languageCode: "en"), shortFormattedAddress: "Jakarta"),
            PlaceModel(id: "2", location: Location(latitude: -6.200000, longitude: 106.816666), currentOpeningHours: CurrentOpeningHours(openNow: true), primaryType: "fire_station", displayName: DisplayName(text: "Fire Station", languageCode: "en"), shortFormattedAddress: "Jakarta"),
        ]
        
        let dummyCustomPlaces = [
            MapPoint(name: "Custom Place 1", coordinate: CLLocationCoordinate2D(latitude: -6.22, longitude: 106.85), markerIndex: 0)
        ]
        
        // Act
        let sortedPlaces = SafePlaceUtils.sortSafePlaces(dummyPlaces, customPlaces: dummyCustomPlaces, from: userLocation)
        
        // Assert
        XCTAssertEqual(sortedPlaces.first?.displayName?.text, "Police Station", "Police stations should have a higher priority than fire stations.")
    }
}

