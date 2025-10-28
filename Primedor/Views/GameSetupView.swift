import SwiftUI

struct GameSetupView: View {
    @StateObject private var playerConfig = PlayerConfigurationManager(playerCount: 2)
    @State private var showGame: Bool = false
    @State private var gameID = UUID()
    @State private var playerCount: Int = 2
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("PRIMEDOR")
                    .font(.system(size: 48, weight: .bold))
                    .padding(.bottom, 4)
                
                // Player count selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Number of Players")
                        .font(.headline)
                        .font(.system(size: 14))
                    
                    Picker("Players", selection: $playerCount) {
                        Text("2 Players").tag(2)
                        Text("3 Players").tag(3)
                        Text("4 Players").tag(4)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: playerCount) { oldValue, newValue in
                        playerConfig.resetToDefault(playerCount: newValue)
                    }
                }
                .padding(.horizontal)
                
                // Player configuration list - compact
                VStack(alignment: .leading, spacing: 8) {
                    Text("Configure Players")
                        .font(.headline)
                        .font(.system(size: 14))
                    
                    VStack(spacing: 8) {
                        ForEach(0..<playerConfig.playerConfigs.count, id: \.self) { index in
                            PlayerConfigRow(
                                config: $playerConfig.playerConfigs[index],
                                playerNumber: index + 1
                            )
                        }
                    }
                    .padding(8)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Start Game button
                Button("Start Game") {
                    gameID = UUID()
                    showGame = true
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // How to Play link
                NavigationLink("How to Play") {
                    InstructionsView()
                }
                .buttonStyle(.bordered)
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .padding()
            .navigationDestination(isPresented: $showGame) {
                SimpleGameView(players: playerConfig.createPlayers())
                    .id(gameID)
            }
        }
    }
}

/// Individual row for configuring a single player - compact design
struct PlayerConfigRow: View {
    @Binding var config: PlayerConfig
    let playerNumber: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Text("P\(playerNumber)")
                .font(.system(size: 12, weight: .semibold))
                .frame(width: 28, alignment: .center)
            
            // Human / CPU toggle
            Picker("Type", selection: $config.isAI) {
                Text("H").tag(false)
                Text("C").tag(true)
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 90)
            .font(.system(size: 12))
            
            // Name input (only for human players)
            if !config.isAI {
                TextField("Name", text: $config.name)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1)
                    .font(.system(size: 12))
            } else {
                Text(config.name)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
}

#Preview {
    GameSetupView()
}
