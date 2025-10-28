import Foundation

struct AIPlayer {
     
    /// Make a move for the AI
    /// This function implements an improved strategy:
    /// 1. First priority: Buy affordable cards (highest points)
    /// 2. Second priority: Reserve a card if it's a good target and reservation is possible (new)
    /// 3. Third priority: Collect tokens strategically (target-based, new)
    /// 4. Default: End turn when no good moves exist
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
         
        // Priority 1.5: Reserve a good card (only at start of turn)
        // This reserves a high-value card that the player is close to affording
        if turnAction == .none {
            // Find the highest point card the AI is close to affording
            let reservableCards = visibleCards
                .sorted(by: { $0.points > $1.points }) // Check high-point cards first
                .filter { card in
                    // Only consider cards the player CANNOT currently afford
                    !canAffordCard(player: player, card: card)
                }

            if let cardToReserve = reservableCards.first {
                let shortfall = tokensNeededForCard(player: player, card: cardToReserve)
                let totalShortfall = shortfall.values.reduce(0, +)
                
                // Reserve if:
                // 1. We actually need tokens for it (totalShortfall > 0)
                // 2. The card is reasonably close (e.g., within 5 tokens)
                // 3. The card gives points (incentive to reserve)
                // 4. We assume the player hasn't hit their reserve limit (e.g., 3)
                if totalShortfall > 0 && totalShortfall <= 5 && cardToReserve.points > 0 {
                    // This action will also grant a Perfect token if one is available
                    return .reserveCard(cardToReserve)
                }
            }
        }
        
