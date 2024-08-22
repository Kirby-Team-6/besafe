import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Environment(\.presentationMode) var presentationMode
    private let totalPages = 4
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                OnboardingPageView(
                    image: "iconBig",
                    title: "Welcome to BeSafe",
                    description: "Get in the move to safety with Navigation that guides you to the nearest spot where help awaits.", 
                    topPadding: 100,
                    bottomPadding: 50
                )
                .tag(0)
                
                OnboardingPageView(
                    image: "live-location",
                    title: "Let others know about\nyour whereabouts",
                    description: "Keep friends and family updated in real-time and enhance security with Live Location Sharing to Emergency Contacts.", 
                    topPadding: 0,
                    bottomPadding: 0
                )
                .tag(1)
                
                OnboardingPageView(
                    image: "complication",
                    title: "Easy access with complication",
                    description: "Reach the nearest safe spot with one tap on your watch. Quick, easy guidance when you need it most.", 
                    topPadding: 100,
                    bottomPadding: 0
                )
                .tag(2)
                
                OnboardingPageView(
                    image: "reroute",
                    title: "Reroute if you arrived\nbut can’t find anyone",
                    description: "When you reach your destination but can't find anyone to help, tap reroute, and we’ll guide you to the next nearest safe spot.", 
                    topPadding: 0,
                    bottomPadding: 0
                )
                .tag(3)
            }
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide the default dots
                        
                        HStack(spacing: 8) {
                            ForEach(0..<totalPages, id: \.self) { index in
                                Circle()
                                    .fill(index == currentPage ? Color.primary : Color.secondary)
                                    .frame(width: 10, height: 10)
                                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
            
            Button(action: {
                if currentPage < 3 {
                    currentPage += 1
                } else {
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text(currentPage < 3 ? "Next" : "Start Navigating")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.primaryDarkBlue)
                    .cornerRadius(100)
                    .padding(.horizontal)
            }
            .padding(.bottom, 50)
            
        }
        .ignoresSafeArea()
        .interactiveDismissDisabled()
    }
}

struct OnboardingPageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    let image: String
    let title: String
    let description: String
    let topPadding: CGFloat
    let bottomPadding: CGFloat
    
    var body: some View {
        VStack {
            Image(image)
                .padding(.top, topPadding)
                .padding(.bottom, bottomPadding)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            Text(description)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .ignoresSafeArea()
        .overlay(
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.secondary.opacity(0.2))
                        .frame(width: 32, height: 32)
                    

                    Image(systemName: "xmark")
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                        .font(.system(size: 15, weight: .heavy))
                        .padding(10)                 }
                .padding(.trailing, 20)
                .padding(.top, 20)
            },
            alignment: .topTrailing
        )
    }
}

#Preview {
    OnboardingView()
}
