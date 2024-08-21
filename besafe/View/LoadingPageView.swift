import SwiftUI
import CoreHaptics

struct LoadingPageView: View {
    
    var body: some View {

        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Text("Navigating to")
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(spacing: 8) {
                    Text("Safe Place Name")
                        .font(.system(size: 34))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)
                
                    Text("Address")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct LoadingPageView_Preview: PreviewProvider {
    static var previews: some View {
        LoadingPageView()
    }
}
