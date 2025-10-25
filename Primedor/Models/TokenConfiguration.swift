//
//  TokenConfiguration.swift
//  Primedor
//
//  Configuration for token counts based on number of players
//

import Foundation

/// Configuration for token supply based on player count (matching Splendor rules)
struct TokenConfiguration {
    let playerCount: Int
    let standardTokensPerType: Int  // Primes, Evens, Odds, Squares, Sequences
    let goldTokens: Int              // Perfect Numbers (wild)
    
    /// Get the appropriate configuration for a given player count
    static func configuration(for playerCount: Int) -> TokenConfiguration {
        switch playerCount {
        case 2:
            return TokenConfiguration(playerCount: 2, standardTokensPerType: 4, goldTokens: 5)
        case 3:
            return TokenConfiguration(playerCount: 3, standardTokensPerType: 5, goldTokens: 5)
        case 4:
            return TokenConfiguration(playerCount: 4, standardTokensPerType: 7, goldTokens: 5)
        default:
            fatalError("Invalid player count: \(playerCount). Must be 2-4 players.")
        }
    }
    
    /// Validate player count is within allowed range
    static func isValidPlayerCount(_ count: Int) -> Bool {
        return count >= 2 && count <= 4
    }
    
    /// Total number of standard (non-gold) tokens in this configuration
    var totalStandardTokens: Int {
        return standardTokensPerType * TokenType.standard.count
    }
    
    /// Total number of all tokens in this configuration
    var totalTokens: Int {
        return totalStandardTokens + goldTokens
    }
}
