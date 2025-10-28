import SwiftUI

struct CompactPlayerView: View {
    let player: Player
    let isCurrent: Bool
    let onBuyReserved: (Card) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Player summary row
            HStack(spacing: 8) {
                Text(player.name.prefix(2))
                    .font(.caption)
                    .fontWeight(isCurrent ? .bold : .regular)
                    .frame(width: 30, alignment: .leading)
                
                // Tokens
                HStack(spacing: 2) {
                    ForEach(TokenType.allCases, id: \.self) { type in
                        let count = player.tokenCount(of: type)
                        if count > 0 {
                            HStack(spacing: 1) {
                                Circle()
                                    .fill(colorFor(type))
                                    .frame(width: 10, height: 10)
                                Text("\(count)")
                                    .font(.system(size: 9))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Bonuses
                HStack(spacing: 2) {
                    ForEach(TokenType.allCases, id: \.self) { type in
                        let bonus = player.bonusCount(of: type)
                        if bonus > 0 {
                            HStack(spacing: 1) {
                                Circle()
                                    .fill(colorFor(type))
                                    .frame(width: 10, height: 10)
                                    .overlay(
                                        Text("★")
                                            .font(.system(size: 6))
                                            .foregroundColor(.white)
                                    )
                                Text("\(bonus)")
                                    .font(.system(size: 9))
                            }
                        }
                    }
                }
                
                // Nobles count
                if !player.mathematicians.isEmpty {
                    Text("👑\(player.mathematicians.count)")
                        .font(.system(size: 10))
                }
                
                Text("\(player.purchasedCards.count)c")
                    .font(.caption2)
                Text("\(player.victoryPoints)p")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            // Reserved cards (if any)
            if !player.reservedCards.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Reserved:")
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                    
                    ForEach(player.reservedCards) { card in
                        ReservedCardView(
                            card: card,
                            canAfford: isCurrent,
                            onBuy: { onBuyReserved(card) }
                        )
                    }
                }
                .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .background(isCurrent ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(4)
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
