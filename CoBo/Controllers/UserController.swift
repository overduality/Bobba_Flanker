//
//  UserController.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import Foundation
import SwiftData

class UserController {
    var modelContext: ModelContext?
    
    func setupModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllUser() -> [User] {
        guard let context = modelContext else {
            print("Model Context is Not Available : Get All User")
            return []
        }
        
        var descriptor = FetchDescriptor<User>()
        descriptor.sortBy = [SortDescriptor(\User.name, order: .forward)]
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching users: \(error)")
            return []
        }
    }
}
