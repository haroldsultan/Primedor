import SwiftUI

struct HeaderView: View {
    let currentPlayer: Player
    let tokensCollectedThisTurn: Int
    let isAIThinking: Bool
    let onEndTurn: () -> Void
    
    var body: some View {
        HStack {
            Text(currentPlayer.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(currentPlayer.isAI ? Color.orange : Color.blue)
                .cornerRadius(8)
            
            if isAIThinking {
                Text("🤔")
                    .font(.caption)
            } else {
                Text("T:\(tokensCollectedThisTurn)")
                    .font(.caption)
            }
            
            Spacer()
            
            Button("End Turn") {
                onEndTurn()
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .disabled(currentPlayer.isAI)
        }
        .padding(.horizontal)
    }
}
