import SwiftUI
import MapKit
import CoreLocation
import SwiftData

struct HomeView: View {
   @EnvironmentObject var pointViewModel: MapPointViewModel
   @EnvironmentObject var watchConnect: WatchConnect
   
   @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
   @State private var showingSearchPlaceView = false
   @State var addingPoint = false
   @State var onTapAdd = false
   @State var showingLocationDetail = false
   @State var searchText = ""
   @State var mapSelection: MapPoint?
   @State private var overlayHeight: CGFloat = UIScreen.main.bounds.height * 0.3
   @State var enumOverlay: Overlay = .customNewPlace
   @State var temporaryMarkerCoordinate: CLLocationCoordinate2D?
   @State var showTemporaryMarker = false
   
   @FocusState private var isFocused: Bool
   
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
               
               if let coordinate = temporaryMarkerCoordinate, showTemporaryMarker {
                  Marker("Selected Place", systemImage: "mappin", coordinate: coordinate)
                     .tint(.red)
               }
            }
            .onChange(of: mapSelection) { oldValue, newValue in
               showingLocationDetail = newValue != nil
            }
            .onAppear {
               CLLocationManager().requestWhenInUseAuthorization()
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
            .overlay(alignment: .bottom) {
               MapOverlayView(enumOverlay: $enumOverlay, onTapAdd: $onTapAdd, searchText: $searchText, overlayHeight: $overlayHeight, position: $position, temporaryMarkerCoordinate: $temporaryMarkerCoordinate, showTemporaryMarker: $showTemporaryMarker, addingPoint: $addingPoint, reader: reader)
               
            }
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
