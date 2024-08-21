//
//  Router.swift
//  besafe Watch App
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var path: [Screen] = [Screen.emergencyview]
    @Published var rootView: Screen = Screen.emergencyview
    
    
    // MARK: - Navigation Functions
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    
    func pushReplace(_ screen: Screen) {
        rootView = screen
        let lastIndex = path.endIndex - 1
        path[lastIndex] = screen
        
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.path.removeLast(self.path.count - 1)
        }
    }
    
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .home:
            ContentView().navigationBarBackButtonHidden(true)
        case .onBoarding:
            OnboardingView().navigationBarBackButtonHidden(true)
        case .emergencyview:
            EmergencyButtonView()
        }
        
    }
}

enum Screen: Identifiable, Hashable {
    case home, onBoarding, emergencyview
    
    var id: Self { return self }
}

