import SwiftUI

// MARK: - Card Journey Animation (Card travels to player)

struct CardJourneyModifier: ViewModifier {
    let isAnimating: Bool
    let startFrame: CGRect
    let endFrame: CGRect
    
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    func body(content: Content) -> some View {
        content
            .offset(offset)
            .scaleEffect(scale)
            .opacity(opacity)
            .onChange(of: isAnimating) { oldValue, newValue in
                if newValue {
                    startAnimation()
                }
            }
    }
    
    private func startAnimation() {
        let deltaX = endFrame.midX - startFrame.midX
        let deltaY = endFrame.midY - startFrame.midY
        
        withAnimation(.easeInOut(duration: 0.7)) {
            offset = CGSize(width: deltaX, height: deltaY)
            scale = 0.3
            opacity = 0
        }
    }
}

extension View {
    func cardJourney(isAnimating: Bool, from startFrame: CGRect, to endFrame: CGRect) -> some View {
        modifier(CardJourneyModifier(isAnimating: isAnimating, startFrame: startFrame, endFrame: endFrame))
    }
}

// MARK: - Card Arrive Animation (New card slides in from deck)

struct CardArriveModifier: ViewModifier {
    let shouldAppear: Bool
    
    @State private var offset: CGOffset = .init(x: -100, y: 0)
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    
    func body(content: Content) -> some View {
        content
            .offset(x: offset.x, y: offset.y)
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                if shouldAppear {
                    startAnimation()
                }
            }
    }
    
    private func startAnimation() {
        withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
            offset = .init(x: 0, y: 0)
            opacity = 1
            scale = 1.0
        }
    }
}

struct CGOffset {
    var x: CGFloat = 0
    var y: CGFloat = 0
}

extension View {
    func cardArrive(shouldAppear: Bool) -> some View {
        modifier(CardArriveModifier(shouldAppear: shouldAppear))
    }
}


// MARK: - Card Departure Animation (Pulse → Shrink → Disappear)

struct CardDepartureModifier: ViewModifier {
    let isAnimating: Bool
    
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
            .onChange(of: isAnimating) { oldValue, newValue in
                if newValue {
                    startAnimation()
                }
            }
    }
    
    private func startAnimation() {
        // Step 1: Pulse (grow slightly)
        withAnimation(.easeOut(duration: 0.2)) {
            scale = 1.15
        }
        
        // Step 2: Shrink to nothing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeIn(duration: 0.4)) {
                scale = 0
                opacity = 0
            }
        }
    }
}

extension View {
    func cardDeparture(isAnimating: Bool) -> some View {
        modifier(CardDepartureModifier(isAnimating: isAnimating))
    }
}

// MARK: - Card Arrival Animation (Bounce + NEW Badge)

struct CardArrivalModifier: ViewModifier {
    let shouldAppear: Bool
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var showBadge: Bool = false
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    if shouldAppear {
                        startAnimation()
                    }
                }
            
            // NEW badge
            if showBadge {
                Text("NEW")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.green)
                    .cornerRadius(4)
                    .offset(x: -4, y: 4)
                    .transition(.scale)
            }
        }
    }
    
    private func startAnimation() {
        // Bounce in with spring
        withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Show badge after card bounces in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeIn(duration: 0.2)) {
                showBadge = true
            }
        }
        
        // Hide badge after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(.easeOut(duration: 0.3)) {
                showBadge = false
            }
        }
    }
}

extension View {
    func cardArrival(shouldAppear: Bool) -> some View {
        modifier(CardArrivalModifier(shouldAppear: shouldAppear))
    }
}
