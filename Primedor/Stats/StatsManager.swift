import Foundation
import Combine

class StatsManager: ObservableObject {
    static let shared = StatsManager()
    
    @Published var allStats: [String: [Int: PlayerStats]] = [:]
    
    private let statsKey = "primedor_player_stats"
    
    init() {
        loadStats()
    }
    
    // MARK: - Load/Save
    
    private func loadStats() {
        if let data = UserDefaults.standard.data(forKey: statsKey),
           let decoded = try? JSONDecoder().decode([String: [Int: PlayerStats]].self, from: data) {
            self.allStats = decoded
        }
    }
    
    private func saveStats() {
        if let encoded = try? JSONEncoder().encode(allStats) {
            UserDefaults.standard.set(encoded, forKey: statsKey)
        }
    }
    
    // MARK: - Get Stats
    
    func getStats(playerName: String, playerCount: Int) -> PlayerStats? {
        return allStats[playerName]?[playerCount]
    }
    
    func getAllStats(playerName: String) -> [Int: PlayerStats] {
        return allStats[playerName] ?? [:]
    }
    
    // MARK: - Record Game
    
    func recordGame(playerName: String, playerCount: Int, won: Bool, finalScore: Int) {
        if allStats[playerName] == nil {
            allStats[playerName] = [:]
        }
        
        if allStats[playerName]?[playerCount] == nil {
            allStats[playerName]?[playerCount] = PlayerStats(
                playerName: playerName,
                playerCount: playerCount
            )
        }
        
        allStats[playerName]?[playerCount]?.recordGame(won: won, finalScore: finalScore)
        saveStats()
    }
    
    // MARK: - Reset Stats
    
    func resetStats(playerName: String, playerCount: Int) {
        allStats[playerName]?[playerCount]?.reset()
        saveStats()
    }
    
    func resetAllStats(playerName: String) {
        allStats[playerName] = [:]
        saveStats()
    }
}
