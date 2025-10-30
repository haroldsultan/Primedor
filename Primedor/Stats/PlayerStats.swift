import Foundation

struct PlayerStats: Codable {
    var playerName: String
    var playerCount: Int // 2, 3, or 4 players
    var gamesWon: Int = 0
    var gamesLost: Int = 0
    var totalGamesPlayed: Int = 0
    var averageFinalScore: Double = 0.0
    var longestWinStreak: Int = 0
    var currentWinStreak: Int = 0
    
    var winRate: Double {
        guard totalGamesPlayed > 0 else { return 0.0 }
        return Double(gamesWon) / Double(totalGamesPlayed) * 100
    }
    
    mutating func recordGame(won: Bool, finalScore: Int) {
        if won {
            gamesWon += 1
            currentWinStreak += 1
            longestWinStreak = max(longestWinStreak, currentWinStreak)
        } else {
            gamesLost += 1
            currentWinStreak = 0
        }
        
        totalGamesPlayed += 1
        
        // Update average score
        let totalScore = averageFinalScore * Double(totalGamesPlayed - 1) + Double(finalScore)
        averageFinalScore = totalScore / Double(totalGamesPlayed)
    }
    
    mutating func reset() {
        gamesWon = 0
        gamesLost = 0
        totalGamesPlayed = 0
        averageFinalScore = 0.0
        longestWinStreak = 0
        currentWinStreak = 0
    }
}
