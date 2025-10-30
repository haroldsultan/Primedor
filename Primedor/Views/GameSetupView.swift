import SwiftUI

struct GameSetupView: View {
    @StateObject private var playerConfig = PlayerConfigurationManager(playerCount: 2)
    @StateObject private var gameSettings = GameSettings.shared
    @StateObject private var speedManager = GameSpeedManager.shared
    @State private var showGame: Bool = false
    @State private var gameID = UUID()
    @State private var playerCount: Int = 2
    @State private var showAudioSettings = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Header with settings button
                HStack {
                    Text("PRIMEDOR")
                        .font(.system(size: 48, weight: .bold))
                    
                    Spacer()
                    
                    if let humanPlayer = playerConfig.playerConfigs.first(where: { !$0.isAI }) {
                        NavigationLink(destination: StatsView(playerName: humanPlayer.name)) {
                            Image(systemName: "chart.bar.fill")
                                .font(.title2)
                        }
                    }
                    
                    Button(action: { showAudioSettings = true }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title2)
                    }
                    .sheet(isPresented: $showAudioSettings) {
                        AudioSettingsView()
                    }
                }
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
                
                // Game Speed selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Game Speed")
                        .font(.headline)
                        .font(.system(size: 14))
                    
                    Picker("Speed", selection: $speedManager.currentSpeed) {
                        Text("Slow").tag(GameSpeed.slow)
                        Text("Normal").tag(GameSpeed.normal)
                        Text("Fast").tag(GameSpeed.fast)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Start Game button
                Button("Start Game") {
                    SoundManager.shared.playButtonClickSound()
                    gameID = UUID()
                    showGame = true
                    SoundManager.shared.startBackgroundMusic()
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
            .onAppear {
                SoundManager.shared.startBackgroundMusic()
            }
        }
    }
}

/// Individual row for configuring a single player - expanded layout with more space
struct PlayerConfigRow: View {
    @Binding var config: PlayerConfig
    let playerNumber: Int
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text("P\(playerNumber)")
                    .font(.system(size: 12, weight: .semibold))
                    .frame(width: 28, alignment: .center)
                
                // Human / CPU toggle - full width
                Picker("Type", selection: $config.isAI) {
                    Text("Human").tag(false)
                    Text("AI").tag(true)
                }
                .pickerStyle(.segmented)
                .font(.system(size: 12))
                
                Spacer()
            }
            
            // Name input - always editable
            TextField("Player Name", text: $config.name)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1)
                .font(.system(size: 12))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
}

// MARK: - Audio Settings View

struct AudioSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var gameSettings = GameSettings.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Background Music")) {
                    Toggle("Enable Music", isOn: $gameSettings.isBackgroundMusicEnabled)
                    
                    if gameSettings.isBackgroundMusicEnabled {
                        HStack {
                            Text("Volume")
                                .foregroundColor(.secondary)
                            Slider(value: $gameSettings.musicVolume, in: 0...1, step: 0.1)
                            Text("\(Int(gameSettings.musicVolume * 100))%")
                                .foregroundColor(.secondary)
                                .frame(width: 45, alignment: .trailing)
                        }
                    }
                }
                
                Section(header: Text("Sound Effects")) {
                    Toggle("Enable Sound Effects", isOn: $gameSettings.areSoundEffectsEnabled)
                    
                    if gameSettings.areSoundEffectsEnabled {
                        HStack {
                            Text("Volume")
                                .foregroundColor(.secondary)
                            Slider(value: $gameSettings.sfxVolume, in: 0...1, step: 0.1)
                            Text("\(Int(gameSettings.sfxVolume * 100))%")
                                .foregroundColor(.secondary)
                                .frame(width: 45, alignment: .trailing)
                        }
                        
                        Button(action: {
                            SoundManager.shared.playButtonClickSound()
                        }) {
                            Text("Test Sound")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .navigationTitle("Audio Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    GameSetupView()
}
