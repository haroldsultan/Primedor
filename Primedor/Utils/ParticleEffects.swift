import SwiftUI

// MARK: - Particle Effect for Celebrations

struct ParticleEffect: View {
    let type: ParticleType
    @State private var particles: [Particle] = []
    @State private var soundPlayed = false
    
    enum ParticleType {
        case tokens       // Colored circles for token collection
        case stars        // Stars for card purchase
        case sparkles     // White sparkles for winning
        case coins        // Coin emojis for victory points
    }
    
    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var opacity: Double
        var rotation: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    particleView(for: type)
                        .scaleEffect(particle.scale)
                        .opacity(particle.opacity)
                        .rotationEffect(.degrees(particle.rotation))
                        .position(x: particle.x, y: particle.y)
                }
            }
            .onAppear {
                playAnimationSound()
                createParticles(in: geometry.size)
            }
        }
    }
    
    @ViewBuilder
    private func particleView(for type: ParticleType) -> some View {
        switch type {
        case .tokens:
            Circle()
                .fill(Color.blue)
                .frame(width: 16, height: 16)
        case .stars:
            Text("⭐️")
                .font(.system(size: 20))
        case .sparkles:
            Circle()
                .fill(Color.yellow)
                .frame(width: 8, height: 8)
        case .coins:
            Text("💰")
                .font(.system(size: 24))
        }
    }
    
    private func playAnimationSound() {
        guard !soundPlayed else { return }
        soundPlayed = true
        
        switch type {
        case .tokens:
            SoundManager.shared.playTokenCollectSound()
        case .stars:
            SoundManager.shared.playCardBuySound()
        case .sparkles:
            SoundManager.shared.playGameWinSound()
        case .coins:
            SoundManager.shared.playNobleClaimSound()
        }
    }
    
    private func createParticles(in size: CGSize) {
        let count = 15
        
        for i in 0..<count {
            let delay = Double(i) * 0.05
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeOut(duration: 1.5)) {
                    let particle = Particle(
                        x: CGFloat.random(in: 0...size.width),
                        y: size.height + 50,
                        scale: CGFloat.random(in: 0.5...1.5),
                        opacity: 1.0,
                        rotation: Double.random(in: 0...360)
                    )
                    particles.append(particle)
                    
                    // Animate upward
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeOut(duration: 1.5)) {
                            if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                                particles[index].y = -50
                                particles[index].opacity = 0
                                particles[index].rotation += 360
                            }
                        }
                    }
                }
            }
        }
        
        // Clean up after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            particles.removeAll()
        }
    }
}

// MARK: - Pulse Animation Modifier

struct PulseModifier: ViewModifier {
    @State private var isPulsing = false
    let color: Color
    let count: Int
    @State private var soundPlayed = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: isPulsing ? 0 : 3)
                    .scaleEffect(isPulsing ? 1.5 : 1.0)
                    .opacity(isPulsing ? 0 : 1)
            )
            .onAppear {
                if !soundPlayed {
                    soundPlayed = true
                    SoundManager.shared.playCardReserveSound()
                }
                withAnimation(.easeOut(duration: 0.6).repeatCount(count, autoreverses: false)) {
                    isPulsing = true
                }
            }
    }
}

extension View {
    func pulseEffect(color: Color = .red, count: Int = 3) -> some View {
        modifier(PulseModifier(color: color, count: count))
    }
}

// MARK: - Shake Animation Modifier

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

extension View {
    func shake(trigger: Int) -> some View {
        modifier(ShakeEffect(animatableData: CGFloat(trigger)))
    }
}

// MARK: - Flash Screen Effect

struct FlashOverlay: View {
    let color: Color
    @State private var opacity: Double = 0.0
    @State private var soundPlayed = false
    
    var body: some View {
        color
            .opacity(opacity)
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .onAppear {
                if !soundPlayed {
                    soundPlayed = true
                    SoundManager.shared.playGameWinSound()
                }
                withAnimation(.easeIn(duration: 0.1)) {
                    opacity = 0.3
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        opacity = 0.0
                    }
                }
            }
    }
}

// MARK: - Glow Effect

struct GlowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    @State private var isGlowing = false
    
    func body(content: Content) -> some View {
        content
            .shadow(color: isGlowing ? color : .clear, radius: isGlowing ? radius : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    isGlowing = true
                }
            }
    }
}

extension View {
    func glow(color: Color = .yellow, radius: CGFloat = 10) -> some View {
        modifier(GlowModifier(color: color, radius: radius))
    }
}

// MARK: - Bounce Animation

struct BounceModifier: ViewModifier {
    @State private var scale: CGFloat = 0.0
    @State private var soundPlayed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                if !soundPlayed {
                    soundPlayed = true
                    SoundManager.shared.playTokenCollectSound()
                }
                withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                    scale = 1.0
                }
            }
    }
}

extension View {
    func bounceIn() -> some View {
        modifier(BounceModifier())
    }
}

// MARK: - Scale Pop Animation

struct ScalePopModifier: ViewModifier {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var soundPlayed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                if !soundPlayed {
                    soundPlayed = true
                    SoundManager.shared.playCardBuySound()
                }
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
    }
}

extension View {
    func scalePop() -> some View {
        modifier(ScalePopModifier())
    }
}
