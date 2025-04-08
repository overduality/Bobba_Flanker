//
//  SearchableDropdownProtocol.swift
//  CoBo
//
//  Created by Evan Lokajaya on 26/03/25.
//

import Foundation

protocol DropdownProtocol: Identifiable, Equatable {
    var dropdownLabel: String { get }
    var value: Any { get }
}
