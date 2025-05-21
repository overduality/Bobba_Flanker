//
//  CollabSpace.swift
//  CoBo
//
//  Created by Evan Lokajaya on 25/03/25.
//  Adjusted by Rieno on 07/05/25

import Foundation
import SwiftData

@Model
class CollabSpace: Hashable {
    var name: String
    var minCapacity: Int
    var maxCapacity: Int
    var wallWhiteBoard: Bool
    var tableWhiteBoard: Bool
    var tvAvailable: Bool
    var image: String
    var focusArea: Bool
    var sofa: Bool

    init(name: String, minCapacity: Int, maxCapacity: Int, wallWhiteBoard: Bool, tableWhiteBoard: Bool, tvAvailable: Bool, image: String,
focusArea: Bool,
         sofa: Bool) {
        self.name = name
        self.minCapacity = minCapacity
        self.maxCapacity = maxCapacity
        self.wallWhiteBoard = wallWhiteBoard
        self.tableWhiteBoard = tableWhiteBoard
        self.tvAvailable = tvAvailable
        self.image = image
        self.focusArea = focusArea
        self.sofa = sofa
    }
}
