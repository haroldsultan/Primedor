//
//  Token.swift
//  Primedor
//
//  Core token model representing the game's resources
//

import Foundation

enum TokenType: String, CaseIterable, Codable, Hashable {
    // Standard Gem Colors (Development Card Bonuses & Gem Costs)
    case prime = "Primes"       // Corresponds to Red chips (Ruby)
    case even = "Evens"         // Corresponds to Blue chips (Sapphire)
    case odd = "Odds"           // Corresponds to Green chips (Emerald)
    case square = "Squares"     // Corresponds to Black chips (Onyx)
    case sequence = "Sequences" // Corresponds to White chips (Diamond)
    
    // Wild Gem (Cost only, no card bonus)
    case perfect = "Perfect Numbers" // Corresponds to Gold chips (wild)
    
    /// Visual identifier for UI
    var symbol: String {
        switch self {
        case .prime: return "P"
        case .even: return "E"
        case .odd: return "O"
        case .square: return "□"
        case .sequence: return "S"
        case .perfect: return "★"
        }
    }
    
    /// Whether this token type can act as any other type
    var isWild: Bool {
        return self == .perfect
    }
    
    /// Standard (non-wild) token types
    static var standard: [TokenType] {
        return [.prime, .even, .odd, .square, .sequence]
    }
}

/// A token instance with its type
struct Token: Identifiable, Codable, Hashable {
    let id: UUID
    let type: TokenType
    
    init(type: TokenType) {
        self.id = UUID()
        self.type = type
    }
    
    /// For testing - create token with specific ID
    init(id: UUID = UUID(), type: TokenType) {
        self.id = id
        self.type = type
    }
}
