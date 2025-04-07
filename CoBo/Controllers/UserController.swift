//
//  UserController.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import Foundation
import SwiftData

class UserController {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllUser() -> [User] {
        let descriptor = FetchDescriptor<User>()
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching users: \(error)")
            return []
        }
    }
}
