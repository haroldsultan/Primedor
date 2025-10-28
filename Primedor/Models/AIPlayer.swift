import Foundation

struct AIPlayer {

    /// Make a move for the AI
    /// Strategy priority:
    /// 1. Buy affordable cards (highest points)
    /// 2. Buy reserved cards if now affordable
    /// 3. Reserve a valuable card if allowed and near-affordable
    /// 4. Collect tokens strategically toward good targets
    /// 5. End turn if nothing useful
    static func makeMove(
        player: Player,
        tokenSupply: TokenSupply,
        visibleCards: [Card],
        turnAction: TurnAction,
        collectedTypesThisTurn: Set<TokenType>,
        tokensCollectedThisTurn: Int
    ) -> AIAction {

        // --- Priority 1: Buy a visible card if possible ---
        if turnAction == .none {
            let affordableCards = visibleCards.filter { canAffordCard(player: player, card: $0) }
            if let bestCard = affordableCards.max(by: { $0.points < $1.points }) {
                return .buyCard(bestCard)
            }
        }

        // --- Priority 1.2: Buy one of our reserved cards if we can afford it ---
        if turnAction == .none {
            if let affordableReserved = player.reservedCards.first(where: { canAffordCard(player: player, card: $0) }) {
                return .buyCard(affordableReserved)
            }
        }

        // --- Priority 1.5: Reserve a valuable near-affordable card ---
        if turnAction == .none {
            // Don’t exceed reserve limit (Splendor rule = 3)
            let reserveLimit = 3
            guard player.reservedCards.count < reserveLimit else { return .endTurn }

            let ranked = visibleCards.sorted(by: { $0.points > $1.points })
            for card in ranked.prefix(5) {
                // Only consider cards we cannot currently afford
                guard !canAffordCard(player: player, card: card) else { continue }

                let short = tokensNeededForCard(player: player, card: card)
                let totalShort = Double(short.values.reduce(0, +))

                // Reserve if: close to afford + worth points or synergy
                if totalShort <= 4.0 && Double(card.points) + bonusSynergy(for: player, card: card) > 0 {
                    return .reserveCard(card)
                }
            }
        }

        // --- Priority 2: Collect tokens strategically ---
        if turnAction == .none || turnAction == .collectingTokens {
            let availableTypes = TokenType.allCases.filter {
                tokenSupply.count(of: $0) > 0 && $0 != .perfect
            }

            if !availableTypes.isEmpty {
                var tokenToCollect: TokenType?

                // Evaluate shortfalls for top few target cards
                let targetCards = visibleCards.sorted(by: { $0.points > $1.points })
                var cumulativeShortfall: [TokenType: Int] = [:]
                for card in targetCards.prefix(3) {
                    let short = tokensNeededForCard(player: player, card: card)
                    for (type, amount) in short {
                        cumulativeShortfall[type, default: 0] += amount
                    }
                }

                // Prefer the most needed, available, uncollected type
                let prioritized = cumulativeShortfall
                    .filter { type, _ in availableTypes.contains(type) && !collectedTypesThisTurn.contains(type) }
                    .sorted(by: { $0.value > $1.value })

                tokenToCollect = prioritized.first?.key

                // Fallback to any available uncollected type
                if tokenToCollect == nil {
                    tokenToCollect = availableTypes.filter { !collectedTypesThisTurn.contains($0) }.randomElement()
                }
                if tokenToCollect == nil {
                    tokenToCollect = availableTypes.randomElement()
                }

                if let finalToken = tokenToCollect,
                   canCollectToken(
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

        // --- Default: End turn ---
        return .endTurn
    }

    // MARK: - Helper Functions

    /// Determine if the player can afford a specific card
    private static func canAffordCard(player: Player, card: Card) -> Bool {
        var remainingNeeded = card.cost

        // Apply permanent bonuses
        for type in TokenType.allCases where type != .perfect {
            let bonus = player.bonusCount(of: type)
            let needed = remainingNeeded[type] ?? 0
            remainingNeeded[type] = max(0, needed - bonus)
        }

        var perfectTokensNeeded = 0

        // Determine token shortfall after bonuses
        for type in TokenType.allCases where type != .perfect {
            let needed = remainingNeeded[type] ?? 0
            let available = player.tokenCount(of: type)
            if available < needed {
                perfectTokensNeeded += (needed - available)
            }
        }

        return player.tokenCount(of: .perfect) >= perfectTokensNeeded
    }

    /// Compute how many tokens of each type are still needed to buy a card
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
            if available < needed {
                shortfall[type] = needed - available
            }
        }

        return shortfall
    }

    /// Determine if collecting a token is a legal and valid move
    private static func canCollectToken(
        tokenType: TokenType,
        supply: TokenSupply,
        player: Player,
        tokensCollectedThisTurn: Int,
        collectedTypes: Set<TokenType>
    ) -> Bool {

        guard tokenType != .perfect else { return false }
        guard supply.count(of: tokenType) > 0 else { return false }

        if tokensCollectedThisTurn >= 3 { return false }
        if player.totalTokenCount >= 10 { return false }

        let supplyCount = supply.count(of: tokenType)
        let isNewType = !collectedTypes.contains(tokenType)
        let uniqueCollected = collectedTypes.count

        switch tokensCollectedThisTurn {
        case 0:
            return true
        case 1:
            if isNewType { return true }
            return supplyCount >= 4
        case 2:
            if isNewType && uniqueCollected == 2 { return true }
            return false
        default:
            return false
        }
    }

    /// Small heuristic: rewards cards that build on existing bonuses
    private static func bonusSynergy(for player: Player, card: Card) -> Double {
        // Slight preference if this card matches a color we already have bonuses in
        let matchingBonus = Double(player.bonusCount(of: card.bonus))
        // Extra reward for higher-value cards
        return matchingBonus * 0.3 + Double(card.points) * 0.2
    }
}

// MARK: - AI Action Types

enum AIAction {
    case collectToken(TokenType)
    case buyCard(Card)
    case reserveCard(Card)
    case endTurn
}
