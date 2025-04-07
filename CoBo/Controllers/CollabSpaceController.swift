//
//  CollabSpaceController.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import Foundation
import SwiftData

class CollabSpaceController {
    var modelContext: ModelContext?
    
    func setupModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllCollabSpace() -> [CollabSpace] {
        guard let context = modelContext else {
            print("Model Context is Not Available")
            return []
        }
        
        let descriptor = FetchDescriptor<CollabSpace>()
        do {
            print(try context.fetch(descriptor).count)
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching collab space: \(error)")
            return []
        }
    }
}
