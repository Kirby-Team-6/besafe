import SwiftUI

struct EmergencyButtonView: View {
    @State private var isPressed = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var countdown = 3
    @State private var isCountingDown = false
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                        startCountdown()
                        withAnimation(.easeIn(duration: 1.5)) {
                            buttonScale = 1.2
                            isPressed = true
                        }
                    } else {
                        resetButton()
                        stopCountdown()
                    }
                }, perform: {
                    // TODO: Perform navigation action after countdown
                    print("Navigation Started")
                })
                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.5)
            }
            .onAppear {
                // TODO: Add haptics (optional)
            }
        }
        .edgesIgnoringSafeArea(.all)
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
    }
}
