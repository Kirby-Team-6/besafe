import SwiftUI
import MapKit
import CoreLocation

struct SearchPlaceView: View {
   @Environment(\.dismiss) private var dismiss
   @Binding var enumOverlay: Overlay
   @Binding var position: MapCameraPosition
   @Binding var overlayHeight: CGFloat
   @Binding var temporaryMarkerCoordinate: CLLocationCoordinate2D?
   @Binding var showTemporaryMarker: Bool
   @State private var searchText: String = ""
   @State private var searchResults: [MKMapItem] = []
   @State private var isSearching: Bool = false
   //   @EnvironmentObject var watchConnect: WatchConnect
   @EnvironmentObject var router: Router
   @EnvironmentObject var mapPointVM: MapPointViewModel
   @EnvironmentObject var nearbyVM: SearchNearby
   
   var body: some View {
      ZStack{
         Color.neutral.ignoresSafeArea()
         VStack(spacing: 16) {
            HStack{
               Button("Cancel") {
                  withAnimation{
                     enumOverlay = .customNewPlace
                  }
               }
               
               Spacer()
               
               Text("New Preferred Place")
                  .frame(maxWidth: .infinity, alignment: .center)
                  .font(.headline)
               
               Spacer()
            }
            
            // Search Bar
            TextField("Search Maps", text: $searchText)
               .padding()
               .background(.customWhite)
               .clipShape(RoundedRectangle(cornerRadius: 12))
               .onChange(of: searchText) {
                  searchPlaces()
               }
            
            // Choose on Map Button
            Button(action: {
               // Handle map selection action
               // TODO: navigate ke page add custom pinpoint
               withAnimation{
                  enumOverlay = .addPlace
               }
            }) {
               HStack {
                  Image(systemName: "mappin.and.ellipse")
                     .font(.system(size: 20))
                     .foregroundColor(.blue)
                  Text("Choose on Map")
                     .font(.system(size: 16))
                     .foregroundColor(.blue)
               }
               .padding()
               .frame(maxWidth: .infinity, alignment: .leading)
               .clipShape(RoundedRectangle(cornerRadius: 12))
               .background(.customWhite)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if isSearching {
               List {
                  ForEach(searchResults, id: \.self) { item in
                     ListPlacesView(name: item.name ?? "", title: item.placemark.title ?? "")
                        .onTapGesture {
                           withAnimation{
                              temporaryMarkerCoordinate = item.placemark.coordinate
                              showTemporaryMarker = true
                              enumOverlay = .customNewPlace
                              // Update the map position to focus on the selected coordinate
                              position = .camera(MapCamera(centerCoordinate: item.placemark.coordinate, distance: 1000))
                              overlayHeight = UIScreen.main.bounds.height * 0.3
                           }
                        }
                  }
               }
               .listStyle(PlainListStyle())
               .clipShape(RoundedRectangle(cornerRadius: 25))
            }else{
               HStack{
                  Text("Suggestions")
                     .font(.subheadline)
                     .fontWeight(.semibold)
                     .opacity(0.5)
                  
                  Spacer()
               }
               
               List{
                  ForEach(nearbyVM.nearbyPlaces){ item in
                     ListPlacesView(name: item.name, title: item.address)
                        .onTapGesture {
                           withAnimation{
                              temporaryMarkerCoordinate = item.coordinate
                              showTemporaryMarker = true
                              enumOverlay = .customNewPlace
                              // Update the map position to focus on the selected coordinate
                              position = .camera(MapCamera(centerCoordinate: item.coordinate, distance: 1000))
                              overlayHeight = UIScreen.main.bounds.height * 0.3
                           }
                        }
                  }
               }
               .listStyle(PlainListStyle())
               .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            
            Spacer()
         }
         .padding()
      }
      .clipShape(RoundedRectangle(cornerRadius: 25))
      .shadow(radius: 16, y: 4)
      .onAppear{
         nearbyVM.requestLocationPermission()
      }
   }
   
   private func searchPlaces() {
      guard !searchText.isEmpty else {
         searchResults = []
         isSearching = false
         return
      }
      
      isSearching = true
      
      let request = MKLocalSearch.Request()
      request.naturalLanguageQuery = searchText
      let search = MKLocalSearch(request: request)
      
      search.start { response, error in
         if let response = response {
            self.searchResults = response.mapItems
         } else {
            print("Error searching places: \(error?.localizedDescription ?? "Unknown error")")
         }
      }
   }
}

struct Place: Identifiable {
   var id = UUID()
   var name: String
   var description: String
   var icon: String
}

let dummyPlaces: [Place] = [
   Place(name: "Green Office Park 9", description: "Green Office Park 9, BSD City", icon: "building.2.fill"),
   Place(name: "Indomart", description: "Goldfinch", icon: "cart.fill"),
   Place(name: "Eka Hospital", description: "Central Business District, BSD City", icon: "cross.fill"),
   Place(name: "The Breeze", description: "BSD City", icon: "leaf.fill"),
   Place(name: "Pasar Modern", description: "BSD City", icon: "house.fill")
]
