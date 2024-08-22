//
//  besafeApp.swift
//  besafe Watch App
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI

@main
struct besafe_Watch_AppApp: App {
   @StateObject var router = Router()
   @StateObject var pointViewModel = MapPointViewModel(dataSource: .shared)
   var body: some Scene {
      WindowGroup {
         NavigationStack(path: $router.path) {
            EmptyView()
               .navigationDestination(for: Screen.self) { screen in
                  router.build(screen)
               }
         }
         .environmentObject(router)
         .environmentObject(pointViewModel)
      }
   }
}
