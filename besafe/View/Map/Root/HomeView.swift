import SwiftUI
import MapKit
import CoreLocation
import SwiftData

struct HomeView: View {
   @EnvironmentObject var pointViewModel: MapPointViewModel
   
   @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
   @State private var showingSearchPlaceView = false
   @State var addingPoint = false
   @State var onTapAdd = false
   @State var showingLocationDetail = false
   @State var searchText = ""
   @State var mapSelection: MapPoint?
   @State private var overlayHeight: CGFloat = UIScreen.main.bounds.height * 0.3
   
   @State private var customSafePlaceHeight = UIScreen.main.bounds.height * 0.3
   
   var body: some View {
      ZStack {
         MapReader { reader in
            Map(position: $position, selection: $mapSelection) {
               UserAnnotation()
               
               ForEach(pointViewModel.mapPoint, id: \.self) { marker in
                  Marker(marker.name, systemImage: "heart.fill", coordinate: marker.coordinate)
               }
            }
            .onChange(of: mapSelection) { oldValue, newValue in
               showingLocationDetail = newValue != nil
            }
            .onAppear {
               CLLocationManager().requestWhenInUseAuthorization()
            }
            .overlay(alignment: .bottom) {
               // TODO: Semua overlay mending jadiin separated function
               MapOverlayView(addingPoint: $addingPoint, onTapAdd: $onTapAdd, searchText: $searchText, customSafePlaceHeight: $customSafePlaceHeight, overlayHeight: $overlayHeight, reader:reader)
            }
            .sheet(isPresented: $showingLocationDetail, onDismiss: {
               withAnimation{
                  mapSelection = nil
               }
            },content: {
               LocationDetailView(name: Binding(
                  get: { mapSelection?.name ?? "" }, // Provide a default value
                  set: { newValue in
                     if let index = pointViewModel.mapPoint.firstIndex(where: { $0.id == mapSelection?.id }) {
                        pointViewModel.mapPoint[index].name = newValue
                     }
                  }
               ), mapPoint: mapSelection!)
               .presentationDetents([.medium])
            })
         }
         
         if addingPoint {
            Image(.customPinpoint)
               .foregroundColor(.red)
               .font(.title)
         }
      }
      .ignoresSafeArea()
   }
}

#Preview {
   HomeView()
      .modelContainer(for: MapPoint.self)
      .environmentObject(MapPointViewModel(dataSource: .shared))
}
