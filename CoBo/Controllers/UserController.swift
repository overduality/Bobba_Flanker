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
        
        let descriptor = FetchDescriptor<User>()
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching users: \(error)")
            return []
        }
    }
}
