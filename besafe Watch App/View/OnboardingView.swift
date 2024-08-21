//
//  OnboardingView.swift
//  besafe Watch App
//
//  Created by Rifat Khadafy on 18/08/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack{
            Button(action: {
                router.push(Screen.home)
            }, label: {
                Image(.onboardIcon)
                    .padding(.bottom, 8)
            })
            .buttonStyle(PlainButtonStyle())
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
