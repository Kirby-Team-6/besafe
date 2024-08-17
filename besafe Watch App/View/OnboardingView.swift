//
//  OnboardingView.swift
//  besafe Watch App
//
//  Created by Rifat Khadafy on 18/08/24.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack{
            Image(.onboardIcon)
                .padding(.bottom, 8)
            Text("Navigate me to\nsafe place")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    OnboardingView()
}
