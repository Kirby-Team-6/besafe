//
//  Router.swift
//  besafe Watch App
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var path: [Screen] = [Screen.home]
    @Published var rootView: Screen = Screen.home
    
    
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
    
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .home:
            ContentView().navigationBarBackButtonHidden()
        case .onboarding:
            OnboardingView()
        }
        
        //    @ViewBuilder
        //    func build(_ sheet: Sheet) -> some View {
        //        switch sheet {
        //        case .detailTask(named: let task):
        //            DetailTaskView(task: task)
        //        }
        //    }
        
        //    @ViewBuilder
        //    func build(_ fullScreenCover: FullScreenCover) -> some View {
        //        switch fullScreenCover {
        //        case .addHabit(onSaveButtonTap: let onSaveButtonTap):
        //            AddHabitView(onSaveButtonTap: onSaveButtonTap)
        //        }
        //    }
    }
}

enum Screen: Identifiable, Hashable {
    case home
    case onboarding
    
    var id: Self { return self }
}

