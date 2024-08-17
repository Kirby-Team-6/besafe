//
//  Route.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var path: [Screen]
    @Published var rootView: Screen
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    init(initialRoute: Screen) {
        let rootView = initialRoute
        self.rootView = rootView
        path = [rootView]
    }
    
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
        case .page1:
            Page1().navigationBarBackButtonHidden(rootView == .page1)
        case .page2:
            Page2()
        case .direction:
            DirectionView()
                .environmentObject(DI.shared.directionViewModel())
                .navigationBarBackButtonHidden(rootView == .direction)
        }
    }

    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
        case .detailTask:
            EmptyView()
        }
    }
    
    @ViewBuilder
    func build(_ fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .addHabit:
            EmptyView()
        }
    }
    
    // MARK: - Navigation Functions
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    
    func pushReplace(_ screen: Screen) {
        rootView = screen
        let lastIndex = path.endIndex - 1
        path[lastIndex] = screen
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func presentFullScreenCover(_ fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.path.removeLast(self.path.count - 1)
        }
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func dismissFullScreenOver() {
        self.fullScreenCover = nil
    }
}

