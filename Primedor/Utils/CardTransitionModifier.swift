import SwiftUI

// MARK: - Card Removal & Replacement Animation

struct CardTransitionModifier: ViewModifier {
    let isRemoving: Bool
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .opacity(opacity)
            .onAppear {
                if isRemoving {
                    animateRemoval()
                } else {
                    animateEntry()
                }
            }
    }
    
    private func animateRemoval() {
        withAnimation(.easeInOut(duration: 0.5)) {
            offset = UIScreen.main.bounds.width
            opacity = 0
        }
    }
    
    private func animateEntry() {
        offset = -UIScreen.main.bounds.width
        opacity = 0
        
        withAnimation(.easeInOut(duration: 0.5)) {
            offset = 0
            opacity = 1
        }
    }
}

extension View {
    func cardTransition(isRemoving: Bool) -> some View {
        modifier(CardTransitionModifier(isRemoving: isRemoving))
    }
}

// MARK: - Card Flip Animation

struct CardFlipModifier: ViewModifier {
    @State private var rotation: Double = 0
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 0.6)) {
                    rotation = 360
                }
            }
    }
}

extension View {
    func cardFlip() -> some View {
        modifier(CardFlipModifier())
    }
}

// MARK: - Card Scale Pop (for new card appearing)

struct CardScalePopModifier: ViewModifier {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
    }
}

extension View {
    func cardScalePop() -> some View {
        modifier(CardScalePopModifier())
    }
}

// MARK: - Slide & Fade for Row Replacement

struct CardRowSlideModifier: ViewModifier {
    let direction: SlideDirection
    let duration: Double = 0.5
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    enum SlideDirection {
        case left
        case right
        case up
        case down
    }
    
    func body(content: Content) -> some View {
        content
            .offset(getOffset())
            .opacity(opacity)
            .onAppear {
                animateTransition()
            }
    }
    
    private func getOffset() -> CGSize {
        switch direction {
        case .left:
            return CGSize(width: offset, height: 0)
        case .right:
            return CGSize(width: -offset, height: 0)
        case .up:
            return CGSize(width: 0, height: offset)
        case .down:
            return CGSize(width: 0, height: -offset)
        }
    }
    
    private func animateTransition() {
        let startOffset: CGFloat = 50
        
        switch direction {
        case .left, .right:
            offset = startOffset
        case .up, .down:
            offset = startOffset
        }
        
        opacity = 0
        
        withAnimation(.easeOut(duration: duration)) {
            offset = 0
            opacity = 1.0
        }
    }
}

extension View {
    func cardRowSlide(_ direction: CardRowSlideModifier.SlideDirection) -> some View {
        modifier(CardRowSlideModifier(direction: direction))
    }
}

// MARK: - Complete Card Replacement Animation (Remove + Add)

struct CardReplacementView: View {
    let removingCard: Card?
    let newCard: Card?
    let content: () -> AnyView
    @State private var showNew = false
    
    var body: some View {
        ZStack {
            if !showNew, let card = removingCard {
                content()
                    .cardTransition(isRemoving: true)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showNew = true
                        }
                    }
            }
            
            if showNew, let card = newCard {
                content()
                    .cardScalePop()
            }
        }
    }
}

// MARK: - Bounce Effect for Card (on purchase feedback)

struct CardBounceModifier: ViewModifier {
    @State private var bounceOffset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(y: bounceOffset)
            .onAppear {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    bounceOffset = -10
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        bounceOffset = 0
                    }
                }
            }
    }
}

extension View {
    func cardBounce() -> some View {
        modifier(CardBounceModifier())
    }
}

// MARK: - Glow Pulse on Card (highlight affordable cards)

struct CardGlowPulseModifier: ViewModifier {
    let color: Color
    @State private var isGlowing = false
    
    func body(content: Content) -> some View {
        content
            .shadow(color: isGlowing ? color : .clear, radius: isGlowing ? 8 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isGlowing = true
                }
            }
    }
}

extension View {
    func cardGlowPulse(_ color: Color = .green) -> some View {
        modifier(CardGlowPulseModifier(color: color))
    }
}
