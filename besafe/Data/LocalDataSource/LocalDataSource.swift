//
//  LocalDataSource.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation

protocol LocalDataSource {
    
}

class LocalDataSourceImpl: LocalDataSource {
    private let swiftDataManager: SwiftDataContextManager
    
    init(_ swiftDataManager: SwiftDataContextManager) {
        self.swiftDataManager = swiftDataManager
    }
    
}
