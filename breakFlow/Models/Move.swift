//
//  Move.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 9/3/24.
//

import Foundation

struct Move: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var type: MoveType
    var isEnabled: Bool = true
    
    init(
        id: UUID = UUID(),
        name: String = "",
        type: MoveType = .topRock,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.isEnabled = isEnabled
    }
}
