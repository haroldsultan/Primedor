import SwiftUI

struct TurnTokensView: View {
    let collectedTypes: [TokenType: Int]
    let onReturn: (TokenType) -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text("This Turn:")
                .font(.system(size: 10))
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            ForEach(Array(collectedTypes.keys.sorted(by: { $0.rawValue < $1.rawValue })), id: \.self) { type in
                if let count = collectedTypes[type], count > 0 {
                    Button {
                        onReturn(type)
                    } label: {
                        HStack(spacing: 2) {
                            Circle()
                                .fill(colorFor(type))
                                .frame(width: 16, height: 16)
                            Text("\(count)")
                                .font(.system(size: 10))
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(4)
                    }
                }
            }
            
            if collectedTypes.isEmpty {
                Text("No tokens collected")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .background(Color.gray.opacity(0.1))
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
