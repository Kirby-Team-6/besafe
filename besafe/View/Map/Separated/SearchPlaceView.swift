import SwiftUI
import MapKit

struct SearchPlaceView: View {
   @Environment(\.dismiss) private var dismiss
   @State private var searchText: String = ""
   @State private var searchResults: [MKMapItem] = []
   @State private var isSearching: Bool = false
   @Binding var addingPoint: Bool
//   @EnvironmentObject var watchConnect: WatchConnect
   
   var body: some View {
      ZStack{
         Color.neutral.ignoresSafeArea()
         VStack(spacing: 16) {
            ModalityTitleView(cancelString: "Cancel", title: "Custom Safe Place", confirmString: "Submit") {
               
            } submitFunc: {
//               watchConnect.increment()
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
                  addingPoint = true
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
            
            // Suggested Places (Search Results)
            if isSearching {
               List {
                  ForEach(searchResults, id: \.self) { item in
                     HStack {
                        Image(systemName: "magnifyingglass.circle.fill")
                           .foregroundColor(.blue)
                           .font(.system(size: 24))
                           .frame(width: 32, height: 32)
                        VStack(alignment: .leading) {
                           Text(item.name ?? "")
                              .font(.headline)
                           Text(item.placemark.title ?? "")
                              .font(.subheadline)
                              .foregroundColor(.gray)
                        }
                     }
                  }
               }
               .listStyle(PlainListStyle())
            } else {
               // Dummy Data (Before Search)
               //TODO: ganti jadi swift data yang udah disimpen custom safe placenya
               // Jadi button utk pilih place
               List {
                  ForEach(dummyPlaces) { place in
                     HStack {
                        Image(systemName: place.icon)
                           .foregroundColor(.blue)
                           .font(.system(size: 24))
                           .frame(width: 32, height: 32)
                        VStack(alignment: .leading) {
                           Text(place.name)
                              .font(.headline)
                           Text(place.description)
                              .font(.subheadline)
                              .foregroundColor(.gray)
                        }
                     }
                  }
               }
               .listStyle(PlainListStyle())
            }
         }
         .padding()
      }
//      .frame(height: UIScreen.main.bounds.height * 0.3)
      .clipShape(RoundedRectangle(cornerRadius: 25))
      .offset(y: !addingPoint ? 0 : UIScreen.main.bounds.height)
      .shadow(radius: 16, y: 4)
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
