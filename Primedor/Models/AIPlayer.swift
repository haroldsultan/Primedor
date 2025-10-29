import Foundation

struct AIPlayer {
    
    /// Make a move for the AI
    static func makeMove(
        player: Player,
        tokenSupply: TokenSupply,
        visibleCards: [Card],
        turnAction: TurnAction,
        collectedTypesThisTurn: Set<TokenType>,
        tokensCollectedThisTurn: Int
    ) -> AIAction {
        
        // MARK: - Priority 1: Buy a card if possible
        if turnAction == .none {
            let affordableCards = visibleCards.filter { canAffordCard(player: player, card: $0) }
            if !affordableCards.isEmpty {
                let bestCard = affordableCards.max { $0.points < $1.points }
                if let cardToBuy = bestCard {
                    return .buyCard(cardToBuy)
                }
            }
        }
        
        // MARK: - Priority 1.5: Reserve a card (if below reserve limit)
        if turnAction == .none {
            let reserveLimit = 3
            if player.reservedCards.count < reserveLimit {
                let ranked = visibleCards.sorted { $0.points > $1.points }
                for card in ranked.prefix(5) {
                    let short = tokensNeededForCard(player: player, card: card)
                    let totalShort = Double(short.values.reduce(0, +))
                    if totalShort <= 4.0 && Double(card.points) + bonusSynergy(for: player, card: card) > 0 {
                        return .reserveCard(card)
                    }
                }
            }
        }
        
        // MARK: - Priority 2: Collect tokens
        if turnAction == .none || turnAction == .collectingTokens {
            let availableTypes = TokenType.allCases.filter { $0 != .perfect && tokenSupply.count(of: $0) > 0 }
            
            if !availableTypes.isEmpty {
                var tokenToCollect: TokenType? = nil
                
                // Calculate cumulative shortfall for top 3 target cards
                let targetCards = visibleCards.sorted { $0.points > $1.points }
                var cumulativeShortfall: [TokenType: Int] = [:]
                for card in targetCards.prefix(3) {
                    let shortfall = tokensNeededForCard(player: player, card: card)
                    for (type, amount) in shortfall {
                        cumulativeShortfall[type, default: 0] += amount
                    }
                }
                
                // Pick most needed token that hasn’t been collected yet
                let unconsumedAvailableShortfall = cumulativeShortfall
                    .filter { type, _ in availableTypes.contains(type) && !collectedTypesThisTurn.contains(type) }
                    .sorted { $0.value > $1.value }
                
                tokenToCollect = unconsumedAvailableShortfall.first?.key
                
                // Fallback to any uncollected available type
                if tokenToCollect == nil {
                    let unconsumedTypes = availableTypes.filter { !collectedTypesThisTurn.contains($0) }
                    tokenToCollect = unconsumedTypes.randomElement()
                }
                
                // Final fallback: any available token
                if tokenToCollect == nil {
                    tokenToCollect = availableTypes.randomElement()
                }
                
                if let finalToken = tokenToCollect,
                   canCollectToken(tokenType: finalToken,
                                   supply: tokenSupply,
                                   player: player,
                                   tokensCollectedThisTurn: tokensCollectedThisTurn,
                                   collectedTypes: collectedTypesThisTurn) {
                    return .collectToken(finalToken)
                }
            }
        }
        
        // MARK: - Default: End turn
        return .endTurn
    }
    
    // MARK: - Helper Functions
    
    private static func canAffordCard(player: Player, card: Card) -> Bool {
        var remainingNeeded = card.cost
        
        // Apply permanent bonuses
        for type in TokenType.allCases where type != .perfect {
            let bonus = player.bonusCount(of: type)
            let needed = remainingNeeded[type] ?? 0
            remainingNeeded[type] = max(0, needed - bonus)
        }
        
        var perfectTokensNeeded = 0
        for type in TokenType.allCases where type != .perfect {
            let needed = remainingNeeded[type] ?? 0
            let available = player.tokenCount(of: type)
            if available < needed { perfectTokensNeeded += needed - available }
        }
        
        return player.tokenCount(of: .perfect) >= perfectTokensNeeded
    }
    
    private static func tokensNeededForCard(player: Player, card: Card) -> [TokenType: Int] {
        var remainingNeeded = card.cost
        var shortfall: [TokenType: Int] = [:]
        
        for type in TokenType.allCases where type != .perfect {
            let bonus = player.bonusCount(of: type)
            let needed = remainingNeeded[type] ?? 0
            remainingNeeded[type] = max(0, needed - bonus)
        }
        
        for type in TokenType.allCases where type != .perfect {
            let needed = remainingNeeded[type] ?? 0
            let available = player.tokenCount(of: type)
            if available < needed { shortfall[type] = needed - available }
        }
        
        return shortfall
    }
    
    private static func canCollectToken(
        tokenType: TokenType,
        supply: TokenSupply,
        player: Player,
        tokensCollectedThisTurn: Int,
        collectedTypes: Set<TokenType>
    ) -> Bool {
        guard tokenType != .perfect else { return false }
        guard supply.count(of: tokenType) > 0 else { return false }
        guard tokensCollectedThisTurn < 3 else { return false }
        guard player.totalTokenCount < 10 else { return false }
        
        let isNewType = !collectedTypes.contains(tokenType)
        let uniqueTypesCollected = collectedTypes.count
        
        switch tokensCollectedThisTurn {
        case 0: return true
        case 1: return isNewType || supply.count(of: tokenType) >= 4
        case 2: return isNewType && uniqueTypesCollected == 2
        default: return false
        }
    }
    
    // Example heuristic for stronger play
    private static func bonusSynergy(for player: Player, card: Card) -> Double {
        var synergy: Double = 0
        for type in TokenType.allCases where type != .perfect {
            let bonus = player.bonusCount(of: type)
            let needed = card.cost[type] ?? 0
            if needed > 0 { synergy += Double(bonus) * 0.3 }
        }
        return synergy
    }
}

enum AIAction {
    case collectToken(TokenType)
    case buyCard(Card)
    case reserveCard(Card)
    case endTurn
}
