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
    
    private var swiftDataSource: SwiftDataService?
    private lazy var remoteDataSource: RemoteDataSource = RemoteDataSourceImpl()
    
    func initialize() async {
        swiftDataSource = await SwiftDataService.shared
    }
    
    func page1Viewmodel() -> Page1Viewmodel {
        return Page1Viewmodel()
    }
        
    func mainViewmodel() -> MainViewModel {
        MainViewModel(remoteDataSource: remoteDataSource, swiftDataSource: swiftDataSource!)
    }
}
