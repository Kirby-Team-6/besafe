//
//  SwiftDataContextManager.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import Foundation
import SwiftData

public class SwiftDataContextManager {
    public static var shared = SwiftDataContextManager()
    var container: ModelContainer?
    var context: ModelContext?

    init() {
        do {
//            container = try ModelContainer(for: NoteListLocalEntity.self)
//            if let container {
//                context = ModelContext(container)
//            }
        } catch {
            debugPrint("Error initializing database container:", error)
        }
    }
}
