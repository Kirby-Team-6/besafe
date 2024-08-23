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
   @StateObject var nearbyVM = SearchNearby()
   @StateObject var watchConnect = WatchConnect()
   //   @StateObject var watchConnect = WatchConnector()
   @State var initialize = false
   
   var body: some Scene {
      WindowGroup {
         Group {
            if (initialize){
               NavigationStack(path: $router.path) {
                  EmptyView()
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
            } else {
               EmptyView()
            }
         }
         .onAppear{
             UserDefaults.standard.setValue(false, forKey: "isAlreadyShowOnBoarding")
         }
         .task {
            await DI.shared.initialize()
            self.initialize = true
         }
         .environmentObject(router)
         .environmentObject(pointViewModel)
         .environmentObject(watchConnect)
         .environmentObject(nearbyVM)
      }
   }
}
