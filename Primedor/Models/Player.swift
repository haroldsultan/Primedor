//
//  Player.swift
//  Primedor
//
//  Represents a player's state including tokens, cards, bonuses, and victory points
//

import Foundation

/// Represents a single player in the game
class Player: Identifiable, Codable {
    let id: UUID
    var name: String
    let isAI: Bool
    
    /// Tokens currently held by this player
    private(set) var tokens: [TokenType: [Token]]
    
    /// Cards purchased by this player (provide permanent bonuses)
    private(set) var purchasedCards: [Card]
    
    /// Cards reserved by this player (max 3)
    private(set) var reservedCards: [Card]
    
    /// Mathematicians acquired by this player
    private(set) var mathematicians: [Mathematician]
    
    init(name: String, isAI: Bool = false) {
        self.id = UUID()
        self.name = name
        self.isAI = isAI
        self.tokens = [:]
        self.purchasedCards = []
        self.reservedCards = []
        self.mathematicians = []
    }
    
    // MARK: - Token Management
    
    /// Add tokens to player's hand
    func addTokens(_ tokensToAdd: [Token]) {
        for token in tokensToAdd {
            if tokens[token.type] == nil {
                tokens[token.type] = []
            }
            tokens[token.type]?.append(token)
        }
    }
    
    /// Remove tokens from player's hand (returns removed tokens)
    func removeTokens(_ type: TokenType, count: Int) -> [Token] {
        var removed: [Token] = []
        for _ in 0..<count {
            if let token = tokens[type]?.popLast() {
                removed.append(token)
            }
        }
        return removed
    }
    
    /// Get count of tokens of a specific type
    func tokenCount(of type: TokenType) -> Int {
        return tokens[type]?.count ?? 0
    }
    
    /// Total number of tokens held
    var totalTokenCount: Int {
        return tokens.values.reduce(0) { $0 + $1.count }
    }
    
    /// Check if player exceeds token limit (10 tokens)
    var exceedsTokenLimit: Bool {
        return totalTokenCount > 10
    }
    
    // MARK: - Card Management
    
    /// Purchase a card (add to purchased cards)
    func purchaseCard(_ card: Card) {
        purchasedCards.append(card)
    }
    
    /// Reserve a card (add to reserved cards, max 3)
    func reserveCard(_ card: Card) -> Bool {
        guard reservedCards.count < 3 else { return false }
        reservedCards.append(card)
        return true
    }
    
    /// Remove a reserved card (used when purchasing from reserve)
    func removeReservedCard(_ card: Card) {
        reservedCards.removeAll { $0.id == card.id }
    }
    
    // MARK: - Bonuses
    
    /// Calculate permanent bonuses from purchased cards
    var bonuses: [TokenType: Int] {
        var bonusCount: [TokenType: Int] = [:]
        for card in purchasedCards {
            bonusCount[card.bonus, default: 0] += 1
        }
        return bonusCount
    }
    
    /// Get bonus count for specific token type
    func bonusCount(of type: TokenType) -> Int {
        return bonuses[type] ?? 0
    }
    
    // MARK: - Mathematician Management
    
    /// Add a mathematician to the player
    func addMathematician(_ mathematician: Mathematician) {
        mathematicians.append(mathematician)
    }
    
    // MARK: - Victory Points
    
    /// Calculate total victory points
    var victoryPoints: Int {
        let cardPoints = purchasedCards.reduce(0) { $0 + $1.points }
        let mathematicianPoints = mathematicians.reduce(0) { $0 + $1.points }
        return cardPoints + mathematicianPoints
    }
    
    func claimMathematician(_ mathematician: Mathematician) {
        mathematicians.append(mathematician)
    }
}
