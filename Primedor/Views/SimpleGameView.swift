import SwiftUI

struct SimpleGameView: View {
    let playerCount: Int
    @State private var tokenSupply: TokenSupply
    @State private var players: [Player]
    @State private var currentPlayerIndex = 0
    @State private var updateTrigger = 0
    @State private var visibleCardsTier1: [Card]
    @State private var visibleCardsTier2: [Card]
    @State private var visibleCardsTier3: [Card]
    @State private var deckTier1: [Card]
    @State private var deckTier2: [Card]
    @State private var deckTier3: [Card]
    @State private var availableNobles: [Mathematician]
    @State private var tokensCollectedThisTurn = 0
    @State private var collectedTypesCount: [TokenType: Int] = [:]
    @State private var turnAction: TurnAction = .none
    @State private var errorMessage = ""
    @State private var showWinner = false
    @State private var winner: Player?
    @State private var isAIThinking = false
    
    init(playerCount: Int) {
        self.playerCount = playerCount
        self._tokenSupply = State(initialValue: TokenSupply(playerCount: playerCount))
        
        var playerArray: [Player] = []
        for i in 1...playerCount {
            if i == 1 {
                playerArray.append(Player(name: "P1", isAI: false))
            } else {
                playerArray.append(Player(name: "AI\(i)", isAI: true))
            }
        }
        self._players = State(initialValue: playerArray)
        
        let allCards = RealCardDatabase.allCards().shuffled()
        let tier1 = allCards.filter { $0.tier == .one }
        let tier2 = allCards.filter { $0.tier == .two }
        let tier3 = allCards.filter { $0.tier == .three }
        
        self._visibleCardsTier1 = State(initialValue: Array(tier1.prefix(4)))
        self._visibleCardsTier2 = State(initialValue: Array(tier2.prefix(4)))
        self._visibleCardsTier3 = State(initialValue: Array(tier3.prefix(4)))
        
        self._deckTier1 = State(initialValue: Array(tier1.dropFirst(4)))
        self._deckTier2 = State(initialValue: Array(tier2.dropFirst(4)))
        self._deckTier3 = State(initialValue: Array(tier3.dropFirst(4)))
        
        let allNobles = Mathematician.allMathematicians.shuffled()
        self._availableNobles = State(initialValue: Array(allNobles.prefix(playerCount + 1)))
    }
    
    var currentPlayer: Player {
        players[currentPlayerIndex]
    }

    func calculateTotalTokens(for player: Player) -> Int {
            // The dictionary values are arrays of Token structs ([Token]),
            // so we need to sum the count of each array.
            return player.tokens.values.reduce(0) { total, tokensArray in
                total + tokensArray.count
            }
        }

