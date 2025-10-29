import SwiftUI

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
        withAnimation(.easeOut(duration: 0.3)) {
            scale = 1.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
    let shouldShowBadge: Bool
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    @State private var showBadge: Bool = false
    
    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    scale = 1.0
                    opacity = 1.0
                }
            
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
        .onChange(of: shouldShowBadge) { oldValue, newValue in
            if newValue {
                startBounceAnimation()
            }
        }
    }
    
    private func startBounceAnimation() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
            scale = 1.15
            opacity = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeIn(duration: 0.2)) {
                showBadge = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                showBadge = false
            }
        }
    }
}

extension View {
    func cardArrival(shouldShowBadge: Bool) -> some View {
        modifier(CardArrivalModifier(shouldShowBadge: shouldShowBadge))
    }
}
