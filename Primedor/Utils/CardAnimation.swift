import SwiftUI

/// Card animation modifiers that respect game speed
extension View {
    
    /// Animation when card is leaving the grid (bought/reserved)
    func cardDeparture(isAnimating: Bool) -> some View {
        modifier(CardDepartureModifier(isAnimating: isAnimating))
    }
    
    /// Animation when card arrives in player collection
    func cardArrival(shouldShowBadge: Bool) -> some View {
        modifier(CardArrivalModifier(shouldShowBadge: shouldShowBadge))
    }
    
    /// Journey animation from grid to player area
    func cardJourney(isAnimating: Bool, from: CGRect, to: CGRect) -> some View {
        modifier(CardJourneyModifier(isAnimating: isAnimating, from: from, to: to))
    }
}

// MARK: - Card Departure Modifier
struct CardDepartureModifier: ViewModifier {
    let isAnimating: Bool
    @ObservedObject private var speedManager = GameSpeedManager.shared
    
    var animationDuration: Double {
        switch speedManager.currentSpeed {
        case .slow:
            return 0.8
        case .normal:
            return 0.5
        case .fast:
            return 0.2
        }
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 0.5 : 1.0)
            .opacity(isAnimating ? 0.3 : 1.0)
            .animation(.easeInOut(duration: animationDuration), value: isAnimating)
    }
}

// MARK: - Card Arrival Modifier
struct CardArrivalModifier: ViewModifier {
    let shouldShowBadge: Bool
    @ObservedObject private var speedManager = GameSpeedManager.shared
    
    var badgeDuration: Double {
        switch speedManager.currentSpeed {
        case .slow:
            return 1.5
        case .normal:
            return 1.0
        case .fast:
            return 0.5
        }
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
            
            if shouldShowBadge {
                Text("NEW")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.green)
                    .cornerRadius(3)
                    .offset(x: 4, y: -4)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut(duration: badgeDuration), value: shouldShowBadge)
            }
        }
    }
}

// MARK: - Card Journey Modifier
struct CardJourneyModifier: ViewModifier {
    let isAnimating: Bool
    let from: CGRect
    let to: CGRect
    @ObservedObject private var speedManager = GameSpeedManager.shared
    
    var journeyDuration: Double {
        switch speedManager.currentSpeed {
        case .slow:
            return 1.0
        case .normal:
            return 0.75
        case .fast:
            return 0.5
        }
    }
    
    var offsetX: CGFloat {
        guard isAnimating else { return 0 }
        return from.midX - to.midX
    }
    
    var offsetY: CGFloat {
        guard isAnimating else { return 0 }
        return from.midY - to.midY
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: offsetX, y: offsetY)
            .scaleEffect(isAnimating ? 0.5 : 1.0)
            .opacity(isAnimating ? 0.5 : 1.0)
            .animation(.easeInOut(duration: journeyDuration), value: isAnimating)
    }
}
