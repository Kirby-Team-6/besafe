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
    
    lazy var localDataSource: LocalDataSource = LocalDataSourceImpl()
    lazy var remoteDataSource: RemoteDataSource  = RemoteDataSourceImpl()
    
    func page1Viewmodel() -> Page1Viewmodel {
        return Page1Viewmodel()
    }
    
    func directionViewModel() -> DirectionViewmodel {
        return DirectionViewmodel()
    }
}
