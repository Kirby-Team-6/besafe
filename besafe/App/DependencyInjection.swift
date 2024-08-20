//
//  DependencyInjection.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation

class DI {
    static let shared = DI()
    
    private init() {
        
    }
    
    private lazy var localDataSource: LocalDataSource = LocalDataSourceImpl()
    private lazy var remoteDataSource: RemoteDataSource = RemoteDataSourceImpl()
    
    func page1Viewmodel() -> Page1Viewmodel {
        return Page1Viewmodel()
    }
    
    func directionViewmodel() -> DirectionViewmodel {
        DirectionViewmodel()
    }
    
    func temporaryInitialViewmodel() -> TemporaryInitialViewmodel {
        TemporaryInitialViewmodel(remoteDataSource: remoteDataSource)
    }
}
