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
    
    static let allMathematicians: [Mathematician] = twoCombinations() + threeCombinations()
        
        // --- 4-4 Combinations (Two Colors Required) ---
        // Each requires exactly 4 of two different resource types
        static func twoCombinations() -> [Mathematician] {
            return [
                // 1. Sequence + Even (4+4)
                Mathematician(
                    name: "Alan Turing",
                    specialty: "Computing",
                    requirements: [.sequence: 4, .even: 4]
                ),
                
                // 2. Even + Green (4+4)
                Mathematician(
                    name: "Carl F. Gauss",
                    specialty: "Number Theory",
                    requirements: [.even: 4, .odd: 4]
                ),
                
                // 3. Green + Prime (4+4)
                Mathematician(
                    name: "Sophie Germain",
                    specialty: "Number Theory",
                    requirements: [.odd: 4, .prime: 4]
                ),
                
                // 4. Prime + Black (4+4)
                Mathematician(
                    name: "Pythagoras",
                    specialty: "Theorem",
                    requirements: [.prime: 4, .square: 4]
                ),
                
                // 5. Sequence + Black (4+4)
                Mathematician(
                    name: "Srinivasa Ramanujan",
                    specialty: "Partitions",
                    requirements: [.sequence: 4, .square: 4]
                )
            ]
        }
        
        // --- 3-3-3 Combinations (Three Colors Required) ---
        // Each requires exactly 3 of three different resource types
        static func threeCombinations() -> [Mathematician] {
            return [
                // 6. Sequence + Even + Green (3+3+3)
                Mathematician(
                    name: "Rene Descartes",
                    specialty: "Geometry",
                    requirements: [.sequence: 3, .even: 3, .odd: 3]
                ),
                
                // 7. Sequence + Green + Prime (3+3+3)
                Mathematician(
                    name: "Hypatia",
                    specialty: "Astronomy",
                    requirements: [.sequence: 3, .odd: 3, .prime: 3]
                ),
                
                // 8. Sequence + Even + Black (3+3+3)
                Mathematician(
                    name: "G. W. Leibniz",
                    specialty: "Calculus",
                    requirements: [.sequence: 3, .even: 3, .square: 3]
                ),
                
                // 9. Green + Prime + Black (3+3+3)
                Mathematician(
                    name: "Emmy Noether",
                    specialty: "Abstract Algebra",
                    requirements: [.odd: 3, .prime: 3, .square: 3]
                ),
                
                // 10. Even + Green + Black (3+3+3)
                Mathematician(
                    name: "Archimedes",
                    specialty: "Mechanics",
                    requirements: [.even: 3, .odd: 3, .square: 3]
                )
            ]
        }
}
