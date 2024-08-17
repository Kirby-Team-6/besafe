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
    @Published var data: [PlaceModel] = []
    
    private let remoteDataSource: RemoteDataSource
    init(_ remoteDataSource: RemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    
    func loadData() {
        Task{
            state = AppState.loading
            let result = await remoteDataSource.getNearbyPlaces()
            switch result{
            case .success(let value):
                data = value
            case .failure(let e):
                print(e)
            }
            
            state = AppState.success
        }
    }
    
}