    var body: some View {
        ZStack {
            VStack(spacing: 6) {
                // Header
                HStack {
                    Text(currentPlayer.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .cornerRadius(8)
                    
                    Text("T:\(tokensCollectedThisTurn)")
                        .font(.caption)
                    
                    Spacer()
                    
                    Button("End Turn") {
                        endTurn()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
                .padding(.horizontal)
                
                // Turn tokens (tap to return/discard)
                TurnTokensView(
                    collectedTypes: collectedTypesCount,
                    onReturn: { type in
                        returnToken(type) // Changed to use the comprehensive returnToken/discard function
                    }
                )
                
                // Error message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.system(size: 10))
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                // Nobles
                if !availableNobles.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nobles")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                ForEach(availableNobles) { noble in
                                    NobleView(
                                        mathematician: noble,
                                        canClaim: canClaimNoble(noble)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 4)
                    .background(Color.purple.opacity(0.05))
                }
                
                ScrollView {
                    VStack(spacing: 8) {
                        // Card grid - 3 rows
                        cardGridSection
                        
                        // Token supply
                        tokenSupplySection
                        
                        // Players
                        playersSection
                    }
                }
            }
            .id(updateTrigger)
            
            // Winner overlay
            if showWinner, let winner = winner {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                WinnerView(winner: winner, allPlayers: players) {
                    // Reset - go back to setup (dismiss this view)
                }
            }
        }
    }
    
    var cardGridSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Cards")
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            // Tier 3 row
            HStack(spacing: 4) {
                // Deck pile with reserve button
                Button {
                    reserveFromDeck(tier: .three)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.purple.opacity(0.2))
                            .frame(width: 40, height: 56)
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.purple, lineWidth: 2)
                            .frame(width: 40, height: 56)
                        VStack(spacing: 2) {
                            Text("\(deckTier3.count)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.purple)
                            Text("Res")
                                .font(.system(size: 8))
                                .foregroundColor(.purple)
                        }
                    }
                }
                .disabled(deckTier3.isEmpty)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(visibleCardsTier3) { card in
                            CompactCardView(
                                card: card,
                                canAfford: GameRules.canAffordCard(player: currentPlayer, card: card),
                                onBuy: { buyCard(card) },
                                onReserve: { reserveCard(card) }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            
            // Tier 2 row
            HStack(spacing: 4) {
                // Deck pile with reserve button
                Button {
                    reserveFromDeck(tier: .two)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 40, height: 56)
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width: 40, height: 56)
                        VStack(spacing: 2) {
                            Text("\(deckTier2.count)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.blue)
                            Text("Res")
                                .font(.system(size: 8))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .disabled(deckTier2.isEmpty)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(visibleCardsTier2) { card in
                            CompactCardView(
                                card: card,
                                canAfford: GameRules.canAffordCard(player: currentPlayer, card: card),
                                onBuy: { buyCard(card) },
                                onReserve: { reserveCard(card) }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            
            // Tier 1 row
            HStack(spacing: 4) {
                // Deck pile with reserve button
                Button {
                    reserveFromDeck(tier: .one)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 40, height: 56)
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.green, lineWidth: 2)
                            .frame(width: 40, height: 56)
                        VStack(spacing: 2) {
                            Text("\(deckTier1.count)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.green)
                            Text("Res")
                                .font(.system(size: 8))
                                .foregroundColor(.green)
                        }
                    }
                }
                .disabled(deckTier1.isEmpty)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(visibleCardsTier1) { card in
                            CompactCardView(
                                card: card,
                                canAfford: GameRules.canAffordCard(player: currentPlayer, card: card),
                                onBuy: { buyCard(card) },
                                onReserve: { reserveCard(card) }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.05))
    }

    // Add this new function after reserveCard function
    func reserveFromDeck(tier: CardTier) {
        if turnAction != .none {
            errorMessage = "Already took action this turn"
            return
        }
        
        if currentPlayer.reservedCards.count >= 3 {
            errorMessage = "Can only reserve 3 cards"
            return
        }
        
        // Get card from appropriate deck
        var card: Card?
        if tier == .three && !deckTier3.isEmpty {
            card = deckTier3.removeFirst()
        } else if tier == .two && !deckTier2.isEmpty {
            card = deckTier2.removeFirst()
        } else if tier == .one && !deckTier1.isEmpty {
            card = deckTier1.removeFirst()
        }
        
        guard let cardToReserve = card else {
            errorMessage = "No cards left in that deck"
            return
        }
        
        // Reserve the card
        currentPlayer.reserveCard(cardToReserve)
        
        // Take a gold token if available
        if let goldToken = tokenSupply.take(.perfect, count: 1) {
            currentPlayer.addTokens(goldToken)

            if calculateTotalTokens(for: currentPlayer) > 10 {
                errorMessage = "You took a gold token and are now over 10. You must discard tokens."
                updateTrigger += 1
                return  // Don't auto-end if they need to discard
            }
        }
        
        turnAction = .reservedCard
        errorMessage = ""
        updateTrigger += 1
        
        // Auto-end turn after reserving
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            endTurn()
        }
    }
    
    var tokenSupplySection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Supply")
                .font(.caption)
                .fontWeight(.bold)
            
            HStack(spacing: 8) {
                ForEach(TokenType.allCases, id: \.self) { type in
                    Button {
                        collectToken(type)
                    } label: {
                        VStack(spacing: 2) {
                            Circle()
                                .fill(colorFor(type))
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Text("\(tokenSupply.count(of: type))")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                )
                        }
                    }
                }
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
    
    var playersSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Players")
                .font(.caption)
                .fontWeight(.bold)
            
            ForEach(players) { player in
                CompactPlayerView(
                    player: player,
                    isCurrent: player.id == currentPlayer.id,
                    onBuyReserved: { card in
                        if player.id == currentPlayer.id {
                            buyReservedCard(card)
                        }
                    }
                )
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
    
    func canClaimNoble(_ noble: Mathematician) -> Bool {
        for (tokenType, requiredCount) in noble.requirements {
            let bonusCount = currentPlayer.bonusCount(of: tokenType)
            if bonusCount < requiredCount {
                return false
            }
        }
        return true
    }
    
    func claimNobleIfPossible() {
        for noble in availableNobles {
            if canClaimNoble(noble) {
                currentPlayer.claimMathematician(noble)
                availableNobles.removeAll { $0.id == noble.id }
                break // Only claim one noble per turn
            }
        }
    }
    
    func collectToken(_ type: TokenType) {
        let collectedTypesSet = Set(collectedTypesCount.keys)
        let check = GameRules.canCollectToken(
            tokenType: type,
            supply: tokenSupply,
            player: currentPlayer,
            tokensCollectedThisTurn: tokensCollectedThisTurn,
            turnAction: turnAction,
            collectedTypes: collectedTypesSet
        )
        
        if !check.canCollect {
            errorMessage = check.reason
            return
        }
        
        if let tokens = tokenSupply.take(type, count: 1) {
            currentPlayer.addTokens(tokens)
            tokensCollectedThisTurn += 1
            collectedTypesCount[type, default: 0] += 1
            turnAction = .collectingTokens
            errorMessage = ""
            updateTrigger += 1
            
            // FIX for Error 1: Use helper function
            if calculateTotalTokens(for: currentPlayer) > 10 {
                errorMessage = "You have over 10 tokens. Tap one of your tokens to discard it."
            }
        }
    }

    // Combined function for returning collected tokens and discarding for 10-token limit
    func returnToken(_ type: TokenType) {
        let isCollectedThisTurn = (collectedTypesCount[type] ?? 0) > 0

        if turnAction == .collectingTokens && isCollectedThisTurn {
            // Case 1: Undo a token collection (returns to supply, reduces collected count)
            let returned = currentPlayer.removeTokens(type, count: 1)
            tokenSupply.returnTokens(returned)
            
            tokensCollectedThisTurn -= 1
            collectedTypesCount[type]! -= 1
            if collectedTypesCount[type]! == 0 {
                collectedTypesCount.removeValue(forKey: type)
            }
            
            if tokensCollectedThisTurn == 0 {
                turnAction = .none
            }
            errorMessage = ""
        } else if calculateTotalTokens(for: currentPlayer) > 10 {
            // Case 2: Discarding a token due to 10-token limit (can be any token)
            if currentPlayer.tokenCount(of: type) > 0 {
                let returned = currentPlayer.removeTokens(type, count: 1)
                tokenSupply.returnTokens(returned)
                
                errorMessage = calculateTotalTokens(for: currentPlayer) > 10
                    ? "Still over 10 tokens. Discard another."
                    : "" // Clears error message when limit is met
            } else {
                errorMessage = "You don't have a token of that type to discard."
            }
        } else {
            // Case 3: Invalid action
            errorMessage = "Cannot return that token at this time."
        }

        updateTrigger += 1
    }
    
    // Core payment logic with wildcard (perfect) tokens
    func payForCard(_ card: Card) {
        var costToPay = card.cost
        var goldTokensToSpend = 0
        var tokensToReturn: [TokenType: Int] = [:]

        // 1. Calculate net cost after applying bonuses
        for (type, cost) in costToPay {
            let bonus = currentPlayer.bonusCount(of: type)
            costToPay[type] = max(0, cost - bonus)
        }

        // 2. Use specific tokens first, note the shortfall
        for (type, required) in costToPay where required > 0 {
            let playerHas = currentPlayer.tokenCount(of: type)
            let spendSpecific = min(required, playerHas)
            let shortfall = required - spendSpecific

            if spendSpecific > 0 {
                tokensToReturn[type, default: 0] += spendSpecific
            }

            // 3. Use gold tokens to cover the remaining shortfall
            if shortfall > 0 {
                let goldAvailable = currentPlayer.tokenCount(of: .perfect) - goldTokensToSpend
                let useGold = min(shortfall, goldAvailable)
                
                goldTokensToSpend += useGold
            }
        }
        
        // 4. Execute the token removal/return
        if goldTokensToSpend > 0 {
            let spentGold = currentPlayer.removeTokens(.perfect, count: goldTokensToSpend)
            tokenSupply.returnTokens(spentGold)
        }

        for (type, count) in tokensToReturn {
            if count > 0 {
                let spent = currentPlayer.removeTokens(type, count: count)
                tokenSupply.returnTokens(spent)
            }
        }
    }

    func buyCard(_ card: Card) {
        let check = GameRules.canBuyCard(turnAction: turnAction)
        if !check.canBuy {
            errorMessage = check.reason
            return
        }
        
        if !GameRules.canAffordCard(player: currentPlayer, card: card) {
            errorMessage = "Can't afford this card"
            return
        }
        
        payForCard(card)
        
        currentPlayer.purchaseCard(card)
        removeAndReplaceCard(card)
        
        // Check for nobles
        claimNobleIfPossible()
        
        turnAction = .boughtCard
        errorMessage = ""
        updateTrigger += 1
        
        // Auto-end turn after buying
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            endTurn()
        }
    }
    
    func buyReservedCard(_ card: Card) {
        let check = GameRules.canBuyCard(turnAction: turnAction)
        if !check.canBuy {
            errorMessage = check.reason
            return
        }
        
        if !GameRules.canAffordCard(player: currentPlayer, card: card) {
            errorMessage = "Can't afford this card"
            return
        }
        
        payForCard(card)
        
        // Purchase and remove from reserved
        currentPlayer.purchaseCard(card)
        currentPlayer.removeReservedCard(card)
        
        // Check for nobles
        claimNobleIfPossible()
        
        turnAction = .boughtCard
        errorMessage = ""
        updateTrigger += 1
        
        // Auto-end turn after buying
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            endTurn()
        }
    }
    
    func reserveCard(_ card: Card) {
        if turnAction != .none {
            errorMessage = "Already took action this turn"
            return
        }
        
        if currentPlayer.reservedCards.count >= 3 {
            errorMessage = "Can only reserve 3 cards"
            return
        }
        
        // Reserve the card
        currentPlayer.reserveCard(card)
        
        // Take a gold token if available
        if let goldToken = tokenSupply.take(.perfect, count: 1) {
            currentPlayer.addTokens(goldToken)

            if calculateTotalTokens(for: currentPlayer) > 10 {
                errorMessage = "You took a gold token and are now over 10. You must discard tokens."
                updateTrigger += 1
                return  // Don't auto-end if they need to discard
            }
        }
        
        removeAndReplaceCard(card)
        
        turnAction = .reservedCard
        errorMessage = ""
        updateTrigger += 1
        
        // Auto-end turn after reserving
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            endTurn()
        }
    }
    
    func removeAndReplaceCard(_ card: Card) {
        if card.tier == .one {
            visibleCardsTier1.removeAll { $0.id == card.id }
            if !deckTier1.isEmpty {
                visibleCardsTier1.append(deckTier1.removeFirst())
            }
        } else if card.tier == .two {
            visibleCardsTier2.removeAll { $0.id == card.id }
            if !deckTier2.isEmpty {
                visibleCardsTier2.append(deckTier2.removeFirst())
            }
        } else {
            visibleCardsTier3.removeAll { $0.id == card.id }
            if !deckTier3.isEmpty {
                visibleCardsTier3.append(deckTier3.removeFirst())
            }
        }
    }
    
    func endTurn() {
        let check = GameRules.canEndTurn(player: currentPlayer)
        
        // FIX for Error 1: Use helper function
        if calculateTotalTokens(for: currentPlayer) > 10 {
             errorMessage = "You must discard tokens down to 10 before ending your turn."
             return
        }
        
        if !check.canEnd {
            errorMessage = check.reason
            return
        }
        
        // Check for winner (after last player's turn)
        if let gameWinner = WinCondition.checkWinner(players: players, currentPlayerIndex: currentPlayerIndex) {
            showWinner = true
            winner = gameWinner
            return
        }
        
        currentPlayerIndex = (currentPlayerIndex + 1) % playerCount
        tokensCollectedThisTurn = 0
        collectedTypesCount = [:]
        turnAction = .none
        errorMessage = ""
        updateTrigger += 1
        
        // Execute AI turn if next player is AI
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.executeAITurn()
        }
    }
    
    func executeAITurn() {
        guard currentPlayer.isAI else { return }
        
        isAIThinking = true
        
        // Get all visible cards for the AI to consider
        let allVisibleCards = visibleCardsTier1 + visibleCardsTier2 + visibleCardsTier3
        
        // Get the AI's move
        let collectedTypesSet = Set(collectedTypesCount.keys)
        let aiAction = AIPlayer.makeMove(
            player: currentPlayer,
            tokenSupply: tokenSupply,
            visibleCards: allVisibleCards,
            turnAction: turnAction,
            collectedTypesThisTurn: collectedTypesSet,
            tokensCollectedThisTurn: tokensCollectedThisTurn
        )
        
        // Execute the AI's action with a small delay for UI feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            switch aiAction {
            case .collectToken(let type):
                self.collectToken(type)
                
                // FIX for Error 1: Use helper function
                if self.calculateTotalTokens(for: self.currentPlayer) > 10 {
                    self.performAIDiscard()
                }
                
                // After collecting a token, check if AI should continue
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.executeAITurn()
                }
                
            case .buyCard(let card):
                self.buyCard(card)
                // After buying, end turn
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.endTurn()
                }
                
