import SwiftUI

struct CompactCardView: View {
    let card: Card
    let canAfford: Bool
    let onBuy: () -> Void
    let onReserve: () -> Void
    
    var body: some View {
        ZStack {
            // Card content on top
            VStack(spacing: 3) {
                // Top row: Bonus circle with points in top-right
                HStack {
                    Spacer()
                    
                    Circle()
                        .fill(colorFor(card.bonus))
                        .frame(width: 18, height: 18)
                        .overlay(
                            Text("\(card.points)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                
                // Card name
                Text(card.name)
                    .font(.system(size: 8, weight: .semibold))
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.primary)
                
                // Cost tokens
                HStack(spacing: 2) {
                    ForEach(card.cost.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { type, count in
                        Circle()
                            .fill(colorFor(type))
                            .frame(width: 14, height: 14)
                            .overlay(
                                Text("\(count)")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                }
                
//                Spacer()
                
                // Action buttons - side by side
                HStack(spacing: 1) {
                    Button("Buy") {
                        onBuy()
                    }
                    .font(.system(size: 8, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 5)
                    .padding(.bottom, 3)
                    .background(canAfford ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(3)
                    .disabled(!canAfford)

                    Button("Res") {
                        onReserve()
                    }
                    .font(.system(size: 8, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 5)
                    .padding(.bottom, 3)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(3)
                }
            }
            .padding(4)
        }
        .frame(width: 80, height: 75)
        .background(canAfford ? Color.green.opacity(0.1) : Color.white)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(canAfford ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
        )
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
