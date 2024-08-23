import SwiftUI
import CoreLocation
import MapKit

struct MainView: View {
    @StateObject var viewmodel = DI.shared.mainViewmodel()
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var showInitialView = true
    @State private var showCompleteDirection = false
    @State private var loadMap = false
    @State private var showOnboarding = false
    private let strokeStyle = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
    
    var body: some View {
        ZStack {
            if loadMap {
                Map(position: $position) {
                    UserAnnotation()
                    if viewmodel.route != nil {
                        MapPolyline(viewmodel.route!)
                            .stroke(Color.blue, style: strokeStyle)
                        if let lastStep = viewmodel.route?.steps.last {
                            Marker("Direction", coordinate: CLLocationCoordinate2D(latitude: lastStep.polyline.coordinate.latitude, longitude:  lastStep.polyline.coordinate.longitude))
                        }
                    }
                }
                DirectionView(position: $position)
            }
            
            if showInitialView {
                EmergencyPageView(onTap: {
                    viewmodel.coverScreen = CoverScreen.direction
                })
                .frame(maxWidth: .infinity)
                .background(BackgroundBlurView())
                .ignoresSafeArea(.all, edges: .all)
                .animation(.default, value: showInitialView)
                .onAppear {
                    self.loadMap = true
                }
            }
            
            if showCompleteDirection {
                ComplateDirectionView(onReroute: {
                    viewmodel.reroute()
                    viewmodel.coverScreen = CoverScreen.direction
                }, onDone: {
                    viewmodel.coverScreen = CoverScreen.initial
                    viewmodel.route = nil
                    viewmodel.selectedSafePlace = nil
                    viewmodel.listSafePlaces = []
                })
                    .background(BackgroundBlurView())
                    .ignoresSafeArea(.all, edges: .all)
            }
        }
        .onReceive(viewmodel.$coverScreen) { v in
            self.showInitialView = false
            self.showCompleteDirection = false
            
            switch v {
            case .direction:
                ""
            case .complete:
                self.showCompleteDirection = true
            case .initial:
                self.showInitialView = true
            case .none:
                ""
            }
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView()
                .background(BackgroundBlurView())
                .ignoresSafeArea(.all, edges: .all)
        }
        .onAppear {
            let defaults = UserDefaults.standard
            let isAlreadyShowOnBoarding = defaults.bool(forKey: "isAlreadyShowOnBoarding")
            if (isAlreadyShowOnBoarding == false){
                self.showOnboarding = true
                defaults.setValue(true, forKey: "isAlreadyShowOnBoarding")
            }
            
            
        }
        .environmentObject(viewmodel)
    }
}

//#Preview {
//    MainView()
//}
