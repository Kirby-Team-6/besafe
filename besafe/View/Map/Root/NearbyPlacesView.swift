import SwiftUI
import CoreLocation
import MapKit

struct NearbyPlacesView: View {
    @StateObject private var searchNearby = SearchNearby()
    
    var body: some View {
        NavigationView {
            VStack {
                if searchNearby.nearbyPlaces.isEmpty {
                    ProgressView("Searching for nearby places...")
                        .padding()
                } else {
                    List(searchNearby.nearbyPlaces) { place in
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 24))
                            
                            VStack(alignment: .leading) {
                                Text(place.name)
                                    .font(.headline)
                                
                                Text(place.address)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text(String(format: "%.2f km away", place.distance))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Nearby Places")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Refresh") {
                        if let location = searchNearby.userLocation {
                            searchNearby.searchNearbyPlaces(at: location.coordinate)
                        }
                    }
                }
            }
            .onAppear {
                searchNearby.requestLocationPermission()
            }
        }
    }
}

struct NearbyPlacesView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyPlacesView()
    }
}
