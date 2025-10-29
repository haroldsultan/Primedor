import SwiftUI

struct ReservedCardView: View {
    let card: Card
    let canAfford: Bool
    let onBuy: () -> Void
    
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
        HStack(spacing: 6) {
            // Points (Left)
            Text("\(card.points)")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.blue)
                .frame(width: 12)
            
            // Bonus (Permanent Gem - Sticking with the star here for card context)
            Circle()
                .fill(colorFor(card.bonus))
                .frame(width: 10, height: 10)
                .overlay(
                    Text("★")
                        .font(.system(size: 5))
                        .foregroundColor(.white)
                )
            
            // Card name (Center)
            Text(card.name)
                .font(.system(size: 9))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Cost (Right, before button)
            HStack(spacing: 2) {
                ForEach(card.cost.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { type, count in
                    Circle() // Cost tokens are always circles
                        .fill(colorFor(type))
                        .frame(width: 10, height: 10)
                        .overlay(
                            Text("\(count)")
                                .font(.system(size: 7, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
            }
            
            // Buy button (Far Right)
            Button("Buy") {
                onBuy()
            }
            .font(.system(size: 8))
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .background(canAfford ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(3)
            .disabled(!canAfford)
        }
        .padding(4)
        .background(canAfford ? Color.green.opacity(0.1) : Color.white)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(canAfford ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
