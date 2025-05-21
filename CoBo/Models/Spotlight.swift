//
//  SpotlightModel.swift
//  CoBo
//
//  Created by Rieno on 16/05/25.
//


import Foundation

// MARK: -- Temporary Persistence
@Observable
class OrderViewModel {
    
    static let shared = OrderViewModel()
    
    var orderList: [OrderModel] = []
    
    func addOrder(name: String, collabType: String, quantity: Int) {
        var newOrder = OrderModel(name: name, collabType: collabType, quantity: quantity)
        OrderViewModel.shared.orderList.append(newOrder)
    }
    
}
