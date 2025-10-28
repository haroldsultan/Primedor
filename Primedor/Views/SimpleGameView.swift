import SwiftUI

struct SimpleGameView: View {
    @Environment(\.dismiss) var dismiss
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
    @State private var showNewGameConfirm = false
    @State private var selectedCard: Card?
    @State private var selectedPlayer: Player?
    @State private var selectedNoble: Mathematician?
    @State private var showReserveWarning = false
    @State private var cardToReserve: Card?
    @State private var reserveWarningMessage = ""
    
    /// New initializer that accepts pre-configured players
    init(players: [Player]) {
        let validPlayers = players.isEmpty ? [Player(name: "Player 1", isAI: false)] : players
        self.playerCount = validPlayers.count
        
        self._players = State(initialValue: validPlayers)
        self._tokenSupply = State(initialValue: TokenSupply(playerCount: validPlayers.count))
        
        // Initialize cards safely
        let cardInitialization = Self.initializeCards()
        self._visibleCardsTier1 = State(initialValue: cardInitialization.visibleTier1)
        self._visibleCardsTier2 = State(initialValue: cardInitialization.visibleTier2)
        self._visibleCardsTier3 = State(initialValue: cardInitialization.visibleTier3)
        self._deckTier1 = State(initialValue: cardInitialization.deckTier1)
        self._deckTier2 = State(initialValue: cardInitialization.deckTier2)
        self._deckTier3 = State(initialValue: cardInitialization.deckTier3)
        
        // Initialize nobles safely
        let allNobles = Mathematician.allMathematicians.shuffled()
        let nobleCount = min(validPlayers.count + 1, allNobles.count)
        self._availableNobles = State(initialValue: Array(allNobles.prefix(nobleCount)))
    }
    
    /// Legacy initializer for backward compatibility (2-4 players with P1 human, rest AI)
    init(playerCount: Int) {
        let validPlayerCount = max(2, min(playerCount, 4))
        
        var playerArray: [Player] = []
        for i in 1...validPlayerCount {
            if i == 1 {
                playerArray.append(Player(name: "P1", isAI: false))
            } else {
                playerArray.append(Player(name: "AI\(i)", isAI: true))
            }
        }
        
        self.init(players: playerArray)
    }
    
    // Extract card initialization to separate function for safety
    private static func initializeCards() -> (
        visibleTier1: [Card],
        visibleTier2: [Card],
        visibleTier3: [Card],
        deckTier1: [Card],
        deckTier2: [Card],
        deckTier3: [Card]
    ) {
        let allCards = RealCardDatabase.allCards().shuffled()
        let tier1 = allCards.filter { $0.tier == .one }
        let tier2 = allCards.filter { $0.tier == .two }
        let tier3 = allCards.filter { $0.tier == .three }
        
        let visibleTier1 = Array(tier1.prefix(4))
        let visibleTier2 = Array(tier2.prefix(4))
        let visibleTier3 = Array(tier3.prefix(4))
        
        let deckTier1 = Array(tier1.dropFirst(4))
        let deckTier2 = Array(tier2.dropFirst(4))
        let deckTier3 = Array(tier3.dropFirst(4))
        
        return (visibleTier1, visibleTier2, visibleTier3, deckTier1, deckTier2, deckTier3)
    }
    
    // CRITICAL: Safe property with bounds checking
    var currentPlayer: Player? {
        guard currentPlayerIndex >= 0 && currentPlayerIndex < players.count else {
            return nil
        }
        return players[currentPlayerIndex]
    }

