import SwiftUI

struct ReservedCardView: View {
    let card: Card
    let canAfford: Bool
    let onBuy: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            // Card name
            Text(card.name)
                .font(.system(size: 10))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Cost
            HStack(spacing: 2) {
                ForEach(card.cost.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { type, count in
                    HStack(spacing: 1) {
                        Text("\(count)")
                            .font(.system(size: 9))
                        Circle()
                            .fill(colorFor(type))
                            .frame(width: 8, height: 8)
                    }
                }
            }
            
            // Buy button
            Button("Buy") {
                onBuy()
            }
            .font(.system(size: 9))
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .background(canAfford ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(3)
            .disabled(!canAfford)
        }
        .padding(4)
        .background(Color.orange.opacity(0.1))
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
