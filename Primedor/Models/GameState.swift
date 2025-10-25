//
//  GameState.swift
//  Primedor
//
//  Master game state that coordinates all game components
//

import Foundation
import Combine

/// Represents the complete state of a Primedor game
class GameState: ObservableObject {
    let id: UUID
    
    /// All players in the game
    private(set) var players: [Player]
    
    /// Index of the current player
    private(set) var currentPlayerIndex: Int
    
    /// The central token supply
    private(set) var tokenSupply: TokenSupply
    
    /// Available mathematician cards
    private(set) var availableMathematicians: [Mathematician]
    
    /// Mathematicians that have been claimed
    private(set) var claimedMathematicians: [Mathematician]
    
    /// Cards visible on the board (4 per tier)
    private(set) var visibleCards: [CardTier: [Card]]
    
    /// Card decks (remaining cards not yet revealed)
    private(set) var cardDecks: [CardTier: [Card]]
    
    /// Whether the game has ended
    private(set) var isGameOver: Bool
    
    /// The winner (if game is over)
    private(set) var winner: Player?
    
    init(playerCount: Int, playerNames: [String]) {
        guard TokenConfiguration.isValidPlayerCount(playerCount) else {
            fatalError("Invalid player count: \(playerCount)")
        }
        guard playerNames.count == playerCount else {
            fatalError("Player name count (\(playerNames.count)) doesn't match player count (\(playerCount))")
        }
        
        self.id = UUID()
        self.players = playerNames.map { Player(name: $0) }
        self.currentPlayerIndex = 0
        self.tokenSupply = TokenSupply(playerCount: playerCount)
        self.availableMathematicians = []
        self.claimedMathematicians = []
        self.visibleCards = [
            .one: [],
            .two: [],
            .three: []
        ]
        self.cardDecks = [
            .one: [],
            .two: [],
            .three: []
        ]
        self.isGameOver = false
        self.winner = nil
    }
    
    /// Get the current player
    var currentPlayer: Player {
        return players[currentPlayerIndex]
    }
    
    /// Advance to the next player
    func nextPlayer() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
    }
    
    /// Set up mathematicians for the game (will be populated from database)
    func setupMathematicians(_ mathematicians: [Mathematician]) {
        // Number of mathematicians = player count + 1
        let count = min(mathematicians.count, players.count + 1)
        self.availableMathematicians = Array(mathematicians.prefix(count))
    }
    
    /// Set up card decks (will be populated from database)
    func setupCardDecks(_ allCards: [Card]) {
        // Separate cards by tier
        let tier1Cards = allCards.filter { $0.tier == .one }.shuffled()
        let tier2Cards = allCards.filter { $0.tier == .two }.shuffled()
        let tier3Cards = allCards.filter { $0.tier == .three }.shuffled()
        
        // Keep first 4 as visible, rest as deck
        self.visibleCards[.one] = Array(tier1Cards.prefix(4))
        self.visibleCards[.two] = Array(tier2Cards.prefix(4))
        self.visibleCards[.three] = Array(tier3Cards.prefix(4))
        
        self.cardDecks[.one] = Array(tier1Cards.dropFirst(4))
        self.cardDecks[.two] = Array(tier2Cards.dropFirst(4))
        self.cardDecks[.three] = Array(tier3Cards.dropFirst(4))
    }
    
    /// Draw a card from a deck to replace a purchased/reserved card
    func drawCard(from tier: CardTier) -> Card? {
        guard var deck = cardDecks[tier], !deck.isEmpty else { return nil }
        let card = deck.removeFirst()
        cardDecks[tier] = deck
        return card
    }
    
    /// Remove a visible card (when purchased or reserved)
    func removeVisibleCard(_ card: Card) {
        if var cards = visibleCards[card.tier] {
            cards.removeAll { $0.id == card.id }
            visibleCards[card.tier] = cards
            
            // Draw replacement if available
            if let replacement = drawCard(from: card.tier) {
                cards.append(replacement)
                visibleCards[card.tier] = cards
            }
        }
    }
    
    /// Claim a mathematician for a player
    func claimMathematician(_ mathematician: Mathematician, for player: Player) {
        availableMathematicians.removeAll { $0.id == mathematician.id }
        claimedMathematicians.append(mathematician)
        player.addMathematician(mathematician)
    }
    
    /// End the game and determine winner
    func endGame() {
        isGameOver = true
        
        // Find player(s) with highest score
        let maxPoints = players.map { $0.victoryPoints }.max() ?? 0
        let winners = players.filter { $0.victoryPoints == maxPoints }
        
        // Tiebreaker: fewest purchased cards
        if winners.count > 1 {
            let minCards = winners.map { $0.purchasedCards.count }.min() ?? 0
            let finalWinners = winners.filter { $0.purchasedCards.count == minCards }
            winner = finalWinners.first
        } else {
            winner = winners.first
        }
    }
    
    /// Get all visible cards as a flat array
    var allVisibleCards: [Card] {
        return visibleCards.values.flatMap { $0 }
    }
    
    /// Total number of cards remaining in all decks
    var totalCardsInDecks: Int {
        return cardDecks.values.reduce(0) { $0 + $1.count }
    }
}
