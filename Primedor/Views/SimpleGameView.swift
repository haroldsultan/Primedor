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
        // First player is human
        playerArray.append(Player(name: "You", isAI: false))
        // Rest are AI
        for i in 2...playerCount {
            playerArray.append(Player(name: "AI\(i)", isAI: true))
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
        
        // Select nobles (playerCount + 1)
        let allNobles = Mathematician.allMathematicians.shuffled()
        self._availableNobles = State(initialValue: Array(allNobles.prefix(playerCount + 1)))
    }
    
    var currentPlayer: Player {
        players[currentPlayerIndex]
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
                
                // Turn tokens (tap to return)
                TurnTokensView(
                    collectedTypes: collectedTypesCount,
                    onReturn: { type in
                        returnTokenThisTurn(type)
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
                Text("T3:\(deckTier3.count)")
                    .font(.system(size: 10))
                    .foregroundColor(.purple)
                    .frame(width: 35)
                
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
                Text("T2:\(deckTier2.count)")
                    .font(.system(size: 10))
                    .foregroundColor(.blue)
                    .frame(width: 35)
                
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
                Text("T1:\(deckTier1.count)")
                    .font(.system(size: 10))
                    .foregroundColor(.green)
                    .frame(width: 35)
                
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
                            Text("\(tokenSupply.count(of: type))")
                                .font(.caption2)
                                .foregroundColor(.primary)
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
        }
    }
    
    func returnTokenThisTurn(_ type: TokenType) {
        guard let count = collectedTypesCount[type], count > 0 else { return }
        
        // Return token to supply
        let returned = currentPlayer.removeTokens(type, count: 1)
        tokenSupply.returnTokens(returned)
        
        // Update tracking
        tokensCollectedThisTurn -= 1
        collectedTypesCount[type]! -= 1
        if collectedTypesCount[type]! == 0 {
            collectedTypesCount.removeValue(forKey: type)
        }
        
        // If no tokens left, reset turn action
        if tokensCollectedThisTurn == 0 {
            turnAction = .none
        }
        
        errorMessage = ""
        updateTrigger += 1
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
        
        // Pay the cost
        for (tokenType, requiredCount) in card.cost {
            let bonusCount = currentPlayer.bonusCount(of: tokenType)
            let tokensToSpend = max(0, requiredCount - bonusCount)
            if tokensToSpend > 0 {
                let spent = currentPlayer.removeTokens(tokenType, count: tokensToSpend)
                tokenSupply.returnTokens(spent)
            }
        }
        
        currentPlayer.purchaseCard(card)
        removeAndReplaceCard(card)
        
        // Check for nobles
        claimNobleIfPossible()
        
        turnAction = .boughtCard
        errorMessage = ""
        updateTrigger += 1
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
        
        // Pay the cost
        for (tokenType, requiredCount) in card.cost {
            let bonusCount = currentPlayer.bonusCount(of: tokenType)
            let tokensToSpend = max(0, requiredCount - bonusCount)
            if tokensToSpend > 0 {
                let spent = currentPlayer.removeTokens(tokenType, count: tokensToSpend)
                tokenSupply.returnTokens(spent)
            }
        }
        
        // Purchase and remove from reserved
        currentPlayer.purchaseCard(card)
        currentPlayer.removeReservedCard(card)
        
        // Check for nobles
        claimNobleIfPossible()
        
        turnAction = .boughtCard
        errorMessage = ""
        updateTrigger += 1
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
        }
        
        removeAndReplaceCard(card)
        
        turnAction = .reservedCard
        errorMessage = ""
        updateTrigger += 1
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
                // After collecting a token, check if AI should continue
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.executeAITurn()
                }
                
            case .buyCard(let card):
                self.buyCard(card)
                // After buying, check if AI should continue
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.executeAITurn()
                }
                
            case .reserveCard(let card):
                self.reserveCard(card)
                // After reserving, end turn (can only do one action)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.endTurn()
                }
                
            case .endTurn:
                self.endTurn()
            }
            
            self.isAIThinking = false
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
