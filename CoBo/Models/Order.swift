//
//  OrderModel.swift
//  CoBo
//
//  Created by Rieno on 16/05/25.
//

import SwiftUI

import Foundation

struct OrderModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var collabType: String
    var quantity: Int
}
