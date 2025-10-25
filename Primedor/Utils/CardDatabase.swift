import Foundation

struct CardDatabase {
    static func testCards() -> [Card] {
        return [
            // Tier 1 - Cheap cards
            Card(tier: .one, name: "Basic Theorem",
                 cost: [.prime: 3], bonus: .prime, points: 0),
            
            Card(tier: .one, name: "Simple Proof",
                 cost: [.even: 2, .odd: 1], bonus: .even, points: 0),
            
            Card(tier: .one, name: "Easy Lemma",
                 cost: [.square: 3], bonus: .square, points: 1),
            
            Card(tier: .one, name: "Quick Corollary",
                 cost: [.sequence: 2, .prime: 1], bonus: .sequence, points: 0),
            
            // Tier 2 - Medium cards
            Card(tier: .two, name: "Pythagorean Theorem",
                 cost: [.square: 4, .prime: 2], bonus: .square, points: 2),
            
            Card(tier: .two, name: "Prime Number Theorem",
                 cost: [.prime: 5], bonus: .prime, points: 2),
            
            Card(tier: .two, name: "Fundamental Theorem",
                 cost: [.even: 3, .odd: 3], bonus: .even, points: 1),
            
            Card(tier: .two, name: "Euclid's Lemma",
                 cost: [.sequence: 4, .square: 2], bonus: .sequence, points: 2),
            
            // Tier 3 - Expensive cards
            Card(tier: .three, name: "Fermat's Last Theorem",
                 cost: [.prime: 7], bonus: .prime, points: 4),
            
            Card(tier: .three, name: "Riemann Hypothesis",
                 cost: [.even: 5, .odd: 3], bonus: .even, points: 5),
            
            Card(tier: .three, name: "Goldbach Conjecture",
                 cost: [.square: 6, .prime: 3], bonus: .square, points: 4),
            
            Card(tier: .three, name: "Twin Prime Conjecture",
                 cost: [.sequence: 5, .even: 3], bonus: .sequence, points: 3)
        ]
    }
}
