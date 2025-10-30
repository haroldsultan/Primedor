import SwiftUI

struct SimpleGameView: View {
    @Environment(\.dismiss) var dismiss
    let playerCount: Int
    @State private var tokenSupply: TokenSupply
    @State private var players: [Player]
    @State private var currentPlayerIndex = 0
    @State private var updateTrigger = 0
    @State private var turnNumber = 1
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
    @State private var revealingPlayer: Player?

    
    // Animation state
    @State private var animatingCardId: UUID?
    
    // Track newly drawn cards (for NEW badge)
    @State private var newlyDrawnCardIds: Set<UUID> = []
    
    // Highlight player when they buy/reserve
    @State private var highlightedPlayerId: UUID?
    
    // Frame tracking for card journey animation
    @State private var cardGridFrame: CGRect = .zero
    @State private var playerAreaFrame: CGRect = .zero
    @State private var animatingCardStartFrame: CGRect = .zero
    
    // Track tokens pending finalization until end of turn
    @State private var pendingTokensByPlayer: [UUID: [TokenType: Int]] = [:]
    
    // NEW: Card reveal animation
    @State private var revealingCard: Card? = nil
    
    // NEW: Track card action (bought or reserved)
    @State private var cardAction: CardAction = .bought
    
    // Speed manager for AI timing - observe the shared singleton
    @ObservedObject private var speedManager = GameSpeedManager.shared
    
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
        
