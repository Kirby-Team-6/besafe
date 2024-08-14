//
//  Page1Viewmodel.swift
//  Kirbygoestohome
//
//  Created by Rifat Khadafy on 08/08/24.
//

import Foundation

enum AppState {
    case initial
    case loading
    case success
}

class Page1Viewmodel: ObservableObject {
    
    @Published var isShow: Bool = false
    @Published var state : AppState = AppState.initial
    @Published var data: String? = nil
    
    func loadData() {
        Task{
            state = AppState.loading
            try await Task.sleep(nanoseconds:  UInt64(3 * 1_000_000_000))
            data = "some data"
            state = AppState.success
        }
    }

}
