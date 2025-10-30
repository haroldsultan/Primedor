import SwiftUI

struct StatsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var statsManager = StatsManager.shared
    
    let playerName: String
    @State private var selectedPlayerCount = 2
    @State private var showResetConfirm = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Back") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    Text("\(playerName)'s Stats")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button("Reset") {
                        showResetConfirm = true
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
                .padding()
                
                // Player count tabs
                Picker("Player Count", selection: $selectedPlayerCount) {
                    Text("2-Player").tag(2)
                    Text("3-Player").tag(3)
                    Text("4-Player").tag(4)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Stats display
                if let stats = statsManager.getStats(playerName: playerName, playerCount: selectedPlayerCount) {
                    ScrollView {
                        VStack(spacing: 16) {
                            StatCard(title: "Games Played", value: "\(stats.totalGamesPlayed)")
                            StatCard(title: "Games Won", value: "\(stats.gamesWon)")
                            StatCard(title: "Games Lost", value: "\(stats.gamesLost)")
                            StatCard(title: "Win Rate", value: String(format: "%.1f%%", stats.winRate))
                            StatCard(title: "Average Score", value: String(format: "%.1f", stats.averageFinalScore))
                            StatCard(title: "Longest Win Streak", value: "\(stats.longestWinStreak)")
                        }
                        .padding()
                    }
                } else {
                    VStack(spacing: 12) {
                        Text("No stats yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Play some games to see stats!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                    .frame(maxWidth: .infinity)
                }
            }
            .confirmationDialog("Reset Stats?", isPresented: $showResetConfirm) {
                Button("Reset All Stats", role: .destructive) {
                    statsManager.resetAllStats(playerName: playerName)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will clear all stats for \(playerName) across all player counts. This cannot be undone.")
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    StatsView(playerName: "Emma")
}
