//
//  User.swift
//  CoBo
//
//  Created by Evan Lokajaya on 25/03/25.
//

import Foundation
import SwiftData

@Model
class User: Codable {
    enum keys: CodingKey {
        case name
        case email
    }
    
    var name: String
    var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: keys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: keys.self)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
    }
}
