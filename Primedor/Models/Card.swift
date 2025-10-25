//
//  Card.swift
//  Primedor
//
//  Represents a theorem card with its cost, bonus, and victory points
//

import Foundation

/// Difficulty tier of the theorem card
enum CardTier: Int, CaseIterable, Codable {
    case one = 1
    case two = 2
    case three = 3
    
    var name: String {
        switch self {
        case .one: return "Basic Theorems"
        case .two: return "Intermediate Theorems"
        case .three: return "Advanced Theorems"
        }
    }
}

/// A theorem card that can be purchased and provides permanent bonuses
struct Card: Identifiable, Codable, Hashable {
    let id: UUID
    let tier: CardTier
    let name: String
    
    /// Cost to prove this theorem (tokens needed to purchase)
    let cost: [TokenType: Int]
    
    /// Permanent discount this card provides after purchase
    let bonus: TokenType
    
    /// Victory points this card is worth
    let points: Int
    
    init(tier: CardTier, name: String, cost: [TokenType: Int], bonus: TokenType, points: Int) {
        self.id = UUID()
        self.tier = tier
        self.name = name
        self.cost = cost
        self.bonus = bonus
        self.points = points
    }
    
    /// For testing - create card with specific ID
    init(id: UUID = UUID(), tier: CardTier, name: String, cost: [TokenType: Int], bonus: TokenType, points: Int) {
        self.id = id
        self.tier = tier
        self.name = name
        self.cost = cost
        self.bonus = bonus
        self.points = points
    }
    
    /// Total number of tokens required to purchase
    var totalCost: Int {
        return cost.values.reduce(0, +)
    }
}
