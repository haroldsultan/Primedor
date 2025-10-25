import SwiftUI

struct CardRowView: View {
    let tier: CardTier
    let tierLabel: String
    let deckCount: Int
    let visibleCards: [Card]
    let currentPlayer: Player
    let onBuy: (Card) -> Void
    let onReserve: (Card) -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text("\(tierLabel):\(deckCount)")
                .font(.system(size: 10))
                .foregroundColor(tierColor)
                .frame(width: 35)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(visibleCards) { card in
                        CompactCardView(
                            card: card,
                            canAfford: GameRules.canAffordCard(player: currentPlayer, card: card),
                            onBuy: { onBuy(card) },
                            onReserve: { onReserve(card) }
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }
    
    var tierColor: Color {
        switch tier {
        case .one: return .green
        case .two: return .blue
        case .three: return .purple
        }
    }
}
