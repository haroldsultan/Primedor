import SwiftUI

struct CompactCardView: View {
    let card: Card
    let canAfford: Bool
    let onBuy: () -> Void
    let onReserve: () -> Void
    
    var body: some View {
        ZStack {
            // Background with artwork (30% opacity, centered)
//            if let artwork = CardArtworkDatabase.artworks[card.name] {
//                Text(artwork.asciiArt)
//                    .font(.system(size: 3, design: .monospaced))
//                    .opacity(0.5)
//                    .multilineTextAlignment(.center)
//                    .lineLimit(.max)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
            
            // Card content on top
            VStack(spacing: 2) {
                // Top row: Bonus circle with points in top-right
                HStack {
                    Spacer()
                    
                    Circle()
                        .fill(colorFor(card.bonus))
                        .frame(width: 16, height: 16)
                        .overlay(
                            Text("\(card.points)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
                
                // Card name
                Text(card.name)
                    .font(.system(size: 7, weight: .semibold))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Cost tokens
                HStack(spacing: 1) {
                    ForEach(card.cost.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { type, count in
                        Circle()
                            .fill(colorFor(type))
                            .frame(width: 12, height: 12)
                            .overlay(
                                Text("\(count)")
                                    .font(.system(size: 7, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                }
                
                // Action buttons
                HStack(spacing: 2) {
                    Button("Buy") {
                        onBuy()
                    }
                    .font(.system(size: 8))
                    .padding(.vertical, 2)
                    .padding(.horizontal, 6)
                    .background(canAfford ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(3)
                    .disabled(!canAfford)
                    
                    Button("Res") {
                        onReserve()
                    }
                    .font(.system(size: 8))
                    .padding(.vertical, 2)
                    .padding(.horizontal, 6)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(3)
                }
            }
            .padding(3)
        }
        .frame(width: 70, height: 56)
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
