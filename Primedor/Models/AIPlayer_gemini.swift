import Foundation

enum AIAction {
    case collectToken(TokenType)
    case buyCard(Card)
    case buyReservedCard(Card)  // NEW: Distinguish reserved card purchases
    case reserveCard(Card)
    case endTurn
}

// MARK: - AI Constants and Tuning (New Structure for Magic Numbers)
private struct AITuning {
    static let reserveLimit = 3
    static let maxShortfallToReserve: Int? = nil
    static let tokensToConsiderForShortfall = 4
    static let minReserveValueToAct = 1.0
    
    // Scoring Weights
    static let pointsWeight: Double = 2.0
    static let efficiencyWeight: Double = 1.5
    static let bonusSynergyWeight: Double = 1.0
    static let nobleProximityWeight: Double = 0.5
}

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
        
        // If turn hasn't started or is incomplete, we may buy/reserve or collect
        if turnAction == .none {
            
            // --- Priority 1: Buy the best affordable reserved card (STRATEGIC FIX: HIGH PRIORITY) ---
            let affordableReserved = player.reservedCards.filter { canAffordCard(player: player, card: $0) }
            if !affordableReserved.isEmpty {
                let best = affordableReserved.max {
                    scoreCard(player: player, card: $0, visibleCards: visibleCards) < scoreCard(player: player, card: $1, visibleCards: visibleCards)
                }
                if let card = best { return .buyReservedCard(card) }  // FIXED: Return buyReservedCard instead of buyCard
            }
            
            // --- Priority 2: Buy the best affordable visible card ---
            let affordableVisible = visibleCards.filter { canAffordCard(player: player, card: $0) }
            if !affordableVisible.isEmpty {
                let best = affordableVisible.max {
                    scoreCard(player: player, card: $0, visibleCards: visibleCards) < scoreCard(player: player, card: $1, visibleCards: visibleCards)
                }
                if let card = best { return .buyCard(card) }
            }
            
            // --- Priority 3: Reserve a valuable card (if below reserve limit) ---
            if player.reservedCards.count < AITuning.reserveLimit && !visibleCards.isEmpty {
                
                let goldAvailable = tokenSupply.count(of: .perfect) > 0
                
                let reserveTargets: [(card: Card, value: Double)] = visibleCards.compactMap { card in
                    let shortfall = tokensNeededForCard(player: player, card: card)
                    let shortfallSum = shortfall.values.reduce(0, +)
                    
                    guard shortfallSum > 0 else { return nil }
                    if let maxShortfall = AITuning.maxShortfallToReserve, shortfallSum > maxShortfall { return nil }
                    
                    let score = scoreCard(player: player, card: card, visibleCards: visibleCards)
                    let reserveValue = score / Double(shortfallSum + 1)
                    return (card, reserveValue)
                }
                
                if let bestReserve = reserveTargets.max(by: { $0.value < $1.value }),
                   bestReserve.value > AITuning.minReserveValueToAct {
                    
                    if goldAvailable || bestReserve.value > 2.0 {
                        return .reserveCard(bestReserve.card)
                    }
                }
            }
        }
        
        // --- Priority 4: Collect tokens (either turn just started or we are collecting tokens) ---
        if turnAction == .none || turnAction == .collectingTokens {
            
            // SIMPLE FIX 1: Immediate End-Turn for collection completion (Claude feedback)
            if turnAction == .collectingTokens && tokensCollectedThisTurn >= 3 {
                 return .endTurn
            }
            
            let targetCards = visibleCards + player.reservedCards
            
            let scoredTargets = targetCards.sorted {
                scoreCard(player: player, card: $0, visibleCards: visibleCards) > scoreCard(player: player, card: $1, visibleCards: visibleCards)
            }
            
            var cumulativeShortfall: [TokenType: Int] = [:]
            for card in scoredTargets.prefix(AITuning.tokensToConsiderForShortfall) {
                let short = tokensNeededForCard(player: player, card: card)
                for (t, amt) in short { cumulativeShortfall[t, default: 0] += amt }
            }
            
            let availableTypes = TokenType.standard.filter { tokenSupply.count(of: $0) > 0 }
            guard !availableTypes.isEmpty else { return .endTurn }
            
            let uncollectedShortfallSorted = cumulativeShortfall
                .filter { (type, _) in availableTypes.contains(type) && !collectedTypesThisTurn.contains(type) }
                .sorted { $0.value > $1.value }
                .map { $0.key }
            
            var tokenToCollect: TokenType? = nil
            
            if tokensCollectedThisTurn == 0 {
                if let doubleCandidate = uncollectedShortfallSorted.first(where: { tokenSupply.count(of: $0) >= 4 && cumulativeShortfall[$0, default: 0] > 0 }) {
                    tokenToCollect = doubleCandidate
                }
            }
            
            if tokenToCollect == nil {
                tokenToCollect = uncollectedShortfallSorted.first
            }
            
            if tokenToCollect == nil {
                let scored = availableTypes.map { (type: TokenType) -> (TokenType, Double) in
                    return (type, scoreTokenType(type, player: player, allTargetCards: targetCards, tokenSupply: tokenSupply))
                }
                let uncollected = scored.filter { !collectedTypesThisTurn.contains($0.0) }
                let candidate = (uncollected.isEmpty ? scored : uncollected).max { $0.1 < $1.1 }?.0
                tokenToCollect = candidate
            }
            
            // Final check: validate with canCollectToken
            if let finalType = tokenToCollect,
               canCollectToken(
                   tokenType: finalType,
                   supply: tokenSupply,
                   player: player,
                   tokensCollectedThisTurn: tokensCollectedThisTurn,
                   collectedTypes: collectedTypesThisTurn
               ) {
                // The canCollectToken check now incorporates the total token limit check,
                // making this entire block robust and eliminating the fragile prediction math.
                return .collectToken(finalType)
            }
            
            // fallback: any legal token
            if let legalRandom = availableTypes.first(where: {
                canCollectToken(
                    tokenType: $0,
                    supply: tokenSupply,
                    player: player,
                    tokensCollectedThisTurn: tokensCollectedThisTurn,
                    collectedTypes: collectedTypesThisTurn
                )
            }) {
                return .collectToken(legalRandom)
            }
        }
        
        // Default: end turn
        return .endTurn
    }
    
    
    // MARK: - Scoring & helper functions (Unmodified since last review)
    
    private static func scoreCard(player: Player, card: Card, visibleCards: [Card]) -> Double {
        let points = Double(card.points)
        var tokensRequired = 0
        for type in TokenType.standard {
            let bonus = player.bonusCount(of: type)
            let need = card.cost[type] ?? 0
            tokensRequired += max(0, need - bonus)
        }
        
        let efficiency: Double
        if tokensRequired > 0 {
            efficiency = points / Double(tokensRequired)
        } else {
            efficiency = points > 0 ? points * 3.0 : 1.0
        }
        
        let cardBonus = card.bonus
        var bonusSynergyScore: Double = 0.0
        if cardBonus != .perfect {
            let topTargets = (player.reservedCards + visibleCards)
                .sorted { $0.points > $1.points }
                .prefix(3)
            if topTargets.contains(where: { ($0.cost[cardBonus] ?? 0) > 0 }) {
                bonusSynergyScore = 1.0
            }
        }
        
        let noble = nobleClaimProximity(for: player, card: card, allTargets: player.reservedCards + visibleCards)
        
        return points * AITuning.pointsWeight
             + efficiency * AITuning.efficiencyWeight
             + bonusSynergyScore * AITuning.bonusSynergyWeight
             + noble * AITuning.nobleProximityWeight
    }
    
    private static func scoreTokenType(
        _ type: TokenType,
        player: Player,
        allTargetCards: [Card],
        tokenSupply: TokenSupply
    ) -> Double {
        var score: Double = 0
        
        let cardsNeeding = allTargetCards.filter { ($0.cost[type] ?? 0) > 0 }
        for card in cardsNeeding {
            let short = tokensNeededForCard(player: player, card: card)
            let shortAmt = Double(short.values.reduce(0, +))
            let pv = Double(card.points)
            
            if shortAmt <= 2 {
                score += pv * 2.0
            } else if shortAmt <= 4 {
                score += pv * 1.2
            } else {
                score += pv * 0.5
            }
        }
        
        let remaining = tokenSupply.count(of: type)
        if remaining <= 4 {
            score *= 1.25
        }
        
        return score
    }
    
    private static func nobleClaimProximity(for player: Player, card: Card, allTargets: [Card]) -> Double {
        let bonus = card.bonus
        guard bonus != .perfect else { return 0.0 }
        
        let topTargets = allTargets
            .sorted { $0.points > $1.points }
            .prefix(3)
        
        let countUseful = topTargets.filter { ($0.cost[bonus] ?? 0) > 0 }.count
        
        return Double(countUseful) / 3.0
    }
    
    private static func canAffordCard(player: Player, card: Card) -> Bool {
        var remainingNeeded = card.cost
        for type in TokenType.standard {
            let bonus = player.bonusCount(of: type)
            let needed = remainingNeeded[type] ?? 0
            remainingNeeded[type] = max(0, needed - bonus)
        }
        
        var perfectTokensNeeded = 0
        for type in TokenType.standard {
            let needed = remainingNeeded[type] ?? 0
            let available = player.tokenCount(of: type)
            if available < needed { perfectTokensNeeded += needed - available }
        }
        
        return player.tokenCount(of: .perfect) >= perfectTokensNeeded
    }
    
    private static func tokensNeededForCard(player: Player, card: Card) -> [TokenType: Int] {
        var remainingNeeded = card.cost
        var shortfall: [TokenType: Int] = [:]
        
        for type in TokenType.standard {
            let bonus = player.bonusCount(of: type)
            let needed = remainingNeeded[type] ?? 0
            remainingNeeded[type] = max(0, needed - bonus)
        }
        
        for type in TokenType.standard {
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
        
        let isNewType = !collectedTypes.contains(tokenType)
        
        let tokensToTake: Int
        
        switch tokensCollectedThisTurn {
        case 0:
            // Could take 1 (new type) or 2 (same type, if supply allows)
            if supply.count(of: tokenType) >= 4 {
                tokensToTake = 2 // Attempt to take 2
            } else {
                tokensToTake = 1 // Take 1
            }
        case 1:
            if collectedTypes.contains(tokenType) {
                // Already took this type once, so must take a second (supply >= 4 checked below)
                tokensToTake = 1
            } else {
                // Taking a second DIFFERENT type
                tokensToTake = 1
            }
        case 2:
            // Must be a third DIFFERENT type
            guard isNewType && collectedTypes.count == 2 else { return false }
            tokensToTake = 1
        default:
            return false
        }
        
        // SIMPLE FIX 2: Centralized and robust check for the 10-token limit (Claude/OpenAI feedback)
        if player.totalTokenCount + tokensToTake > 10 {
            return false
        }
        
        // Final rule check (moved from main logic):
        if collectedTypes.contains(tokenType) && tokensCollectedThisTurn == 1 {
            return supply.count(of: tokenType) >= 4 // Check if we can legally take a second of the same type
        }
        
        return true
    }
}
