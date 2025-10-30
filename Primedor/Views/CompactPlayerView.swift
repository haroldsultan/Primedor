import SwiftUI

struct CompactPlayerView: View {
    let player: Player
    let isCurrent: Bool
    let isFlashing: Bool
    let onBuyReserved: (Card) -> Void
    
    // Helper function for color (Keep this the same)
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            // MARK: - Line 1: Name, Resources, Nobles, Points
            HStack(spacing: 8) {
                
                // 1. Player Name (SMALLER FONT) - LARGE GREEN HIGHLIGHT WHEN BUYING
                Text(player.name)
                    .font(.system(.caption, design: .default).weight(.heavy))
                    .foregroundColor(isFlashing ? .white : (isCurrent ? .primary : .secondary))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(isFlashing ? Color.green : Color.clear)
                    .cornerRadius(6)
                    .scaleEffect(isFlashing ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isFlashing)
                
                // 2. Combined Tokens (Circle) and Permanent Bonuses (Rectangle)
                HStack(spacing: 4) {
                    ForEach(TokenType.allCases, id: \.self) { type in
                        let tokenCount = player.tokenCount(of: type)
                        let bonusCount = player.bonusCount(of: type)

                        if tokenCount > 0 || bonusCount > 0 {
                            
                            // Display Temporary Tokens (Circle + Count)
                            if tokenCount > 0 {
                                Circle()
                                    .fill(colorFor(type))
                                    .frame(width: 15, height: 15)
                                    .overlay(
                                        Text("\(tokenCount)")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                            }
                            
                            // Display Permanent Bonuses (Rounded Rectangle + Count)
                            if bonusCount > 0 {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(colorFor(type))
                                    .frame(width: 15, height: 15)
                                    .overlay(
                                        Text("\(bonusCount)")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .padding(.leading, tokenCount > 0 ? 2 : 0)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // 3. Nobles, Tokens, and Cards (New Combined Stat Block)
                HStack(spacing: 4) {
                    
                    // Nobles
                    if !player.mathematicians.isEmpty {
                        Text("👑\(player.mathematicians.count)")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                    
                    // Total Tokens (New position, next to cards)
                    Text("\(player.totalTokenCount)t")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    // Total Cards
                    Text("\(player.purchasedCards.count)c")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                // 4. Victory Points (Most prominent right-aligned)
                Text("\(player.victoryPoints)p")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
            }
            
            // MARK: - Reserved Card Detail (Always visible and vertical)
            if !player.reservedCards.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Reserved:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(player.reservedCards) { card in
                            ReservedCardView(
                                card: card,
                                canAfford: isCurrent && GameRules.canAffordCard(player: player, card: card, pendingTokens: [:]),
                                onBuy: { onBuyReserved(card) }
                            )
                        }
                    }
                    .padding(.leading, 8)
                }
                .padding(.leading, 10)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isCurrent ? Color.blue.opacity(0.1) : Color.clear)
        )
    }
}
