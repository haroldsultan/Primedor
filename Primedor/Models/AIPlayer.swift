import Foundation

struct AIPlayer {
    
    /// Make a move for the AI
    /// This function implements a simple but effective strategy:
    /// 1. First priority: Buy affordable cards if possible
    /// 2. Second priority: Collect tokens to build towards buying cards
    /// 3. Default: End turn when no good moves exist
    static func makeMove(
        player: Player,
        tokenSupply: TokenSupply,
        visibleCards: [Card],
        turnAction: TurnAction,
        collectedTypesThisTurn: Set<TokenType>,
        tokensCollectedThisTurn: Int
    ) -> AIAction {
        
        // Priority 1: Buy a card if possible (only at start of turn)
        if turnAction == .none {
            let affordableCards = visibleCards.filter { card in
                canAffordCard(player: player, card: card)
            }
            
            if !affordableCards.isEmpty {
                // Strategy: Prefer higher point cards first
                // This helps us reach 15 points faster to win the game
                let bestCard = affordableCards.max { card1, card2 in
                    card1.points < card2.points
                }
                
                if let cardToBuy = bestCard {
                    return .buyCard(cardToBuy)
                }
            }
        }
        
        // Priority 2: Collect tokens (only if turn allows it)
        if turnAction == .none || turnAction == .collectingTokens {
            let availableTypes = TokenType.allCases.filter { type in
                tokenSupply.count(of: type) > 0 && type != .perfect
            }
            
            if !availableTypes.isEmpty {
                // Try to collect a token we haven't collected yet this turn
                let unconsumedTypes = availableTypes.filter { !collectedTypesThisTurn.contains($0) }
                
                if !unconsumedTypes.isEmpty {
                    if let tokenType = unconsumedTypes.randomElement() {
                        // Verify we can actually collect this token
                        if canCollectToken(
                            tokenType: tokenType,
                            supply: tokenSupply,
                            player: player,
                            tokensCollectedThisTurn: tokensCollectedThisTurn,
                            collectedTypes: collectedTypesThisTurn
                        ) {
                            return .collectToken(tokenType)
                        }
                    }
                }
                
                // If we've already collected from all available types, try any available
                if let tokenType = availableTypes.first(where: { tokenSupply.count(of: $0) > 0 }) {
                    if canCollectToken(
                        tokenType: tokenType,
                        supply: tokenSupply,
                        player: player,
                        tokensCollectedThisTurn: tokensCollectedThisTurn,
                        collectedTypes: collectedTypesThisTurn
                    ) {
                        return .collectToken(tokenType)
                    }
                }
            }
        }
        
        // Default: End turn
        return .endTurn
    }
    
    // MARK: - Helper Functions
    
    /// Determine if the player can afford a specific card
    private static func canAffordCard(player: Player, card: Card) -> Bool {
        var remainingNeeded = card.cost
        
        // Use permanent bonuses first (player gets discount from purchased cards)
        for type in TokenType.allCases where type != .perfect {
            let bonus = player.bonusCount(of: type)
            let needed = remainingNeeded[type] ?? 0
            let used = min(bonus, needed)
            remainingNeeded[type] = max(0, needed - used)
        }
        
        // Check if we have enough tokens to cover the remaining cost
        for type in TokenType.allCases where type != .perfect {
            let needed = remainingNeeded[type] ?? 0
            let available = player.tokenCount(of: type)
            
            if available < needed {
                return false
            }
        }
        
        return true
    }
    
    /// Determine if the player can collect a specific token
    private static func canCollectToken(
        tokenType: TokenType,
        supply: TokenSupply,
        player: Player,
        tokensCollectedThisTurn: Int,
        collectedTypes: Set<TokenType>
    ) -> Bool {
        // Can't collect perfect tokens
        guard tokenType != .perfect else { return false }
        
        // Must have tokens available in supply
        guard supply.count(of: tokenType) > 0 else { return false }
        
        // Can't exceed 3 tokens in a turn
        if tokensCollectedThisTurn >= 3 {
            return false
        }
        
        // Can't exceed 10 tokens in hand
        if player.totalTokenCount >= 10 {
            return false
        }
        
        return true
    }
}

enum AIAction {
    case collectToken(TokenType)
    case buyCard(Card)
    case reserveCard(Card)
    case endTurn
}
