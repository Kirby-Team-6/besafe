//
//  besafeApp.swift
//  besafe Watch App
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI
import MapKit

@main
struct besafe_Watch_AppApp: App {
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                router.build(router.path.first!)
                    .navigationDestination(for: Screen.self) { screen in
                        router.build(screen)
                        
                    }
            }
            .environmentObject(router)
        }
    }
}
