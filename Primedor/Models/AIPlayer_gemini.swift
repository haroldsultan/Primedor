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
        
        // If turn hasn't started or is incomplete, we may buy/reserve or collect
        if turnAction == .none {
            // --- Priority 1: Buy the best affordable visible card ---
            let affordableVisible = visibleCards.filter { canAffordCard(player: player, card: $0) }
            if !affordableVisible.isEmpty {
                let best = affordableVisible.max {
                    scoreCard(player: player, card: $0, visibleCards: visibleCards) < scoreCard(player: player, card: $1, visibleCards: visibleCards)
                }
                if let card = best { return .buyCard(card) }
            }
            
            // --- Priority 1.5: Buy the best affordable reserved card ---
            let affordableReserved = player.reservedCards.filter { canAffordCard(player: player, card: $0) }
            if !affordableReserved.isEmpty {
                let best = affordableReserved.max {
                    scoreCard(player: player, card: $0, visibleCards: visibleCards) < scoreCard(player: player, card: $1, visibleCards: visibleCards)
                }
                if let card = best { return .buyCard(card) }
            }
            
            // --- Priority 2: Reserve a valuable card (if below reserve limit) ---
            let reserveLimit = 3
            if player.reservedCards.count < reserveLimit && !visibleCards.isEmpty {
                // Evaluate reserve targets: only those with some shortfall and reasonable shortfall size
                let reserveTargets: [(card: Card, value: Double)] = visibleCards.compactMap { card in
                    let shortfallSum = tokensNeededForCard(player: player, card: card).values.reduce(0, +)
                    guard shortfallSum > 0 && shortfallSum <= 6 else { return nil }
                    let score = scoreCard(player: player, card: card, visibleCards: visibleCards)
                    let reserveValue = score / Double(shortfallSum + 1)
                    return (card, reserveValue)
                }
                
                if let bestReserve = reserveTargets.max(by: { $0.value < $1.value }), bestReserve.value > 1.0 {
                    return .reserveCard(bestReserve.card)
                }
            }
        }
        
        // --- Priority 3: Collect tokens (either turn just started or we are collecting tokens) ---
        if turnAction == .none || turnAction == .collectingTokens {
            // Consider both visible & reserved cards when computing needs
            let targetCards = visibleCards + player.reservedCards
            
            // Compute cumulative shortfall for top N-scored targets (score uses visibleCards for context)
            let scoredTargets = targetCards.sorted {
                scoreCard(player: player, card: $0, visibleCards: visibleCards) > scoreCard(player: player, card: $1, visibleCards: visibleCards)
            }
            
            var cumulativeShortfall: [TokenType: Int] = [:]
            for card in scoredTargets.prefix(5) {
                let short = tokensNeededForCard(player: player, card: card)
                for (t, amt) in short { cumulativeShortfall[t, default: 0] += amt }
            }
            
            let availableTypes = TokenType.allCases.filter { $0 != .perfect && tokenSupply.count(of: $0) > 0 }
            guard !availableTypes.isEmpty else { return .endTurn }
            
            // Prefer tokens with highest shortfall need that weren't taken this turn
            let uncollectedShortfallSorted = cumulativeShortfall
                .filter { (type, _) in availableTypes.contains(type) && !collectedTypesThisTurn.contains(type) }
                .sorted { $0.value > $1.value }
                .map { $0.key }
            
            var tokenToCollect: TokenType? = nil
            
            // Strategy: Double-Collect when it's legal AND clearly useful (supply >=4 and token needed)
            if tokensCollectedThisTurn == 0 {
                if let doubleCandidate = availableTypes.first(where: { tokenSupply.count(of: $0) >= 4 && cumulativeShortfall[$0, default: 0] > 0 }) {
                    tokenToCollect = doubleCandidate
                }
            }
            
            // If not double-collecting, pick the most-needed token by cumulative shortfall
            if tokenToCollect == nil {
                tokenToCollect = uncollectedShortfallSorted.first
            }
            
            // If shortfall does not point to anything, fall back to scoring tokens (Claude idea)
            if tokenToCollect == nil {
                // Score tokens by how many/which cards they help, how close those cards are, and supply
                let scored = availableTypes.map { (type: TokenType) -> (TokenType, Double) in
                    return (type, scoreTokenType(type, player: player, visibleCards: visibleCards, tokenSupply: tokenSupply))
                }
                // Prefer uncollected types first (so we get variety)
                let uncollected = scored.filter { !collectedTypesThisTurn.contains($0.0) }
                let candidate = (uncollected.isEmpty ? scored : uncollected).max { $0.1 < $1.1 }?.0
                tokenToCollect = candidate
            }
            
            // Final check: validate with canCollectToken and fallback to any legal token
            if let finalType = tokenToCollect,
               canCollectToken(tokenType: finalType, supply: tokenSupply, player: player, tokensCollectedThisTurn: tokensCollectedThisTurn, collectedTypes: collectedTypesThisTurn) {
                return .collectToken(finalType)
            }
            
            // fallback: any legal token
            if let legalRandom = availableTypes.first(where: {
                canCollectToken(tokenType: $0, supply: tokenSupply, player: player, tokensCollectedThisTurn: tokensCollectedThisTurn, collectedTypes: collectedTypesThisTurn)
            }) {
                return .collectToken(legalRandom)
            }
        }
        
        // Default: end turn
        return .endTurn
    }
    
    
    // MARK: - Scoring & helper functions
    
    /// Weighted score: combine points, efficiency, synergy, and noble proximity
    private static func scoreCard(player: Player, card: Card, visibleCards: [Card]) -> Double {
        let points = Double(card.points)
        
        // Effective tokens required after bonuses
        var tokensRequired = 0
        for type in TokenType.allCases where type != .perfect {
            let bonus = player.bonusCount(of: type)
            let need = card.cost[type] ?? 0
            tokensRequired += max(0, need - bonus)
        }
        
        let efficiency = tokensRequired > 0 ? points / Double(tokensRequired) : points
        
        // Synergy: does this card's bonus help with top targets (visible + reserved)
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
        
        let noble = nobleClaimProximity(for: player, card: card)
        
        // Weighted aggregate: favor points and efficiency, then synergy, then noble proximity
        return points * 2.0 + efficiency * 1.5 + bonusSynergyScore * 1.0 + noble * 0.5
    }
    
    /// Score how valuable a token type is based on cards it helps unlock
    private static func scoreTokenType(
        _ type: TokenType,
        player: Player,
        visibleCards: [Card],
        tokenSupply: TokenSupply
    ) -> Double {
        var score: Double = 0
        
        let cardsNeeding = visibleCards.filter { ($0.cost[type] ?? 0) > 0 }
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
        
        // Scarcity heuristic: tokens with small remaining supply are more valuable to secure early
        let remaining = tokenSupply.count(of: type)
        if remaining <= 4 {
            score *= 1.25
        }
        
        return score
    }
    
    /// Estimate how much the card helps toward noble (simplified heuristic)
    private static func nobleClaimProximity(for player: Player, card: Card) -> Double {
        // simplified: value bonus types that match player's current needs
        let bonus = card.bonus
        guard bonus != .perfect else { return 0.0 }
        // Count how many visible cards need this bonus
        // (Using visibleCards would be better but we keep this lightweight)
        // We'll approximate by checking player's reserved and visible top targets
        let topTargets = (player.reservedCards).sorted { $0.points > $1.points }.prefix(3)
        let isUseful = topTargets.contains { ($0.cost[bonus] ?? 0) > 0 }
        return isUseful ? 0.6 : 0.0
    }
    
    // MARK: - Existing helper logic (unmodified semantics)
    
    private static func canAffordCard(player: Player, card: Card) -> Bool {
        var remainingNeeded = card.cost
        
        // Apply permanent bonuses
        for type in TokenType.allCases where type != .perfect {
            let bonus = player.bonusCount(of: type)
            let needed = remainingNeeded[type] ?? 0
            remainingNeeded[type] = max(0, needed - bonus)
        }
        
        // Calculate Perfect (Wildcard) tokens needed
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
        
        // Account for permanent bonuses
        for type in TokenType.allCases where type != .perfect {
            let bonus = player.bonusCount(of: type)
            let needed = remainingNeeded[type] ?? 0
            remainingNeeded[type] = max(0, needed - bonus)
        }
        
        // Compute shortfall after bonuses and tokens
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
        
        switch tokensCollectedThisTurn {
        case 0:
            return true
        case 1:
            // If already collected that same type, require supply >= 4 to take a second
            if collectedTypes.contains(tokenType) {
                return supply.count(of: tokenType) >= 4
            } else {
                return true
            }
        case 2:
            return isNewType && collectedTypes.count == 2
        default:
            return false
        }
    }
}

enum AIAction {
    case collectToken(TokenType)
    case buyCard(Card)
    case reserveCard(Card)
    case endTurn
}
