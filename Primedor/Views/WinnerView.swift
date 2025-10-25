import SwiftUI

struct WinnerView: View {
    let winner: Player
    let allPlayers: [Player]
    let onNewGame: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 Victory! 🎉")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("\(winner.name) Wins!")
                .font(.title)
                .foregroundColor(.blue)
            
            Text("\(winner.victoryPoints) Points")
                .font(.title2)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Final Scores")
                    .font(.headline)
                
                ForEach(allPlayers.sorted(by: { $0.victoryPoints > $1.victoryPoints })) { player in
                    HStack {
                        Text(player.name)
                            .fontWeight(player.id == winner.id ? .bold : .regular)
                        Spacer()
                        Text("\(player.victoryPoints) pts")
                        Text("(\(player.purchasedCards.count) cards)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(player.id == winner.id ? .blue : .primary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .padding(40)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}
