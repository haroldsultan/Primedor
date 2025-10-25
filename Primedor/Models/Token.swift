//
//  Token.swift
//  Primedor
//
//  Core token model representing the game's resources
//

import Foundation

/// Represents the different types of tokens (resources) in the game
enum TokenType: String, CaseIterable, Codable, Hashable {
    case prime = "Primes"           // Red chips
    case even = "Evens"              // Blue chips
    case odd = "Odds"                // Green chips
    case square = "Squares"          // Black chips
    case sequence = "Sequences"      // White chips
    case perfect = "Perfect Numbers" // Gold chips (wild)
    
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
