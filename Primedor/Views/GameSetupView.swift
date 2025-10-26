import SwiftUI

struct GameSetupView: View {
    @State private var playerCount: Int = 2
    @State private var showGame: Bool = false
    @State private var gameID = UUID() // Add this to force new game instances
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Text("PRIMEDOR")
                    .font(.system(size: 48, weight: .bold))
                
                Picker("Players", selection: $playerCount) {
                    Text("2 Players").tag(2)
                    Text("3 Players").tag(3)
                    Text("4 Players").tag(4)
                }
                .pickerStyle(.segmented)
                .padding()
                
                Button("Start Game") {
                    gameID = UUID() // Generate new ID for new game
                    showGame = true
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
                
                NavigationLink("How to Play") {
                    InstructionsView()
                }
                .buttonStyle(.bordered)
                .font(.title3)
            }
            .padding()
            .navigationDestination(isPresented: $showGame) {
                SimpleGameView(playerCount: playerCount)
                    .id(gameID) // Force new instance with new ID
            }
        }
    }
}
