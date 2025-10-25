import SwiftUI

struct CompactCardView: View {
    let card: Card
    let canAfford: Bool
    let onBuy: () -> Void
    let onReserve: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Top: Points and Bonus
            HStack {
                Text("\(card.points)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.blue)
                
                Spacer()
                
                Circle()
                    .fill(colorFor(card.bonus))
                    .frame(width: 14, height: 14)
                    .overlay(
                        Text("★")
                            .font(.system(size: 7))
                            .foregroundColor(.white)
                    )
            }
            .padding(.bottom, 2)
            
            // Card name - ONE LINE
            Text(card.name)
                .font(.system(size: 7))
                .lineLimit(1)
                .padding(.bottom, 2)
            
            // Cost - number INSIDE circle
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
            .padding(.bottom, 2)
            
            // Buttons - side by side
            HStack(spacing: 2) {
                Button("Buy") {
                    onBuy()
                }
                .font(.system(size: 7))
                .padding(.vertical, 2)
                .frame(maxWidth: .infinity)
                .background(canAfford ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(3)
                .disabled(!canAfford)
                
                Button("Res") {
                    onReserve()
                }
                .font(.system(size: 7))
                .padding(.vertical, 2)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(3)
            }
        }
        .padding(3)
        .frame(width: 75, height: 75)
        .background(tierColor)
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(canAfford ? Color.green : Color.clear, lineWidth: 2)
        )
    }
    
    var tierColor: Color {
        switch card.tier {
        case .one: return Color.white
        case .two: return Color.blue.opacity(0.1)
        case .three: return Color.purple.opacity(0.1)
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
