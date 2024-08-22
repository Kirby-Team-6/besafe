import SwiftUI
import WatchKit

struct EmergencyButtonView: View {
    @EnvironmentObject var router: Router
    @State private var isPressed = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var countdown = 3
    @State private var isCountingDown = false
    @State private var timer: Timer?
    @State private var hapticTimer: Timer?
    @State private var isLoading = false
    @State private var isNavigating = false
    @StateObject var watchConnect = WatchConnect.shared
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if watchConnect.routeModel != nil && isNavigating {
                    VStack {
                        Text("Navigating to")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)
                        
                        Text(watchConnect.routeModel!.placeDirectionName)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, 5)
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                } else {
                    VStack(spacing: 15) {
                        if isCountingDown {
                            Text("Navigating in\n\(countdown) second\(countdown > 1 ? "s" : "")")
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(2)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                        } else {
                            Text("Long press the button\nto start the navigation")
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .padding(.bottom, 6)
                                .padding(.top, 5)
                        }
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 4.5)
                    
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 120 * buttonScale, height: 120 * buttonScale)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.black.opacity(0.2), lineWidth: 12)
                                    .frame(width: 120 * buttonScale, height: 120 * buttonScale)
                            )
                            .overlay(
                                Circle()
                                    .fill(isPressed ? Color.black.opacity(0.36) : Color.clear)
                                    .frame(width: 120 * buttonScale, height: 120 * buttonScale)
                            )
                        
                        Image(systemName: "location.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .offset(x: -3)
                    }
                    .scaleEffect(buttonScale)
                    .onLongPressGesture(minimumDuration: 1.5, pressing: { pressing in
                        if pressing {
                            startHapticFeedback()
                            startCountdown()
                            withAnimation(.easeIn(duration: 1.5)) {
                                buttonScale = 1.2
                                isPressed = true
                            }
                        } else {
                            stopHapticFeedback()
                            resetButton()
                            stopCountdown()
                        }
                    }, perform: {
                        isLoading = true
                        Task {
                            // Get list Save Place
                            guard let location = CLLocationManager().location else {
                                isLoading = false
                                return
                            }
//                            let selectedSafePlace
                            watchConnect.session.sendMessage([
                                "actionId": 0,
                                "latitude": location.coordinate.latitude,
                                "longitude": location.coordinate.longitude
                            ], replyHandler: nil){ error in
                                print(error.localizedDescription)
                            }

                        }
                    })
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 1.5)
                }
            }
        }
        .fullScreenCover(isPresented: $isLoading) {
            VStack{
                Spacer()
                Text("Hang on while we're getting directions")
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)
                    .foregroundColor(Color(red: 0.92, green: 0.92, blue: 0.96).opacity(0.6))
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .fontWeight(.regular)
                ProgressView()
                    .frame(height: 30)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(.all, edges: .all)
        }
        .onReceive(watchConnect.$routeModel) { v in
            if v != nil {
                isLoading = false
                isNavigating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    CLLocationManager().startUpdatingLocation()
                    router.push(Screen.home)
                    isNavigating = false
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func startHapticFeedback() {
        hapticTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            WKInterfaceDevice.current().play(.start)
        }
    }
    
    func stopHapticFeedback() {
        hapticTimer?.invalidate()
        hapticTimer = nil
    }
    
    func startCountdown() {
        isCountingDown = true
        countdown = 3
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.invalidate()
                isCountingDown = false
                resetButton()
            }
        }
    }
    
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
        isCountingDown = false
        countdown = 3
    }
    
    func resetButton() {
        withAnimation(.easeOut) {
            buttonScale = 1.0
            isPressed = false
        }
    }
}

struct EmergencyButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyButtonView()
        //            .environmentObject(MainViewModel(remoteDataSource: RemoteDataSource(), swiftDataSource: SwiftDataService()))
    }
}