            case .reserveCard(let card):
                self.reserveCard(card)

                // FIX for Error 1: Use helper function
                if self.calculateTotalTokens(for: self.currentPlayer) > 10 {
                    self.performAIDiscard()
                }
                
                // After reserving, end turn
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.endTurn()
                }
                
            case .endTurn:
                self.endTurn()
            }
            
            self.isAIThinking = false
        }
    }
    
    func performAIDiscard() {
            // Use the corrected helper function to check the total count
            while calculateTotalTokens(for: currentPlayer) > 10 {
                
                // FIX: Change filter condition to check the count of the [Token] array
                // Filter now checks if the array of tokens has a count greater than 0.
                let removableTokens = currentPlayer.tokens.filter { $0.value.count > 0 }
                
                guard let typeToDiscard = removableTokens
                    // Simple AI strategy: discard the most numerous token first.
                    // Sort by the count of the tokens array ($0.value.count)
                    .sorted(by: { $0.value.count > $1.value.count })
                    .first?
                    .key else {
                        break
                }
                
                // This logic is already correct, assuming removeTokens returns [Token]
                let returned = currentPlayer.removeTokens(typeToDiscard, count: 1)
                tokenSupply.returnTokens(returned)
                updateTrigger += 1
            }
        }
    
    func colorFor(_ type: TokenType) -> Color {
        switch type {
        case .prime: return .red
        case .even: return .blue
        case .odd: return .green
        case .square: return .black
        case .sequence: return .gray
        case .perfect: return .yellow
        }
    }
}
