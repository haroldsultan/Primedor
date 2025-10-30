import SwiftUI

struct NobleView: View {
    let mathematician: Mathematician
    let canClaim: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Points - always 3
            Text("3")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.purple)
                .padding(.bottom, 2)
            
            // Name
            Text(mathematician.name)
                .font(.system(size: 7))
                .lineLimit(1)
                .padding(.bottom, 2)
            
            // Requirements - horizontal with numbers inside
            HStack(spacing: 2) {
                ForEach(mathematician.requirements.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { type, count in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(colorFor(type))
                        .frame(width: 14, height: 14)
                        .overlay(
                            Text("\(count)")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(.white)
                        )
                }
            }
        }
        .padding(3)
        .frame(width: 75, height: 55)
        .background(canClaim ? Color.purple.opacity(0.3) : Color.purple.opacity(0.1))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(canClaim ? Color.purple : Color.clear, lineWidth: 2)
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
