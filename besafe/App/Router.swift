//
//  Route.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
   @Published var path: [Screen] = [Screen.homeview]
   @Published var rootView: Screen = Screen.homeview
   @Published var sheet: Sheet?
   @Published var fullScreenCover: FullScreenCover?
   
   
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
   
   // MARK: - Presentation Style Providers
   @ViewBuilder
   func build(_ screen: Screen) -> some View {
      switch screen {
      case .page1:
         Page1().navigationBarBackButtonHidden(true)
      case .page2:
         Page2()
      case .homeview:
         HomeView().navigationBarBackButtonHidden(true)
      case .safeplaceview:
         SafePlaceView()
      case .nearbyplacesview:
         NearbyPlacesView()
      case .emergencycontactsview:
         EmergencyContactsView()
      }
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