        // Initialize pending tokens for all players
        self._pendingTokensByPlayer = State(initialValue: validPlayers.reduce(into: [:]) { dict, player in
            dict[player.id] = [:]
        })
    }
    
    /// Legacy initializer for backward compatibility (2-4 players with P1 human, rest AI)
    init(playerCount: Int) {
        let validPlayerCount = max(2, min(playerCount, 4))
        let names = ["Bob", "Abby", "Emma", "Ann"]
        
        var playerArray: [Player] = []
        for i in 1...validPlayerCount {
            if i == 1 {
                playerArray.append(Player(name: names[i-1], isAI: false))
            } else {
                playerArray.append(Player(name: names[i-1], isAI: true))
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
    
    // NEW: Calculate total tokens including pending tokens
    func calculateTotalTokensWithPending(for player: Player) -> Int {
        let currentTokens = calculateTotalTokens(for: player)
        let pendingTokens = pendingTokensByPlayer[player.id]?.values.reduce(0, +) ?? 0
        return currentTokens + pendingTokens
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
                    
                    Text("Turn \(turnNumber)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
                            .background(
                                GeometryReader { geo in
                                    Color.clear.onAppear {
                                        cardGridFrame = geo.frame(in: .global)
                                    }
                                }
                            )
                        
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
                            .background(
                                GeometryReader { geo in
                                    Color.clear.onAppear {
                                        playerAreaFrame = geo.frame(in: .global)
                                    }
                                }
                            )
                        
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
            
            // Winner overlay
            if showWinner, let winner = winner {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                WinnerView(winner: winner, allPlayers: players) {
                    dismiss()
                }
            }
            
            // Card reveal overlay
            if revealingCard != nil {
                CardRevealOverlay(revealingCard: $revealingCard, player: revealingPlayer, action: cardAction)
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
                    HStack(spacing: 2) {
                        ForEach(visibleCardsTier3) { card in
                            CompactCardView(
                                card: card,
                                canAfford: (currentPlayer != nil && turnAction != .collectingTokens) ? GameRules.canAffordCard(player: currentPlayer!, card: card, pendingTokens: pendingTokensByPlayer[currentPlayer!.id] ?? [:]) : false,
                                onBuy: { buyCard(card) },
                                onReserve: { reserveCard(card) }
                            )
                            .cardDeparture(isAnimating: animatingCardId == card.id)
                            .cardArrival(shouldShowBadge: newlyDrawnCardIds.contains(card.id))
                            .onTapGesture {
                                selectedCard = card
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
            .padding(.horizontal, 8)
            
            // Tier 2 row
            HStack(spacing: 4) {
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
                    HStack(spacing: 2) {
                        ForEach(visibleCardsTier2) { card in
                            CompactCardView(
                                card: card,
                                canAfford: (currentPlayer != nil && turnAction != .collectingTokens) ? GameRules.canAffordCard(player: currentPlayer!, card: card, pendingTokens: pendingTokensByPlayer[currentPlayer!.id] ?? [:]) : false,
                                onBuy: { buyCard(card) },
                                onReserve: { reserveCard(card) }
                            )
                            .cardJourney(
                                isAnimating: animatingCardId == card.id,
                                from: cardGridFrame,
                                to: playerAreaFrame
                            )
                            .cardArrival(shouldShowBadge: newlyDrawnCardIds.contains(card.id))
                            .onTapGesture {
                                selectedCard = card
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                }
            }
            .padding(.horizontal, 8)
            
            // Tier 1 row
            HStack(spacing: 4) {
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
                    HStack(spacing: 2) {
                        ForEach(visibleCardsTier1) { card in
                            CompactCardView(
                                card: card,
                                canAfford: (currentPlayer != nil && turnAction != .collectingTokens) ? GameRules.canAffordCard(player: currentPlayer!, card: card, pendingTokens: pendingTokensByPlayer[currentPlayer!.id] ?? [:]) : false,
                                onBuy: { buyCard(card) },
                                onReserve: { reserveCard(card) }
                            )
                            .cardJourney(
                                isAnimating: animatingCardId == card.id,
                                from: cardGridFrame,
                                to: playerAreaFrame
                            )
                            .cardArrival(shouldShowBadge: newlyDrawnCardIds.contains(card.id))
                            .onTapGesture {
                                selectedCard = card
                            }
                        }
                    }
                    .padding(.horizontal, 2)
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
            if !player.isAI {
                errorMessage = "Already took action this turn"
            }
            return
        }
        
        if player.reservedCards.count >= 3 {
            if !player.isAI {
                errorMessage = "Can only reserve 3 cards"
            }
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
            if !player.isAI {
                errorMessage = "No cards left in that deck"
            }
            return
        }
        
        // Reserve the card
        player.reserveCard(cardToReserve)
        
        // Play sound effect
        SoundManager.shared.playCardReserveSound()
        
        // Add gold token to PENDING (not directly to player)
        if calculateTotalTokensWithPending(for: player) < 10 {
            if tokenSupply.tokens[.perfect]?.count ?? 0 > 0 {
                pendingTokensByPlayer[player.id, default: [.perfect: 0]][.perfect, default: 0] += 1
                tokenSupply.take(.perfect, count: 1)
            }
        }
        
        // Check if over limit after reserving
        if calculateTotalTokensWithPending(for: player) > 10 {
            if !player.isAI {
                errorMessage = "You are over 10 tokens. You must discard tokens."
            }
            turnAction = .reservedCard
            updateTrigger += 1
            return
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
                CompactPlayerView(
                    player: player,
                    isCurrent: player.id == currentPlayer?.id,
                    isFlashing: player.id == highlightedPlayerId,
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
                
                // Play sound effect when noble is claimed
                SoundManager.shared.playNobleClaimSound()
                
                break
            }
        }
    }
    
    func collectToken(_ type: TokenType) {
        guard let player = currentPlayer else {
            if currentPlayer == nil {
                errorMessage = "Invalid player state"
            }
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
            if !player.isAI {
                errorMessage = check.reason
            }
            return
        }
        
        if let tokens = tokenSupply.take(type, count: 1) {
            // Add to PENDING instead of directly to player
            pendingTokensByPlayer[player.id, default: [:]][type, default: 0] += 1
            tokensCollectedThisTurn += 1
            collectedTypesCount[type, default: 0] += 1
            turnAction = .collectingTokens
            errorMessage = ""
            updateTrigger += 1
            
            // Play token collection sound
            SoundManager.shared.playTokenCollectSound()
            
            if calculateTotalTokensWithPending(for: player) > 10 {
                if !player.isAI {
                    errorMessage = "You have over 10 tokens. Tap one of your tokens to discard it."
                }
            }
        }
    }

    func returnToken(_ type: TokenType) {
        guard let player = currentPlayer else {
            return
        }
        
        let isCollectedThisTurn = (collectedTypesCount[type] ?? 0) > 0

        if turnAction == .collectingTokens && isCollectedThisTurn {
            if let pendingCount = pendingTokensByPlayer[player.id]?[type], pendingCount > 0 {
                pendingTokensByPlayer[player.id]?[type] = pendingCount - 1
                if pendingTokensByPlayer[player.id]?[type] == 0 {
                    pendingTokensByPlayer[player.id]?.removeValue(forKey: type)
                }
                tokenSupply.returnTokens([Token(type: type)])
            }
            
            tokensCollectedThisTurn -= 1
            collectedTypesCount[type]! -= 1
            if collectedTypesCount[type]! == 0 {
                collectedTypesCount.removeValue(forKey: type)
            }
            
            if tokensCollectedThisTurn == 0 {
                turnAction = .none
            }
            errorMessage = ""
        } else if calculateTotalTokensWithPending(for: player) > 10 {
            if player.tokenCount(of: type) > 0 {
                let returned = player.removeTokens(type, count: 1)
                tokenSupply.returnTokens(returned)
                
                errorMessage = calculateTotalTokensWithPending(for: player) > 10
                    ? "Still over 10 tokens. Discard another."
                    : ""
            } else {
                errorMessage = "You don't have a token of that type to discard."
            }
        } else {
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

        for (type, cost) in costToPay {
            let bonus = player.bonusCount(of: type)
            costToPay[type] = max(0, cost - bonus)
        }

        for (type, required) in costToPay where required > 0 {
            let playerHas = player.tokenCount(of: type)
            let spendSpecific = min(required, playerHas)
            let shortfall = required - spendSpecific

            if spendSpecific > 0 {
                tokensToReturn[type, default: 0] += spendSpecific
            }

            if shortfall > 0 {
                let goldAvailable = player.tokenCount(of: .perfect) - goldTokensToSpend
                let useGold = min(shortfall, goldAvailable)
                
                goldTokensToSpend += useGold
            }
        }
        
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
            if !player.isAI {
                errorMessage = check.reason
            }
            return
        }
        
        if !GameRules.canAffordCard(player: player, card: card, pendingTokens: pendingTokensByPlayer[player.id] ?? [:]) {
            if !player.isAI {
                errorMessage = "Can't afford this card"
            }
            return
        }
        
        payForCard(card)
        player.purchaseCard(card)
        
        // Play card buy sound
        SoundManager.shared.playCardBuySound()
        
        // Trigger animation for human players
        if !player.isAI {
            animatingCardId = card.id
            highlightedPlayerId = player.id
        }
        
        claimNobleIfPossible()
        
        turnAction = .boughtCard
        errorMessage = ""
        
        // Wait for animation, then replace card
        DispatchQueue.main.asyncAfter(deadline: .now() + speedManager.currentSpeed.cardReplacementDelay) {
            removeAndReplaceCard(card)
            updateTrigger += 1
        }
        
        // Clear animation state and highlight after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + speedManager.currentSpeed.animationDelay + 1.0) {
            animatingCardId = nil
            highlightedPlayerId = nil
        }
        
        // Show card reveal
        cardAction = .bought
        revealingCard = card
        revealingPlayer = player
        
        if !player.isAI {
            // Adjust end turn delay based on reveal duration
            let revealDuration = speedManager.currentSpeed == .slow ? 3.0 :
                                 speedManager.currentSpeed == .normal ? 2.0 : 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + revealDuration + 0.2) {
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
            if !player.isAI {
                errorMessage = check.reason
            }
            return
        }
        
        if !GameRules.canAffordCard(player: player, card: card, pendingTokens: pendingTokensByPlayer[player.id] ?? [:]) {
            if !player.isAI {
                errorMessage = "Can't afford this card"
            }
            return
        }
        
        payForCard(card)
        player.purchaseCard(card)
        player.removeReservedCard(card)
        
        // Play card buy sound
        SoundManager.shared.playCardBuySound()
        
        claimNobleIfPossible()
        
        turnAction = .boughtCard
        errorMessage = ""
        updateTrigger += 1
        
        // Show card reveal
        cardAction = .bought
        revealingCard = card
        
        if !player.isAI {
            let revealDuration = speedManager.currentSpeed == .slow ? 3.0 :
                                 speedManager.currentSpeed == .normal ? 2.0 : 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + revealDuration + 0.2) {
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
            if !player.isAI {
                errorMessage = "Already took action this turn"
            }
            return
        }
        
        if player.reservedCards.count >= 3 {
            if !player.isAI {
                errorMessage = "Can only reserve 3 cards"
            }
            return
        }
        
        let goldAvailable = tokenSupply.tokens[.perfect]?.count ?? 0 > 0
        let canGetGold = calculateTotalTokensWithPending(for: player) < 10 && goldAvailable
        
        if !canGetGold {
            if !player.isAI {
                cardToReserve = card
                if calculateTotalTokensWithPending(for: player) >= 10 {
                    reserveWarningMessage = "You're at the token limit (10). You won't receive a gold token. Continue?"
                } else {
                    reserveWarningMessage = "No gold tokens available. You won't receive a gold token. Continue?"
                }
                showReserveWarning = true
            } else {
                performReserve(card)
            }
            return
        }
        
        performReserve(card)
    }
    
    func performReserve(_ card: Card) {
        guard let player = currentPlayer else {
            return
        }
        
        player.reserveCard(card)
        
        // Play sound effect
        SoundManager.shared.playCardReserveSound()
        
        // Trigger animation for human players
        if !player.isAI {
            animatingCardId = card.id
            highlightedPlayerId = player.id
        }
        
        if calculateTotalTokensWithPending(for: player) < 10 {
            if tokenSupply.tokens[.perfect]?.count ?? 0 > 0 {
                pendingTokensByPlayer[player.id, default: [:]][.perfect, default: 0] += 1
                tokenSupply.take(.perfect, count: 1)
            }
        }
        
        if calculateTotalTokensWithPending(for: player) > 10 {
            errorMessage = "You are over 10 tokens. You must discard tokens."
            turnAction = .reservedCard
            
            // Wait for animation, then replace card
            DispatchQueue.main.asyncAfter(deadline: .now() + speedManager.currentSpeed.cardReplacementDelay) {
                removeAndReplaceCard(card)
                updateTrigger += 1
            }
            
            // Clear animation state and highlight after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + speedManager.currentSpeed.animationDelay + 1.0) {
                animatingCardId = nil
                highlightedPlayerId = nil
            }
            return
        }
        
        // Wait for animation, then replace card
        DispatchQueue.main.asyncAfter(deadline: .now() + speedManager.currentSpeed.cardReplacementDelay) {
            removeAndReplaceCard(card)
            updateTrigger += 1
        }
        
        // Clear animation state and highlight after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + speedManager.currentSpeed.animationDelay + 1.0) {
            animatingCardId = nil
            highlightedPlayerId = nil
        }
        
        // Show card reveal
        cardAction = .reserved
        revealingCard = card
        revealingPlayer = player
        
        turnAction = .reservedCard
        errorMessage = ""
        
        if !player.isAI {
            let revealDuration = speedManager.currentSpeed == .slow ? 3.0 :
                                 speedManager.currentSpeed == .normal ? 2.0 : 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + revealDuration + 0.2) {
                self.endTurn()
            }
        }
    }
    
    func removeAndReplaceCard(_ card: Card) {
        if card.tier == .one {
            if let index = visibleCardsTier1.firstIndex(where: { $0.id == card.id }) {
                visibleCardsTier1.remove(at: index)
                if !deckTier1.isEmpty {
                    let newCard = deckTier1.removeFirst()
                    visibleCardsTier1.insert(newCard, at: index)
                    newlyDrawnCardIds.insert(newCard.id)
                    // Remove from set after badge animation completes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        newlyDrawnCardIds.remove(newCard.id)
                    }
                }
            }
        } else if card.tier == .two {
            if let index = visibleCardsTier2.firstIndex(where: { $0.id == card.id }) {
                visibleCardsTier2.remove(at: index)
                if !deckTier2.isEmpty {
                    let newCard = deckTier2.removeFirst()
                    visibleCardsTier2.insert(newCard, at: index)
                    newlyDrawnCardIds.insert(newCard.id)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        newlyDrawnCardIds.remove(newCard.id)
                    }
                }
            }
        } else {
            if let index = visibleCardsTier3.firstIndex(where: { $0.id == card.id }) {
                visibleCardsTier3.remove(at: index)
                if !deckTier3.isEmpty {
                    let newCard = deckTier3.removeFirst()
                    visibleCardsTier3.insert(newCard, at: index)
                    newlyDrawnCardIds.insert(newCard.id)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        newlyDrawnCardIds.remove(newCard.id)
                    }
                }
            }
        }
    }
    
    func endTurn() {
        guard let player = currentPlayer else {
            errorMessage = "Invalid player state"
            return
        }
        
        let check = GameRules.canEndTurn(player: player)
        
        if calculateTotalTokensWithPending(for: player) > 10 {
            if !player.isAI {
                errorMessage = "You must discard tokens down to 10 before ending your turn."
            }
             return
        }
        
        if !check.canEnd {
            if !player.isAI {
                errorMessage = check.reason
            }
            return
        }
        
        // Play turn end sound
        SoundManager.shared.playTurnEndSound()
        
        // FINALIZE: Transfer all pending tokens to the player NOW
        if let pendingTokens = pendingTokensByPlayer[player.id] {
            for (type, count) in pendingTokens {
                if count > 0 {
                    let tokensToAdd = (0..<count).map { _ in Token(type: type) }
                    player.addTokens(tokensToAdd)
                }
            }
            pendingTokensByPlayer[player.id] = [:]
        }
        
        // Check for winner AFTER tokens are finalized
        if let gameWinner = WinCondition.checkWinner(players: players, currentPlayerIndex: currentPlayerIndex) {
            showWinner = true
            winner = gameWinner
            
            // Play win sound
            SoundManager.shared.playGameWinSound()
            
            return
        }
        
        currentPlayerIndex = (currentPlayerIndex + 1) % playerCount
        
        // Increment turn number when we cycle back to first player
        if currentPlayerIndex == 0 {
            turnNumber += 1
        }
        
        tokensCollectedThisTurn = 0
        collectedTypesCount = [:]
        turnAction = .none
        errorMessage = ""
        updateTrigger += 1
        
        if let nextPlayer = currentPlayer, nextPlayer.isAI {
            DispatchQueue.main.asyncAfter(deadline: .now() + speedManager.currentSpeed.turnEndDelay) {
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
        
        guard !isAIThinking else {
            return
        }
        
        isAIThinking = true
        
        let allVisibleCards = visibleCardsTier1 + visibleCardsTier2 + visibleCardsTier3
        
        let collectedTypesSet = Set(collectedTypesCount.keys)
        let aiAction = AIPlayer.makeMove(
            player: player,
            tokenSupply: tokenSupply,
            visibleCards: allVisibleCards,
            turnAction: turnAction,
            collectedTypesThisTurn: collectedTypesSet,
            tokensCollectedThisTurn: tokensCollectedThisTurn
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + speedManager.currentSpeed.aiThinkingDelay) {
            switch aiAction {
            case .collectToken(let type):
                self.errorMessage = ""
                self.collectToken(type)
                
                if let player = self.currentPlayer, self.calculateTotalTokensWithPending(for: player) > 10 {
                    self.performAIDiscard()
                }
                
                if self.errorMessage.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.speedManager.currentSpeed.aiActionDelay) {
                        self.executeAITurn()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.speedManager.currentSpeed.aiActionDelay) {
                        self.endTurn()
                    }
                }
                
            case .buyCard(let card):
                self.buyCard(card)
                DispatchQueue.main.asyncAfter(deadline: .now() + self.speedManager.currentSpeed.aiActionDelay) {
                    self.endTurn()
                }
                
            case .reserveCard(let card):
                self.reserveCard(card)

                if let player = self.currentPlayer, self.calculateTotalTokensWithPending(for: player) > 10 {
                    self.performAIDiscard()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + self.speedManager.currentSpeed.aiActionDelay) {
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
        
        while calculateTotalTokensWithPending(for: player) > 10 {
            if let pendingTokens = pendingTokensByPlayer[player.id], !pendingTokens.isEmpty {
                let sortedPending = pendingTokens.sorted(by: { $0.value > $1.value })
                if let (typeToDiscard, count) = sortedPending.first, count > 0 {
                    pendingTokensByPlayer[player.id]?[typeToDiscard] = count - 1
                    if pendingTokensByPlayer[player.id]?[typeToDiscard] == 0 {
                        pendingTokensByPlayer[player.id]?.removeValue(forKey: typeToDiscard)
                    }
                    tokenSupply.returnTokens([Token(type: typeToDiscard)])
                    updateTrigger += 1
                    continue
                }
            }
            
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
        
        guard collectedTypesCount[tokenType, default: 0] > 0 else {
            if !player.isAI {
                errorMessage = "No tokens of that type to return"
            }
            return
        }
        
        if let pendingCount = pendingTokensByPlayer[player.id]?[tokenType], pendingCount > 0 {
            pendingTokensByPlayer[player.id]?[tokenType] = pendingCount - 1
            if pendingTokensByPlayer[player.id]?[tokenType] == 0 {
                pendingTokensByPlayer[player.id]?.removeValue(forKey: tokenType)
            }
            tokenSupply.returnTokens([Token(type: tokenType)])
        }
        
        if var count = collectedTypesCount[tokenType] {
            count -= 1
            if count == 0 {
                collectedTypesCount.removeValue(forKey: tokenType)
            } else {
                collectedTypesCount[tokenType] = count
            }
        }
        
        tokensCollectedThisTurn = max(0, tokensCollectedThisTurn - 1)
        
        if tokensCollectedThisTurn == 0 {
            turnAction = .none
        }
        
        errorMessage = ""
        updateTrigger += 1
    }
}
