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
            // --- 4-4 Combinations (Two Colors Required) ---
            
            // 1. Original: 4 White, 4 Blue -> Sequence, Even
            Mathematician(name: "Alan Turing", specialty: "Computing", requirements: [.sequence: 4, .even: 4]),
            
            // 2. Original: 4 White, 4 Black -> Sequence, Square
            Mathematician(name: "Carl F. Gauss", specialty: "Number Theory", requirements: [.sequence: 4, .square: 4]),
            
            // 3. Original: 4 White, 4 Red -> Sequence, Prime
            Mathematician(name: "Sophie Germain", specialty: "Number Theory", requirements: [.sequence: 4, .prime: 4]),
            
            // 4. Original: 4 Blue, 4 Red -> Even, Prime
            Mathematician(name: "Pythagoras", specialty: "Theorem", requirements: [.even: 4, .prime: 4]),
            
            // 5. Original: 4 Green, 4 Red -> Odd, Prime
            Mathematician(name: "Srinivasa Ramanujan", specialty: "Partitions", requirements: [.odd: 4, .prime: 4]),
            
            // --- 3-3-3 Combinations (Three Colors Required) ---
            
            // 6. Original: 3 White, 3 Blue, 3 Green -> Sequence, Even, Odd
            Mathematician(name: "Rene Descartes", specialty: "Geometry", requirements: [.sequence: 3, .even: 3, .odd: 3]),
            
            // 7. Original: 3 White, 3 Green, 3 Black -> Sequence, Odd, Square
            Mathematician(name: "Hypatia", specialty: "Astronomy", requirements: [.sequence: 3, .odd: 3, .square: 3]),
            
            // 8. Original: 3 Blue, 3 Green, 3 Red -> Even, Odd, Prime
            Mathematician(name: "G. W. Leibniz", specialty: "Calculus", requirements: [.even: 3, .odd: 3, .prime: 3]),
            
            // 9. Original: 3 Green, 3 Red, 3 Black -> Odd, Prime, Square
            Mathematician(name: "Emmy Noether", specialty: "Abstract Algebra", requirements: [.odd: 3, .prime: 3, .square: 3]),
            
            // 10. Original: 3 Blue, 3 Red, 3 Black -> Even, Prime, Square
            Mathematician(name: "Archimedes", specialty: "Mechanics", requirements: [.even: 3, .prime: 3, .square: 3])
        ]
}
