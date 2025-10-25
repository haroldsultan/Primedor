import Foundation

struct WinCondition {
    // Check if someone has won (15+ points)
    static func checkWinner(players: [Player], currentPlayerIndex: Int) -> Player? {
        guard !players.isEmpty else { return nil }
        guard currentPlayerIndex >= 0 && currentPlayerIndex < players.count else { return nil }
        
        // Find all players with 15+ points
        let qualifiedPlayers = players.filter { $0.victoryPoints >= 15 }
        
        guard !qualifiedPlayers.isEmpty else { return nil }
        
        // If current player is the last player, the round is complete
        if currentPlayerIndex == players.count - 1 {
            return determineWinner(from: qualifiedPlayers)
        }
        
        // Round not finished yet
        return nil
    }
    
    // Determine winner with tie-breaking rules
    private static func determineWinner(from players: [Player]) -> Player? {
        guard !players.isEmpty else { return nil }
        
        // Sort by: highest points first, then fewest cards (tie-breaker)
        let sorted = players.sorted { p1, p2 in
            if p1.victoryPoints != p2.victoryPoints {
                return p1.victoryPoints > p2.victoryPoints
            }
            // Tie-breaker: fewer cards wins
            return p1.purchasedCards.count < p2.purchasedCards.count
        }
        
        return sorted.first
    }
}
