import Foundation

enum TurnAction {
    case none
    case collectingTokens
    case boughtCard
    case reservedCard
}

struct GameRules {
    static let maxTokensPerPlayer = 10
    
    // Check if can collect a token
    static func canCollectToken(
        tokenType: TokenType,
        supply: TokenSupply,
        player: Player,
        tokensCollectedThisTurn: Int,
        turnAction: TurnAction,
        collectedTypes: Set<TokenType>
    ) -> (canCollect: Bool, reason: String) {
        
        // Gold tokens can only be taken when reserving
        if tokenType == .perfect {
            return (false, "Gold tokens only from reserving cards")
        }
        
        // Can't collect if already bought or reserved
        if turnAction == .boughtCard {
            return (false, "Already bought a card this turn")
        }
        if turnAction == .reservedCard {
            return (false, "Already reserved a card this turn")
        }
        
        // Check token limit
        if player.totalTokenCount >= maxTokensPerPlayer {
            return (false, "Can't exceed 10 tokens")
        }
        
        // No tokens available
        if supply.count(of: tokenType) == 0 {
            return (false, "No \(tokenType.rawValue) available")
        }
        
        // First token - can always take
        if tokensCollectedThisTurn == 0 {
            return (true, "")
        }
        
        // Second token
        if tokensCollectedThisTurn == 1 {
            let firstType = collectedTypes.first!
            
            // Same type - need 4+ in supply originally
            if tokenType == firstType {
                // Check if there were 4+ before we took the first one
                let currentCount = supply.count(of: tokenType)
                if currentCount + 1 >= 4 {  // +1 because we already took one
                    return (true, "")
                } else {
                    return (false, "Need 4+ tokens to take 2 of same type")
                }
            }
            
            // Different type - can take as 2nd of 3 different
            return (true, "")
        }
        
        // Third token
        if tokensCollectedThisTurn == 2 {
            // If we took 2 of same type, can't take a 3rd
            if collectedTypes.count == 1 {
                return (false, "Already took 2 of same type")
            }
            
            // If taking 3 different, must be a new type
            if collectedTypes.contains(tokenType) {
                return (false, "Already took this type - must be 3 different")
            }
            
            return (true, "")
        }
        
        // Already took 3
        return (false, "Already collected tokens this turn")
    }
    
    // Check if can end turn
    static func canEndTurn(player: Player) -> (canEnd: Bool, reason: String) {
        if player.totalTokenCount > maxTokensPerPlayer {
            return (false, "Must have 10 or fewer tokens")
        }
        return (true, "")
    }
    
    /// Check if player can afford a card
    /// Gold tokens count as wildcards for ANY color
    static func canAffordCard(player: Player, card: Card) -> Bool {
        // Calculate what we need to spend
        var remainingCost = card.cost  // Copy of cost dictionary
        
        // Step 1: Apply permanent bonuses first
        for (tokenType, requiredCount) in card.cost {
            let bonusCount = player.bonusCount(of: tokenType)
            let amountCovered = min(bonusCount, requiredCount)
            remainingCost[tokenType] = (remainingCost[tokenType] ?? 0) - amountCovered
        }
        
        // Step 2: Spend colored tokens (not gold) for what we still need
        for (tokenType, neededCount) in remainingCost {
            if tokenType == .perfect {
                continue  // Skip gold for now
            }
            
            if neededCount > 0 {
                let availableColored = player.tokenCount(of: tokenType)
                let amountToSpend = min(availableColored, neededCount)
                remainingCost[tokenType] = neededCount - amountToSpend
            }
        }
        
        // Step 3: Check if remaining cost can be covered by gold tokens
        let totalStillNeeded = remainingCost.filter { $0.key != .perfect }.values.reduce(0, +)
        let goldAvailable = player.tokenCount(of: .perfect)
        
        if goldAvailable >= totalStillNeeded {
            return true  // Gold tokens can cover the rest
        }
        
        return false
    }
    
    // Check if can buy a card this turn
    static func canBuyCard(turnAction: TurnAction) -> (canBuy: Bool, reason: String) {
        if turnAction == .collectingTokens {
            return (false, "Already collected tokens this turn")
        }
        if turnAction == .boughtCard {
            return (false, "Already bought a card this turn")
        }
        if turnAction == .reservedCard {
            return (false, "Already reserved a card this turn")
        }
        return (true, "")
    }
}
