import SwiftUI
import WatchKit

struct EmergencyButtonView: View {
    //    @EnvironmentObject private var viewmodel: MainViewModel
    @State private var isPressed = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var countdown = 3
    @State private var isCountingDown = false
    @State private var timer: Timer?
    @State private var hapticTimer: Timer?
    @State private var isNavigating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isNavigating {
                    VStack {
                        Text("Navigating to")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 5)
                        
                        //TODO: ganti jadi selected safe place name -> ini kayaknya harus dari watch connectivity
                        //                        Text(viewmodel.selectedSafePlace?.displayName?.text ?? "Unknown Place")
                        Text("Sky House BSD Apartment")
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
                    
                    // MARK: Scalable Button
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
                        // TODO: after isNavigating true -> kayak di iOS ada async after 2 sec -> terus onTap() -> pas gabungin
                        isNavigating = true
                        print("Navigation Started")
                    })
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 1.5)
                }
            }
            .onAppear {
                // TODO: Add haptics (optional)
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
                // Perform navigation action here
                isNavigating = true
                print("Navigation Started")
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
