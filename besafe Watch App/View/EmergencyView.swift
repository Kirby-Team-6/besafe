import SwiftUI
//import CoreHaptics

struct EmergencyButtonView: View {
    @State private var isPressed = false
    @State private var buttonScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Long press the button\nto start the navigation")
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .padding(.bottom, 6)
                .padding(.top, 5)
            
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
                    withAnimation(.easeIn(duration: 1.5)) {
                        buttonScale = 1.2
                        isPressed = true
                    }
                } else {
                    resetButton()
                }
            }, perform: {
                // TODO: Action on long press complete
                print("Navigation Started")
            })
            .padding(.bottom, 30)

        }
        .onAppear {
            // TODO: Add haptics
        }
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
