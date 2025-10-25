//
//  Mathematician.swift
//  Primedor
//
//  Represents a famous mathematician that visits players who meet requirements
//

import Foundation

/// A mathematician card worth 3 points, acquired automatically when requirements are met
struct Mathematician: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let specialty: String  // Brief description of their work
    
    /// Required bonuses to attract this mathematician
    /// e.g., [.prime: 4, .square: 4] means need 4 prime bonuses and 4 square bonuses
    let requirements: [TokenType: Int]
    
    /// All mathematicians are worth 3 points (matching Splendor nobles)
    let points: Int = 3
    
    init(name: String, specialty: String, requirements: [TokenType: Int]) {
        self.id = UUID()
        self.name = name
        self.specialty = specialty
        self.requirements = requirements
    }
    
    /// For testing - create mathematician with specific ID
    init(id: UUID = UUID(), name: String, specialty: String, requirements: [TokenType: Int]) {
        self.id = id
        self.name = name
        self.specialty = specialty
        self.requirements = requirements
    }
    
    /// Check if a player's bonuses meet this mathematician's requirements
    func canBeAcquiredBy(bonuses: [TokenType: Int]) -> Bool {
        for (tokenType, required) in requirements {
            let playerHas = bonuses[tokenType] ?? 0
            if playerHas < required {
                return false
            }
        }
        return true
    }
    
    static let allMathematicians: [Mathematician] = [
        Mathematician(name: "Euclid", specialty: "Geometry", requirements: [.prime: 3, .even: 3, .odd: 3]),
        Mathematician(name: "Pythagoras", specialty: "Theorem", requirements: [.square: 4, .prime: 4]),
        Mathematician(name: "Fibonacci", specialty: "Sequences", requirements: [.sequence: 4, .odd: 4]),
        Mathematician(name: "Euler", specialty: "Analysis", requirements: [.even: 4, .sequence: 4]),
        Mathematician(name: "Gauss", specialty: "Number Theory", requirements: [.prime: 4, .square: 4]),
        Mathematician(name: "Fermat", specialty: "Primes", requirements: [.prime: 3, .even: 3, .square: 3]),
        Mathematician(name: "Riemann", specialty: "Hypothesis", requirements: [.even: 3, .odd: 3, .sequence: 3]),
        Mathematician(name: "Turing", specialty: "Computing", requirements: [.square: 3, .sequence: 3, .prime: 3]),
        Mathematician(name: "Ramanujan", specialty: "Partitions", requirements: [.odd: 3, .even: 3, .sequence: 3]),
        Mathematician(name: "Cantor", specialty: "Set Theory", requirements: [.prime: 3, .odd: 3, .square: 3])
    ]
}