        // Priority 2: Collect tokens (only if turn allows it)
        if turnAction == .none || turnAction == .collectingTokens {
            let availableTypes = TokenType.allCases.filter { type in
                tokenSupply.count(of: type) > 0 && type != .perfect
            }
             
            if !availableTypes.isEmpty {
                
                var tokenToCollect: TokenType? = nil
                
                // 1. Use new intelligence to find the most needed token
                let targetCards = visibleCards.sorted(by: { $0.points > $1.points })
                
                var cumulativeShortfall: [TokenType: Int] = [:]
                // Calculate cumulative shortfall for the top 3 visible cards
                for card in targetCards.prefix(3) {
                    let shortfall = tokensNeededForCard(player: player, card: card)
                    for (type, amount) in shortfall {
                        cumulativeShortfall[type, default: 0] += amount
                    }
                }
                
                // Filter for available, uncollected, and needed tokens, then pick the most needed
                let unconsumedAvailableShortfall = cumulativeShortfall
                    .filter { type, _ in
                        availableTypes.contains(type) && !collectedTypesThisTurn.contains(type)
                    }
                    .sorted(by: { $0.value > $1.value })
                
                tokenToCollect = unconsumedAvailableShortfall.first?.key
                
                // 2. Fallback to random unique if goal-oriented failed
                if tokenToCollect == nil {
                    let unconsumedTypes = availableTypes.filter { !collectedTypesThisTurn.contains($0) }
                    tokenToCollect = unconsumedTypes.randomElement()
                }

                // 3. Final safety fallback: just collect any available token type
                if tokenToCollect == nil {
                    tokenToCollect = availableTypes.randomElement()
                }
                 
                // Execute the best move found
                if let finalToken = tokenToCollect {
                    // Check legality with the improved canCollectToken logic
                    if canCollectToken(
                        tokenType: finalToken,
                        supply: tokenSupply,
                        player: player,
                        tokensCollectedThisTurn: tokensCollectedThisTurn,
                        collectedTypes: collectedTypesThisTurn
                    ) {
                        return .collectToken(finalToken)
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
         
        // 1. Use permanent bonuses first (player gets discount from purchased cards)
        for type in TokenType.allCases where type != .perfect {
            let bonus = player.bonusCount(of: type)
            let needed = remainingNeeded[type] ?? 0
            let used = min(bonus, needed)
            remainingNeeded[type] = max(0, needed - used)
        }
         
        var perfectTokensNeeded = 0
        
        // 2. Calculate the token shortfall after bonuses
        for type in TokenType.allCases where type != .perfect {
            let needed = remainingNeeded[type] ?? 0
            let available = player.tokenCount(of: type)
             
            if available < needed {
                // Shortfall is covered by Perfect tokens
                perfectTokensNeeded += (needed - available)
            }
        }
        
        // 3. Final check: Can the Perfect tokens cover the shortfall?
        let perfectTokensAvailable = player.tokenCount(of: .perfect)
        
        if perfectTokensAvailable < perfectTokensNeeded {
            return false // Not enough Perfect tokens (or regular tokens) to cover the cost
        }
        
        return true
    }
     
    /// Calculates how many tokens (of each type) a player is short of affording a card,
    /// accounting for permanent bonuses.
    private static func tokensNeededForCard(player: Player, card: Card) -> [TokenType: Int] {
        var remainingNeeded = card.cost
        var shortfall: [TokenType: Int] = [:]

        // 1. Use permanent bonuses (discounts) first
        for type in TokenType.allCases where type != .perfect {
            let bonus = player.bonusCount(of: type)
            let needed = remainingNeeded[type] ?? 0
            let used = min(bonus, needed)
            remainingNeeded[type] = max(0, needed - used)
        }

        // 2. Check current tokens vs. remaining cost (this is the true shortfall)
        for type in TokenType.allCases where type != .perfect {
            let needed = remainingNeeded[type] ?? 0
            let available = player.tokenCount(of: type)

            if available < needed {
                let difference = needed - available
                shortfall[type] = difference
            }
        }
        
        // The total perfect tokens needed is calculated by the AI as part of its strategy,
        // but this function returns the specific color shortfall before considering Perfect tokens on hand.
        return shortfall
    }

    /// Determine if the player can collect a specific token
    private static func canCollectToken(
        tokenType: TokenType,
        supply: TokenSupply,
        player: Player,
        tokensCollectedThisTurn: Int,
        collectedTypes: Set<TokenType>
    ) -> Bool {
        // Can't collect perfect tokens directly
        guard tokenType != .perfect else { return false }
         
        let supplyCount = supply.count(of: tokenType)
        // Must have tokens available in supply
        guard supplyCount > 0 else { return false }
         
        // Can't exceed 3 total tokens in a turn
        if tokensCollectedThisTurn >= 3 {
            return false
        }
         
        // Can't exceed 10 tokens in hand (after collecting)
        if player.totalTokenCount >= 10 {
            return false
        }
        
        // BUG FIX/RULE ENFORCEMENT: Enforce the "3 unique tokens" or "2 identical tokens" rule.
        
        let isNewType = !collectedTypes.contains(tokenType)
        let uniqueTypesCollected = collectedTypes.count
        
        if tokensCollectedThisTurn == 0 {
            // Start of turn: Allowed to collect 1 (start of 3 unique) or 2 (start of 2 identical)
            return true
        } else if tokensCollectedThisTurn == 1 {
            // Second token:
            if isNewType {
                // Collecting a 2nd unique type is fine (part of the 3 unique rule)
                return true
            } else {
                // Collecting a 2nd identical type is ONLY fine if the supply is >= 4
                return supplyCount >= 4
            }
        } else if tokensCollectedThisTurn == 2 {
            // Third token:
            if isNewType && uniqueTypesCollected == 2 {
                // This is the 3rd unique token, which is allowed.
                return true
            }
            
            // Any other scenario (e.g., trying to collect a 3rd of the same type, or the 3rd token when only 1 unique type was collected) is illegal.
            return false
        }
         
        // Should be caught by tokensCollectedThisTurn >= 3, but a final safe return.
        return false
    }
}

enum AIAction {
    case collectToken(TokenType)
    case buyCard(Card)
    case reserveCard(Card)
    case endTurn
}
