import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                OnboardingPageView(
                    image: "iconBig",
                    title: "Welcome to BeSafe",
                    description: "Get in the move to safety with Navigation that guides you to the nearest spot where help awaits.", topPadding: 100
                )
                .tag(0)
                
                OnboardingPageView(
                    image: "live-location",
                    title: "Let others know about\nyour whereabouts",
                    description: "Keep friends and family updated in real-time and enhance security with Live Location Sharing to Emergency Contacts.", topPadding: 0
                )
                .tag(1)
                
                OnboardingPageView(
                    image: "complication",
                    title: "Easy access with complication",
                    description: "Reach the nearest safe spot with one tap on your watch. Quick, easy guidance when you need it most.", topPadding: 100
                )
                .tag(2)
                
                OnboardingPageView(
                    image: "reroute",
                    title: "Reroute if you arrived\nbut can’t find anyone",
                    description: "When you reach your destination but can't find anyone to help, tap reroute, and we’ll guide you to the next nearest safe spot.", topPadding: 0
                )
                .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            Button(action: {
                if currentPage < 3 {
                    currentPage += 1
                } else {
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text(currentPage < 3 ? "Next" : "Start Navigating")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(100)
                    .padding(.horizontal)
            }
            .padding(.bottom, 30)
            
            //            Spacer()
        }
        .ignoresSafeArea()
        .overlay(
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
// TODO: ini overlay gapapa ga? apa mau per page?
                
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 32, height: 32)
                    

                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .font(.system(size: 15, weight: .bold))
                        .padding(10)                 }
                .padding(.trailing, 20)
            },
            alignment: .topTrailing
        )
        .interactiveDismissDisabled()
    }
}

struct OnboardingPageView: View {
    let image: String
    let title: String
    let description: String
    let topPadding: CGFloat
    
    var body: some View {
        VStack {
            //            Spacer()
            
            Image(image)
                .padding(.top, topPadding)
            //            Spacer()
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            Text(description)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // TODO: ubah spacer disini
            Spacer()
        }
        //        .padding()
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingView()
}
