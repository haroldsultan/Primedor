import SwiftUI

// MARK: - Card Fly Away Animation (Card leaves to player area)

struct CardFlyAwayModifier: ViewModifier {
    let isAnimating: Bool
    let targetX: CGFloat
    let targetY: CGFloat
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .offset(offset)
            .opacity(opacity)
            .onChange(of: isAnimating) { oldValue, newValue in
                if newValue {
                    startAnimation()
                }
            }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 0.6)) {
            scale = 0.2
            opacity = 0.0
            offset = CGSize(width: targetX, height: targetY)
        }
    }
}

extension View {
    func cardFlyAway(isAnimating: Bool, targetX: CGFloat, targetY: CGFloat) -> some View {
        modifier(CardFlyAwayModifier(isAnimating: isAnimating, targetX: targetX, targetY: targetY))
    }
}

// MARK: - Card Pop In Animation (New card appears)

struct CardPopInModifier: ViewModifier {
    let shouldAppear: Bool
    
    @State private var scale: CGFloat = 0.0
    @State private var opacity: Double = 0.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                if shouldAppear {
                    startAnimation()
                }
            }
    }
    
    private func startAnimation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            scale = 1.0
            opacity = 1.0
        }
    }
}

extension View {
    func cardPopIn(shouldAppear: Bool) -> some View {
        modifier(CardPopInModifier(shouldAppear: shouldAppear))
    }
}
