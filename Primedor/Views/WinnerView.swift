import SwiftUI

struct WinnerView: View {
    let winner: Player
    let allPlayers: [Player]
    let onDismiss: () -> Void
    
    var sortedPlayers: [Player] {
        return allPlayers.sorted { (player1: Player, player2: Player) -> Bool in
            if player1.victoryPoints == player2.victoryPoints {
                return player1.purchasedCards.count < player2.purchasedCards.count
            }
            return player1.victoryPoints > player2.victoryPoints
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 Game Over! 🎉")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("\(winner.name) Wins!")
                .font(.title)
                .foregroundColor(.blue)
            
            Text("\(winner.victoryPoints) Points")
                .font(.title2)
            
            // Final standings
            VStack(alignment: .leading, spacing: 8) {
                Text("Final Standings:")
                    .font(.headline)
                
                ForEach(sortedPlayers) { player in
                    HStack {
                        Text(player.name)
                            .fontWeight(player.id == winner.id ? .bold : .regular)
                        Spacer()
                        Text("\(player.victoryPoints)pts")
                        Text("(\(player.purchasedCards.count) cards)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Button("New Game") {
                onDismiss()
            }
            .buttonStyle(.borderedProminent)
            .font(.title2)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(40)
    }
}
