//
//  CollabSpaceController.swift
//  CoBo
//
//  Created by Evan Lokajaya on 07/04/25.
//

import Foundation
import SwiftData

class CollabSpaceController {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func getAllCollabSpace() -> [CollabSpace] {
        let descriptor = FetchDescriptor<CollabSpace>()
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching collab space: \(error)")
            return []
        }
    }
}
