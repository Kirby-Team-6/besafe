//
//  besafeApp.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI

@main
struct besafeApp: App {
   @StateObject var router = Router()
   @StateObject var pointViewModel = MapPointViewModel(dataSource: .shared)
//   @StateObject var watchConnect = WatchConnector()
   var body: some Scene {
      WindowGroup {
         NavigationStack(path: $router.path) {
            router.build(router.path.first!)
               .navigationDestination(for: Screen.self) { screen in
                  router.build(screen)
               }
               .sheet(item: $router.sheet) { sheet in
                  //                        router.build(sheet)
               }
               .fullScreenCover(item: $router.fullScreenCover) { fullScreenCover in
                  //                        appCoordinator.build(fullScreenCover)
               }
         }
         .environmentObject(router)
         .environmentObject(pointViewModel)
//         .environmentObject(watchConnect)
      }
   }
}
