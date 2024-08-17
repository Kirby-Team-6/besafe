//
//  DependencyInjection.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation

class DI {
    static let shared = DI()
    
    private init() {}
    
    let swiftDataManager = SwiftDataContextManager.shared
    lazy var localDataSource: LocalDataSource = LocalDataSourceImpl(swiftDataManager)
    lazy var remoteDataSource: RemoteDataSource  = RemoteDataSourceImpl()
    
    func page1Viewmodel() -> Page1Viewmodel {
        return Page1Viewmodel(remoteDataSource)
    }
    
    func directionViewModel() -> DirectionViewmodel {
        return DirectionViewmodel()
    }
}
