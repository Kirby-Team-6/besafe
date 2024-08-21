import SwiftUI
import CoreHaptics

struct EmergencyPageView: View {
    let onTap: () -> Void
    
    @EnvironmentObject private var viewmodel: MainViewModel
    @StateObject private var mapPointViewModel = MapPointViewModel(dataSource: SwiftDataService())
    @EnvironmentObject private var router: Router
    @Binding var showFulscreen: Bool
    @State private var isPressed = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var engine: CHHapticEngine?
    @State private var countdown = 3
    @State private var isCountingDown = false
    @State private var isNavigating = false
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            // Navigating view
            if isNavigating {
                VStack(spacing: 16) {
                    Text("Navigating to")
                        .font(.system(size: 17))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(spacing: 10) {
                        Text(viewmodel.selectedSafePlace?.displayName?.text ?? "Unknown Place")
                            .font(.system(size: 34))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(viewmodel.selectedSafePlace?.shortFormattedAddress ?? "No Address Available")
                            .font(.system(size: 15))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack {
                    VStack(spacing: 50) {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                // TODO: information page -> UIKit
                                print("Info button tapped")
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.black.opacity(0.2))
                                    
                                    Image(systemName: "info")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .bold))
                                }
                                .frame(width: 50, height: 50)
                            }
                            .padding(.trailing, 30)
                            .padding(.top, 70)
                            .opacity(isCountingDown ? 0 : 1)
                            .disabled(isCountingDown)
                        }
                        
                        VStack(spacing: 70) {
                            VStack(spacing: 8) {
                                if isCountingDown {
                                    VStack(spacing: 12) {
                                        Text("You will be navigated to the nearest safe place")
                                            .font(.system(size: 17))
                                            .multilineTextAlignment(.center)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Text("in \(countdown) second\(countdown > 1 ? "s" : "")")
                                            .font(.system(size: 34))
                                            .fontWeight(.bold)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                } else {
                                    VStack(spacing: 12) {
                                        Text("Hold the button\nif you’re being followed")
                                            .font(.system(size: 22))
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.center)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Text("You will be navigated to the nearest safe place and your live location will be sent to emergency contact")
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.center)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                }
                            }
                            .padding(.horizontal)
                            .animation(.easeInOut(duration: 0.5), value: isPressed)
                            
                            // Button
                            GeometryReader { geometry in
                                VStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.primaryDarkBlue)
                                            .frame(width: 275 * buttonScale, height: 275 * buttonScale)
                                            .overlay(
                                                Circle()
                                                    .strokeBorder(Color.black.opacity(0.2), lineWidth: 36)
                                                    .frame(width: 275 * buttonScale, height: 275 * buttonScale)
                                            )
                                            .overlay(
                                                Circle()
                                                    .fill(isPressed ? Color.black.opacity(0.36) : Color.clear)
                                                    .frame(width: 275 * buttonScale, height: 275 * buttonScale)
                                            )
                                        
                                        Image(systemName: "location.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 100, height: 100)
                                            .offset(x: -5)
                                    }
                                    .scaleEffect(buttonScale)
                                    .onLongPressGesture(minimumDuration: 2.0, maximumDistance: .infinity, pressing: { pressing in
                                        viewmodel.getSafePlace(mapPointViewModel: mapPointViewModel)
                                        if pressing {
                                            startCountdown()
                                            withAnimation(.easeIn(duration: 2.0)) {
                                                buttonScale = 1.2
                                                isPressed = true
                                            }
                                            triggerHapticFeedback()
                                        } else {
                                            resetButton()
                                            stopCountdown()
                                        }
                                    }, perform: {
                                        showNavigationMessage()
                                    })
                                    .padding()
                                }
                                .frame(width: geometry.size.width, height: 275 * buttonScale + 30)
                            }
                        }
                    }
                    
                    
                    VStack(spacing: 15) {
                        // Set Emergency Contact Button
                        Button(action: {
                            self.showFulscreen = false
                            router.push(.emergencycontactsview)
                        }) {
                            Text("Set emergency contact")
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(100)
                        }
                        .opacity(isCountingDown ? 0 : 1)
                        .disabled(isCountingDown)
                        
                        // Custom Safe Place Button
                        Button(action: {
                            self.showFulscreen = false
                            router.push(.homeview)
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "mappin")
                                    .font(.system(size: 19))
                                
                                Text("Custom safe place")
                                    .font(.system(size: 17))
                            }
                            .padding()
                            .padding(.horizontal, 6)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .cornerRadius(100)
                        }
                        .padding(.bottom, 30)
                        .opacity(isCountingDown ? 0 : 1)
                        .disabled(isCountingDown)
                    }
                }
                
            }
        }
        .onAppear {
            prepareHaptics()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine error: \(error.localizedDescription)")
        }
    }
    
    func triggerHapticFeedback() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        for i in 0..<10 {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 10.0)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 10.0)
            
            let startTime = Double(i) * 0.15
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: startTime)
            
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }

    
    func startCountdown() {
        isCountingDown = true
        countdown = 3
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
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
    
    func showNavigationMessage() {
        isNavigating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            onTap()
            isNavigating = false
        }
    }
}
