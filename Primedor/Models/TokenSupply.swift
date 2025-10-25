//
//  TokenSupply.swift
//  Primedor
//
//  Manages the central supply of tokens available for players to take
//

import Foundation

/// Manages the token supply pile and validates token transactions
class TokenSupply {
    private(set) var tokens: [TokenType: [Token]]
    let configuration: TokenConfiguration
    
    init(playerCount: Int) {
        self.configuration = TokenConfiguration.configuration(for: playerCount)
        self.tokens = [:]
        
        // Initialize standard tokens
        for tokenType in TokenType.standard {
            var tokenArray: [Token] = []
            for _ in 0..<configuration.standardTokensPerType {
                tokenArray.append(Token(type: tokenType))
            }
            tokens[tokenType] = tokenArray
        }
        
        // Initialize gold tokens
        var goldArray: [Token] = []
        for _ in 0..<configuration.goldTokens {
            goldArray.append(Token(type: .perfect))
        }
        tokens[.perfect] = goldArray
    }
    
    /// Get the count of available tokens for a specific type
    func count(of type: TokenType) -> Int {
        return tokens[type]?.count ?? 0
    }
    
    /// Check if taking tokens is valid (basic validation)
    func canTake(_ type: TokenType, count: Int) -> Bool {
        return self.count(of: type) >= count
    }
    
    /// Take tokens from the supply (doesn't validate game rules, just removes tokens)
    func take(_ type: TokenType, count: Int) -> [Token]? {
        guard canTake(type, count: count) else { return nil }
        
        var taken: [Token] = []
        for _ in 0..<count {
            if let token = tokens[type]?.popLast() {
                taken.append(token)
            }
        }
        return taken
    }
    
    /// Return tokens to the supply
    func returnTokens(_ tokensToReturn: [Token]) {
        for token in tokensToReturn {
            if tokens[token.type] == nil {
                tokens[token.type] = []
            }
            tokens[token.type]?.append(token)
        }
    }
    
    /// Total number of tokens currently in supply
    var totalTokenCount: Int {
        return tokens.values.reduce(0) { $0 + $1.count }
    }
    
    /// Check if supply has at least 4 tokens of a given type (needed for "take 2" action)
    func hasAtLeastFour(of type: TokenType) -> Bool {
        return count(of: type) >= 4
    }
}
