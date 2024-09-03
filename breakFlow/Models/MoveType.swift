//
//  MoveType.swift
//  breakFlow
//
//  Created by Viktor Gordienko on 9/3/24.
//

enum MoveType: String, CaseIterable, Codable, Identifiable {
    case topRock
    case drop
    case footWork
    case powerMove
    case tricks
    case freeze
    
    var id: String { self.rawValue }
}
