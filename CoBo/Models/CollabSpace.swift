//
//  CollabSpace.swift
//  CoBo
//
//  Created by Evan Lokajaya on 25/03/25.
//

import Foundation
import SwiftData

@Model
class CollabSpace: Hashable {
    var name: String
    var capacity: Int
    var whiteboardAmount: Int
    var tableWhiteboardAmount: Int
    var tvAvailable: Bool
    var image:String
    
    init(name: String, capacity: Int, whiteboardAmount: Int, tableWhiteboardAmount: Int, tvAvailable: Bool, image: String) {
        self.name = name
        self.capacity = capacity
        self.whiteboardAmount = whiteboardAmount
        self.tableWhiteboardAmount = tableWhiteboardAmount
        self.tvAvailable = tvAvailable
        self.image = image
    }
}
