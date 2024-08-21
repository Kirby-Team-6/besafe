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
                  
                  let icon = Variables.icons[marker.markerIndex]
                  
                  Marker(marker.name, systemImage: icon.img, coordinate: marker.coordinate)
                     .tint(icon.color)
               }
            }
            .onChange(of: mapSelection) { oldValue, newValue in
               showingLocationDetail = newValue != nil
            }
            .onAppear {
               CLLocationManager().requestWhenInUseAuthorization()
            }
            .overlay(alignment: .bottom) {
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
               .zIndex(0)
         }
      }
      .ignoresSafeArea()
   }
}

//#Preview {
//   HomeView()
//      .environmentObject(MapPointViewModel(dataSource: .shared))
//}