    func calculateTotalTokens(for player: Player) -> Int {
        return player.tokens.values.reduce(0) { total, tokensArray in
            total + tokensArray.count
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 6) {
                // Header
                HStack {
                    Button("New Game") {
                        showNewGameConfirm = true
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .foregroundColor(.red)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .confirmationDialog("Start a new game?", isPresented: $showNewGameConfirm) {
                    Button("New Game", role: .destructive) {
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This will end the current game and return to setup.")
                }
                .onAppear {
                    // If first player is AI, have them take their turn
                    if let player = currentPlayer, player.isAI {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.executeAITurn()
                        }
                    }
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
                                    // FIX BUG #1: Remove nested button - use onTapGesture instead
                                    NobleView(
                                        mathematician: noble,
                                        canClaim: canClaimNoble(noble)
                                    )
                                    .onTapGesture {
                                        selectedNoble = noble
                                    }
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
                        
                        // This turn info box with token display
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text(currentPlayer?.name ?? "---")
                                    .font(.caption)
                                Spacer()
                                if !errorMessage.isEmpty {
                                    Text(errorMessage)
                                        .font(.system(size: 9))
                                        .foregroundColor(.red)
                                        .lineLimit(1)
                                }
                            }
                            .padding(8)
                            .padding(.bottom, 4)
                            
                            TurnTokensView(
                                collectedTypes: collectedTypesCount,
                                onReturn: { tokenType in
                                    returnTokenToSupply(tokenType)
                                }
                            )
                            .frame(minHeight: 40)
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .frame(minHeight: 70)
                        
                        // Token supply
                        tokenSupplySection
                        
                        // Players
                        playersSection
                        
                        // End Turn button at bottom
                        Button("End Turn") {
                            endTurn()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
            }
            .id(updateTrigger)
            
            // Winner overlay
            if showWinner, let winner = winner {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                WinnerView(winner: winner, allPlayers: players) {
                    // Return to setup - dismiss entire game
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(item: $selectedCard) { card in
            CardDetailView(card: card)
        }
        .sheet(item: $selectedPlayer) { player in
            PlayerHandDetailView(player: player)
        }
        .sheet(item: $selectedNoble) { noble in
            NobleDetailView(noble: noble)
        }
        .confirmationDialog("Reserve Without Gold?", isPresented: $showReserveWarning) {
            Button("Reserve", role: .destructive) {
                if let card = cardToReserve {
                    performReserve(card)
                }
                showReserveWarning = false
                cardToReserve = nil
            }
            Button("Cancel") {
                showReserveWarning = false
                cardToReserve = nil
            }
        } message: {
            Text(reserveWarningMessage)
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
                            // FIX BUG #1: Remove nested button - use onTapGesture instead for detail view
                            CompactCardView(
                                card: card,
                                canAfford: (currentPlayer != nil) ? GameRules.canAffordCard(player: currentPlayer!, card: card) : false,
                                onBuy: { buyCard(card) },
                                onReserve: { reserveCard(card) }
                            )
                            .onTapGesture {
                                selectedCard = card
                            }
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
                            // FIX BUG #1: Remove nested button - use onTapGesture instead
                            CompactCardView(
                                card: card,
                                canAfford: (currentPlayer != nil) ? GameRules.canAffordCard(player: currentPlayer!, card: card) : false,
                                onBuy: { buyCard(card) },
                                onReserve: { reserveCard(card) }
                            )
                            .onTapGesture {
                                selectedCard = card
                            }
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
                            // FIX BUG #1: Remove nested button - use onTapGesture instead
                            CompactCardView(
                                card: card,
                                canAfford: (currentPlayer != nil) ? GameRules.canAffordCard(player: currentPlayer!, card: card) : false,
                                onBuy: { buyCard(card) },
                                onReserve: { reserveCard(card) }
                            )
                            .onTapGesture {
                                selectedCard = card
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.05))
    }

    func reserveFromDeck(tier: CardTier) {
        guard let player = currentPlayer else {
            errorMessage = "Invalid player state"
            return
        }
        
        if turnAction != .none {
            errorMessage = "Already took action this turn"
            return
        }
        
        if player.reservedCards.count >= 3 {
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
        player.reserveCard(cardToReserve)
        
        // Take a gold token if available AND if under token limit
        if calculateTotalTokens(for: player) < 10 {
            if let goldToken = tokenSupply.take(.perfect, count: 1) {
                player.addTokens(goldToken)
            }
        }
        
        // Check if over limit after reserving
        if calculateTotalTokens(for: player) > 10 {
            errorMessage = "You are over 10 tokens. You must discard tokens."
            turnAction = .reservedCard
            updateTrigger += 1
            return  // Don't auto-end if they need to discard
        }
        
        turnAction = .reservedCard
        errorMessage = ""
        updateTrigger += 1
        
        // ONLY auto-end for HUMAN players
        if !player.isAI {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.endTurn()
            }
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
                // FIX BUG #1: Remove nested button - use onTapGesture instead
                CompactPlayerView(
                    player: player,
                    isCurrent: player.id == currentPlayer?.id,
                    onBuyReserved: { card in
                        if player.id == currentPlayer?.id {
                            buyReservedCard(card)
                        }
                    }
                )
                .onTapGesture {
                    selectedPlayer = player
                }
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
    
    func canClaimNoble(_ noble: Mathematician) -> Bool {
        guard let player = currentPlayer else {
            return false
        }
        
        for (tokenType, requiredCount) in noble.requirements {
            let bonusCount = player.bonusCount(of: tokenType)
            if bonusCount < requiredCount {
                return false
            }
        }
        return true
    }
    
    func claimNobleIfPossible() {
        guard let player = currentPlayer else {
            return
        }
        
        for noble in availableNobles {
            if canClaimNoble(noble) {
                player.claimMathematician(noble)
                availableNobles.removeAll { $0.id == noble.id }
                break // Only claim one noble per turn
            }
        }
    }
    
    func collectToken(_ type: TokenType) {
        guard let player = currentPlayer else {
            errorMessage = "Invalid player state"
            return
        }
        
        let collectedTypesSet = Set(collectedTypesCount.keys)
        let check = GameRules.canCollectToken(
            tokenType: type,
            supply: tokenSupply,
            player: player,
            tokensCollectedThisTurn: tokensCollectedThisTurn,
            turnAction: turnAction,
            collectedTypes: collectedTypesSet
        )
        
        if !check.canCollect {
            errorMessage = check.reason
            return
        }
        
        if let tokens = tokenSupply.take(type, count: 1) {
            player.addTokens(tokens)
            tokensCollectedThisTurn += 1
            collectedTypesCount[type, default: 0] += 1
            turnAction = .collectingTokens
            errorMessage = ""
            updateTrigger += 1
            
            if calculateTotalTokens(for: player) > 10 {
                errorMessage = "You have over 10 tokens. Tap one of your tokens to discard it."
            }
        }
    }

    func returnToken(_ type: TokenType) {
        guard let player = currentPlayer else {
            return
        }
        
        let isCollectedThisTurn = (collectedTypesCount[type] ?? 0) > 0

        if turnAction == .collectingTokens && isCollectedThisTurn {
            // Case 1: Undo a token collection
            let returned = player.removeTokens(type, count: 1)
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
        } else if calculateTotalTokens(for: player) > 10 {
            // Case 2: Discarding due to 10-token limit
            if player.tokenCount(of: type) > 0 {
                let returned = player.removeTokens(type, count: 1)
                tokenSupply.returnTokens(returned)
                
                errorMessage = calculateTotalTokens(for: player) > 10
                    ? "Still over 10 tokens. Discard another."
                    : ""
            } else {
                errorMessage = "You don't have a token of that type to discard."
            }
        } else {
            // Case 3: Invalid action
            errorMessage = "Cannot return that token at this time."
        }

        updateTrigger += 1
    }
    
    func payForCard(_ card: Card) {
        guard let player = currentPlayer else {
            return
        }
        
        var costToPay = card.cost
        var goldTokensToSpend = 0
        var tokensToReturn: [TokenType: Int] = [:]

        // 1. Calculate net cost after applying bonuses
        for (type, cost) in costToPay {
            let bonus = player.bonusCount(of: type)
            costToPay[type] = max(0, cost - bonus)
        }

        // 2. Use specific tokens first, note the shortfall
        for (type, required) in costToPay where required > 0 {
            let playerHas = player.tokenCount(of: type)
            let spendSpecific = min(required, playerHas)
            let shortfall = required - spendSpecific

            if spendSpecific > 0 {
                tokensToReturn[type, default: 0] += spendSpecific
            }

            // 3. Use gold tokens to cover the remaining shortfall
            if shortfall > 0 {
                let goldAvailable = player.tokenCount(of: .perfect) - goldTokensToSpend
                let useGold = min(shortfall, goldAvailable)
                
                goldTokensToSpend += useGold
            }
        }
        
        // 4. Execute the token removal/return
        if goldTokensToSpend > 0 {
            let spentGold = player.removeTokens(.perfect, count: goldTokensToSpend)
            tokenSupply.returnTokens(spentGold)
        }

        for (type, count) in tokensToReturn {
            if count > 0 {
                let spent = player.removeTokens(type, count: count)
                tokenSupply.returnTokens(spent)
            }
        }
    }

    func buyCard(_ card: Card) {
        guard let player = currentPlayer else {
            errorMessage = "Invalid player state"
            return
        }
        
        let check = GameRules.canBuyCard(turnAction: turnAction)
        if !check.canBuy {
            errorMessage = check.reason
            return
        }
        
        if !GameRules.canAffordCard(player: player, card: card) {
            errorMessage = "Can't afford this card"
            return
        }
        
        payForCard(card)
        
        player.purchaseCard(card)
        removeAndReplaceCard(card)
        
        // Check for nobles
        claimNobleIfPossible()
        
        turnAction = .boughtCard
        errorMessage = ""
        updateTrigger += 1
        
        // ONLY auto-end for HUMAN players
        if !player.isAI {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.endTurn()
            }
        }
    }
    
    func buyReservedCard(_ card: Card) {
        guard let player = currentPlayer else {
            errorMessage = "Invalid player state"
            return
        }
        
        let check = GameRules.canBuyCard(turnAction: turnAction)
        if !check.canBuy {
            errorMessage = check.reason
            return
        }
        
        if !GameRules.canAffordCard(player: player, card: card) {
            errorMessage = "Can't afford this card"
            return
        }
        
        payForCard(card)
        
        // Purchase and remove from reserved
        player.purchaseCard(card)
        player.removeReservedCard(card)
        
        // Check for nobles
        claimNobleIfPossible()
        
        turnAction = .boughtCard
        errorMessage = ""
        updateTrigger += 1
        
        // ONLY auto-end for HUMAN players
        if !player.isAI {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.endTurn()
            }
        }
    }
    
    func reserveCard(_ card: Card) {
        guard let player = currentPlayer else {
            errorMessage = "Invalid player state"
            return
        }
        
        if turnAction != .none {
            errorMessage = "Already took action this turn"
            return
        }
        
        if player.reservedCards.count >= 3 {
            errorMessage = "Can only reserve 3 cards"
            return
        }
        
        // Check if we can get gold token
        let goldAvailable = tokenSupply.tokens[.perfect]?.count ?? 0 > 0
        let canGetGold = calculateTotalTokens(for: player) < 10 && goldAvailable
        
        // If no gold, show confirmation dialog
        if !canGetGold {
            cardToReserve = card
            if calculateTotalTokens(for: player) >= 10 {
                reserveWarningMessage = "You're at the token limit (10). You won't receive a gold token. Continue?"
            } else {
                reserveWarningMessage = "No gold tokens available. You won't receive a gold token. Continue?"
            }
            showReserveWarning = true
            return
        }
        
        // Has gold available - reserve immediately
        performReserve(card)
    }
    
    func performReserve(_ card: Card) {
        guard let player = currentPlayer else {
            return
        }
        
        // Reserve the card
        player.reserveCard(card)
        
        // Take a gold token if available AND if under token limit
        if calculateTotalTokens(for: player) < 10 {
            if let goldToken = tokenSupply.take(.perfect, count: 1) {
                player.addTokens(goldToken)
            }
        }
        
        // Check if over limit after reserving
        if calculateTotalTokens(for: player) > 10 {
            errorMessage = "You are over 10 tokens. You must discard tokens."
            turnAction = .reservedCard
            updateTrigger += 1
            removeAndReplaceCard(card)
            return
        }
        
        removeAndReplaceCard(card)
        
        turnAction = .reservedCard
        errorMessage = ""
        updateTrigger += 1
        
        // ONLY auto-end for HUMAN players
        if !player.isAI {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.endTurn()
            }
        }
    }
    
    func removeAndReplaceCard(_ card: Card) {
        if card.tier == .one {
            visibleCardsTier1.removeAll { $0.id == card.id }
            if !deckTier1.isEmpty {
                visibleCardsTier1.append(deckTier1.removeFirst())
            }
            // Ensure we never exceed 4 visible cards
            while visibleCardsTier1.count > 4 {
                visibleCardsTier1.removeFirst()
            }
        } else if card.tier == .two {
            visibleCardsTier2.removeAll { $0.id == card.id }
            if !deckTier2.isEmpty {
                visibleCardsTier2.append(deckTier2.removeFirst())
            }
            // Ensure we never exceed 4 visible cards
            while visibleCardsTier2.count > 4 {
                visibleCardsTier2.removeFirst()
            }
        } else {
            visibleCardsTier3.removeAll { $0.id == card.id }
            if !deckTier3.isEmpty {
                visibleCardsTier3.append(deckTier3.removeFirst())
            }
            // Ensure we never exceed 4 visible cards
            while visibleCardsTier3.count > 4 {
                visibleCardsTier3.removeFirst()
            }
        }
    }
    
    func endTurn() {
        guard let player = currentPlayer else {
            errorMessage = "Invalid player state"
            return
        }
        
        let check = GameRules.canEndTurn(player: player)
        
        if calculateTotalTokens(for: player) > 10 {
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
        errorMessage = ""  // Clear error before next turn
        updateTrigger += 1
        
        // Only execute AI turn if the NEXT player is AI
        if let nextPlayer = currentPlayer, nextPlayer.isAI {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.executeAITurn()
            }
        }
    }
    
    func executeAITurn() {
        guard let player = currentPlayer else {
            return
        }
        
        guard player.isAI else {
            return
        }
        
        // Prevent multiple AI turns running simultaneously
        guard !isAIThinking else {
            return
        }
        
        isAIThinking = true
        
        // Get all visible cards for the AI to consider
        let allVisibleCards = visibleCardsTier1 + visibleCardsTier2 + visibleCardsTier3
        
        // Get the AI's move
        let collectedTypesSet = Set(collectedTypesCount.keys)
        let aiAction = AIPlayer.makeMove(
            player: player,
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
                // Clear error before AI's action
                self.errorMessage = ""
                self.collectToken(type)
                
                if let player = self.currentPlayer, self.calculateTotalTokens(for: player) > 10 {
                    self.performAIDiscard()
                }
                
                // Check if THIS action succeeded (by checking if error was set)
                if self.errorMessage.isEmpty {
                    // This token collection succeeded, continue AI turn
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.executeAITurn()
                    }
                } else {
                    // This token collection failed, end turn
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.endTurn()
                    }
                }
                
            case .buyCard(let card):
                self.buyCard(card)
                // After buying, end turn
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.endTurn()
                }
                
            case .reserveCard(let card):
                self.reserveCard(card)

                if let player = self.currentPlayer, self.calculateTotalTokens(for: player) > 10 {
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
        guard let player = currentPlayer else {
            return
        }
        
        while calculateTotalTokens(for: player) > 10 {
            let removableTokens = player.tokens.filter { $0.value.count > 0 }
            
            guard let typeToDiscard = removableTokens
                .sorted(by: { $0.value.count > $1.value.count })
                .first?
                .key else {
                    break
            }
            
            let returned = player.removeTokens(typeToDiscard, count: 1)
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
    
    func returnTokenToSupply(_ tokenType: TokenType) {
        guard let player = currentPlayer else {
            return
        }
        
        // Only allow returning tokens that were collected this turn
        guard collectedTypesCount[tokenType, default: 0] > 0 else {
            errorMessage = "No tokens of that type to return"
            return
        }
        
        // Remove one token from player
        let returned = player.removeTokens(tokenType, count: 1)
        
        // Return to supply
        tokenSupply.returnTokens(returned)
        
        // Update tracking
        if var count = collectedTypesCount[tokenType] {
            count -= 1
            if count == 0 {
                collectedTypesCount.removeValue(forKey: tokenType)
            } else {
                collectedTypesCount[tokenType] = count
            }
        }
        
        tokensCollectedThisTurn = max(0, tokensCollectedThisTurn - 1)
        
        // FIX BUG #2: Reset turnAction when all collected tokens are returned
        if tokensCollectedThisTurn == 0 {
            turnAction = .none
        }
        
        errorMessage = ""
        updateTrigger += 1
    }
}
