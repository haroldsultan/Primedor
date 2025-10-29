import SwiftUI

// CardAction enum moved outside for better accessibility
enum CardAction {
    case bought
    case reserved
    
    var label: String {
        switch self {
        case .bought:
            return "BOUGHT"
        case .reserved:
            return "RESERVED"
        }
    }
    
    var color: Color {
        switch self {
        case .bought:
            return .green
        case .reserved:
            return .orange
        }
    }
}

/// Shows a card zoomed in and centered on screen, auto-dismisses after delay
struct CardRevealOverlay: View {
    @Binding var revealingCard: Card?
    let player: Player?
    let action: CardAction
    
    @ObservedObject private var speedManager = GameSpeedManager.shared
    
    @State private var isAnimatingIn = false
    
    var dismissDelay: Double {
        // Adjust dismiss delay based on game speed
        switch speedManager.currentSpeed {
        case .slow:
            return 3.0
        case .normal:
            return 2.0
        case .fast:
            return 1.0
        }
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent black background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            // Big card centered
            if let card = revealingCard {
                VStack {
                    Spacer()
                    
                    CardDetailLarge(card: card, player: player, action: action)
                        .scaleEffect(isAnimatingIn ? 1.0 : 0.1)
                        .opacity(isAnimatingIn ? 1.0 : 0.0)
                        .animation(
                            .spring(
                                response: speedManager.currentSpeed == .fast ? 0.3 : 0.6,
                                dampingFraction: 0.7
                            ),
                            value: isAnimatingIn
                        )
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            isAnimatingIn = true
            
            // Auto-dismiss after delay based on speed
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissDelay) {
                dismiss()
            }
        }
    }
    
    private func dismiss() {
        isAnimatingIn = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            revealingCard = nil
        }
    }
}

/// Large card view for the reveal overlay
struct CardDetailLarge: View {
    let card: Card
    let player: Player?
    let action: CardAction
    
    var body: some View {
        VStack(spacing: 8) {
            // Player info with action (who bought/reserved it)
            if let player = player {
                VStack(spacing: 4) {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .foregroundColor(action.color)
                            .font(.caption2)
                        
                        Text(player.name)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(action.label)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(action.color)
                            .cornerRadius(4)
                        
                        Spacer()
                    }
                }
                .padding(.bottom, 2)
            }
            
            // Card name
            Text(card.name)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Divider()
                .padding(.vertical, 2)
            
            // Cost
            VStack(alignment: .leading, spacing: 4) {
                Text("Cost:")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 6) {
                    ForEach(card.cost.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { type, amount in
                        HStack(spacing: 2) {
                            Circle()
                                .fill(colorFor(type))
                                .frame(width: 16, height: 16)
                                .overlay(
                                    Text("\(amount)")
                                        .font(.system(size: 8, weight: .bold))
                                        .foregroundColor(.white)
                                )
                            
                            Text(type.rawValue.capitalized)
                                .font(.system(size: 8))
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Bonus and points
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Bonus:")
                        .font(.system(size: 7))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 3) {
                        Circle()
                            .fill(colorFor(card.bonus))
                            .frame(width: 14, height: 14)
                        
                        Text(card.bonus.rawValue.capitalized)
                            .font(.system(size: 8))
                            .fontWeight(.semibold)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Points:")
                        .font(.system(size: 7))
                        .foregroundColor(.secondary)
                    
                    Text("\(card.points)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.blue)
                }
            }
            
            Text("Tap to close")
                .font(.system(size: 8))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 10)
        .frame(maxWidth: 280)
    }
    
    private func colorFor(_ type: TokenType) -> Color {
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
