import Foundation
import Combine

/// Represents a player before the game starts
struct PlayerConfig {
    var isAI: Bool
    var name: String
}

/// Container for all player configurations for a game session
class PlayerConfigurationManager: ObservableObject {
    @Published var playerConfigs: [PlayerConfig] = []
    
    init(playerCount: Int = 2) {
        resetToDefault(playerCount: playerCount)
    }
    
    func resetToDefault(playerCount: Int) {
        let validCount = max(2, min(playerCount, 4))
        let defaultNames = ["Emma", "Abby", "Bob", "Ann"]
        
        playerConfigs = Array(0..<validCount).map { index in
            return PlayerConfig(isAI: false, name: defaultNames[index])
        }
    }
    
    /// Convert configurations to actual Player objects for the game
    func createPlayers() -> [Player] {
        return playerConfigs.map { config in
            Player(name: config.name, isAI: config.isAI)
        }
    }
}
