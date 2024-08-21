import SwiftUI
import CoreLocation
import MapKit

struct MainView: View {
    @StateObject var viewmodel = DI.shared.mainViewmodel()
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var showInitialView = true
    @State private var showCompleteDirection = false
    @State private var loadMap = false
//    @State private var showOnboarding = true // Tambahkan state ini
    
    var body: some View {
        ZStack {
            if loadMap {
                Map(position: $position) {
                    UserAnnotation()
                    if viewmodel.route != nil {
                        let strokeStyle = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                        MapPolyline(viewmodel.route!)
                            .stroke(Color.blue, style: strokeStyle)
                    }
                }
                DirectionView(position: $position)
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
        // TODO: modality onboarding -> tapi kalau kayak gini -> page emergency nya juga jadi modality bukan fullscreen cover -> atau panggil modality nya di page emergency page view aja?
//        .sheet(isPresented: $showOnboarding) {
//                    OnboardingView()
//                        .background(BackgroundBlurView())
//                        .ignoresSafeArea(.all, edges: .all)
//        }
        .fullScreenCover(isPresented: $showCompleteDirection) {
            ComplateDirectionView(onReroute: {}, onDone: {
                viewmodel.coverScreen = CoverScreen.initial
            })
            .background(BackgroundBlurView())
            .ignoresSafeArea(.all, edges: .all)
        }
        .fullScreenCover(isPresented: $showInitialView) {
            EmergencyPageView(onTap: {
                viewmodel.coverScreen = CoverScreen.direction
            }, showFulscreen: $showInitialView)
            .frame(maxWidth: .infinity)
            .background(BackgroundBlurView())
            .ignoresSafeArea(.all, edges: .all)
            .onAppear {
                self.loadMap = true
            }
        }
        .environmentObject(viewmodel)
    }
}

//#Preview {
//    MainView()
//}
