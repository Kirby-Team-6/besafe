//
//  besafeApp.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI

@main
struct besafeApp: App {
    @StateObject var router = Router(initialRoute: Screen.direction)
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                EmptyView()
                    .navigationDestination(for: Screen.self) { screen in
                        router.build(screen)
                    }
                    .sheet(item: $router.sheet) { sheet in
                        router.build(sheet)
                    }
                    .fullScreenCover(item: $router.fullScreenCover) { fullScreenCover in
                        router.build(fullScreenCover)
                    }
            }
            .environmentObject(router)

        }
    }
}
