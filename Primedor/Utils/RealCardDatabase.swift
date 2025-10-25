import Foundation

struct RealCardDatabase {
    static func allCards() -> [Card] {
        return tier1Cards() + tier2Cards() + tier3Cards()
    }
    
    // TIER 1 - 40 cards (8 of each bonus type, except perfect)
    static func tier1Cards() -> [Card] {
        return [
            // PRIME bonus cards (8 cards)
            Card(tier: .one, name: "Prime Theory I", cost: [.even: 3], bonus: .prime, points: 0),
            Card(tier: .one, name: "Prime Theory II", cost: [.even: 2, .sequence: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Prime Theory III", cost: [.odd: 1, .square: 1, .sequence: 1, .even: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Prime Theory IV", cost: [.odd: 2, .sequence: 2], bonus: .prime, points: 0),
            Card(tier: .one, name: "Prime Lemma I", cost: [.even: 2, .square: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Prime Lemma II", cost: [.square: 3], bonus: .prime, points: 0),
            Card(tier: .one, name: "Prime Proof I", cost: [.odd: 1, .square: 2], bonus: .prime, points: 0),
            Card(tier: .one, name: "Prime Proof II", cost: [.sequence: 1, .square: 1, .odd: 1, .even: 1], bonus: .prime, points: 1),
            
            // EVEN bonus cards (8 cards)
            Card(tier: .one, name: "Even Theory I", cost: [.prime: 3], bonus: .even, points: 0),
            Card(tier: .one, name: "Even Theory II", cost: [.prime: 2, .odd: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Even Theory III", cost: [.prime: 1, .square: 1, .sequence: 1, .odd: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Even Theory IV", cost: [.prime: 2, .square: 2], bonus: .even, points: 0),
            Card(tier: .one, name: "Even Lemma I", cost: [.odd: 3], bonus: .even, points: 0),
            Card(tier: .one, name: "Even Lemma II", cost: [.prime: 1, .odd: 2], bonus: .even, points: 0),
            Card(tier: .one, name: "Even Proof I", cost: [.prime: 2, .sequence: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Even Proof II", cost: [.prime: 1, .square: 1, .sequence: 1, .odd: 1], bonus: .even, points: 1),
            
            // ODD bonus cards (8 cards)
            Card(tier: .one, name: "Odd Theory I", cost: [.even: 3], bonus: .odd, points: 0),
            Card(tier: .one, name: "Odd Theory II", cost: [.even: 2, .square: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Odd Theory III", cost: [.prime: 1, .even: 1, .sequence: 1, .square: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Odd Theory IV", cost: [.even: 2, .sequence: 2], bonus: .odd, points: 0),
            Card(tier: .one, name: "Odd Lemma I", cost: [.sequence: 3], bonus: .odd, points: 0),
            Card(tier: .one, name: "Odd Lemma II", cost: [.even: 1, .sequence: 2], bonus: .odd, points: 0),
            Card(tier: .one, name: "Odd Proof I", cost: [.prime: 2, .even: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Odd Proof II", cost: [.prime: 1, .even: 1, .square: 1, .sequence: 1], bonus: .odd, points: 1),
            
            // SQUARE bonus cards (8 cards)
            Card(tier: .one, name: "Square Theory I", cost: [.odd: 3], bonus: .square, points: 0),
            Card(tier: .one, name: "Square Theory II", cost: [.odd: 2, .sequence: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Square Theory III", cost: [.prime: 1, .even: 1, .odd: 1, .sequence: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Square Theory IV", cost: [.prime: 2, .odd: 2], bonus: .square, points: 0),
            Card(tier: .one, name: "Square Lemma I", cost: [.prime: 3], bonus: .square, points: 0),
            Card(tier: .one, name: "Square Lemma II", cost: [.prime: 2, .odd: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Square Proof I", cost: [.even: 2, .odd: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Square Proof II", cost: [.prime: 1, .even: 1, .odd: 1, .sequence: 1], bonus: .square, points: 1),
            
            // SEQUENCE bonus cards (8 cards)
            Card(tier: .one, name: "Sequence Theory I", cost: [.square: 3], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Sequence Theory II", cost: [.square: 2, .prime: 1], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Sequence Theory III", cost: [.prime: 1, .even: 1, .odd: 1, .square: 1], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Sequence Theory IV", cost: [.even: 2, .square: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Sequence Lemma I", cost: [.even: 3], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Sequence Lemma II", cost: [.even: 2, .square: 1], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Sequence Proof I", cost: [.odd: 2, .square: 1], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Sequence Proof II", cost: [.prime: 1, .even: 1, .odd: 1, .square: 1], bonus: .sequence, points: 1),
        ]
    }
    
    // TIER 2 - 30 cards (6 of each bonus type)
    static func tier2Cards() -> [Card] {
        return [
            // PRIME bonus cards (6 cards)
            Card(tier: .two, name: "Fermat's Little", cost: [.even: 5], bonus: .prime, points: 2),
            Card(tier: .two, name: "Mersenne Prime", cost: [.even: 3, .sequence: 3, .square: 2], bonus: .prime, points: 1),
            Card(tier: .two, name: "Sophie Germain", cost: [.odd: 3, .square: 2, .even: 2], bonus: .prime, points: 2),
            Card(tier: .two, name: "Twin Prime", cost: [.square: 5, .even: 3], bonus: .prime, points: 2),
            Card(tier: .two, name: "Euler Product", cost: [.odd: 5], bonus: .prime, points: 2),
            Card(tier: .two, name: "Sieve Method", cost: [.sequence: 5], bonus: .prime, points: 2),
            
            // EVEN bonus cards (6 cards)
            Card(tier: .two, name: "Parity Theory", cost: [.prime: 5], bonus: .even, points: 2),
            Card(tier: .two, name: "Divisibility", cost: [.prime: 2, .odd: 3, .square: 2], bonus: .even, points: 2),
            Card(tier: .two, name: "Binary System", cost: [.square: 5, .odd: 3], bonus: .even, points: 2),
            Card(tier: .two, name: "Modulo Arithmetic", cost: [.prime: 3, .sequence: 2, .odd: 3], bonus: .even, points: 1),
            Card(tier: .two, name: "Power of Two", cost: [.square: 5], bonus: .even, points: 2),
            Card(tier: .two, name: "Symmetry", cost: [.sequence: 5], bonus: .even, points: 2),
            
            // ODD bonus cards (6 cards)
            Card(tier: .two, name: "Gauss Sum", cost: [.even: 5], bonus: .odd, points: 2),
            Card(tier: .two, name: "Residue Class", cost: [.prime: 2, .even: 3, .sequence: 2], bonus: .odd, points: 2),
            Card(tier: .two, name: "Diophantine", cost: [.sequence: 5, .prime: 3], bonus: .odd, points: 2),
            Card(tier: .two, name: "Congruence", cost: [.even: 3, .square: 2, .sequence: 3], bonus: .odd, points: 1),
            Card(tier: .two, name: "Remainder", cost: [.prime: 5], bonus: .odd, points: 2),
            Card(tier: .two, name: "Coprime", cost: [.square: 5], bonus: .odd, points: 2),
            
            // SQUARE bonus cards (6 cards)
            Card(tier: .two, name: "Pythagorean", cost: [.odd: 5], bonus: .square, points: 2),
            Card(tier: .two, name: "Perfect Square", cost: [.even: 2, .odd: 3, .prime: 2], bonus: .square, points: 2),
            Card(tier: .two, name: "Quadratic Form", cost: [.prime: 5, .even: 3], bonus: .square, points: 2),
            Card(tier: .two, name: "Square Root", cost: [.odd: 3, .sequence: 2, .prime: 3], bonus: .square, points: 1),
            Card(tier: .two, name: "Area Formula", cost: [.even: 5], bonus: .square, points: 2),
            Card(tier: .two, name: "Tessellation", cost: [.sequence: 5], bonus: .square, points: 2),
            
            // SEQUENCE bonus cards (6 cards)
            Card(tier: .two, name: "Fibonacci", cost: [.square: 5], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Arithmetic Seq", cost: [.even: 2, .square: 2, .odd: 3], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Geometric Seq", cost: [.odd: 5, .even: 3], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Recursion", cost: [.square: 3, .prime: 2, .even: 3], bonus: .sequence, points: 1),
            Card(tier: .two, name: "Series Sum", cost: [.odd: 5], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Convergence", cost: [.prime: 5], bonus: .sequence, points: 2),
        ]
    }
    
    // TIER 3 - 20 cards (4 of each bonus type)
    static func tier3Cards() -> [Card] {
        return [
            // PRIME bonus cards (4 cards)
            Card(tier: .three, name: "Riemann Hypothesis", cost: [.even: 7], bonus: .prime, points: 4),
            Card(tier: .three, name: "Goldbach Conjecture", cost: [.even: 3, .square: 3, .sequence: 5, .odd: 3], bonus: .prime, points: 3),
            Card(tier: .three, name: "Prime Number Theorem", cost: [.odd: 7, .square: 3], bonus: .prime, points: 4),
            Card(tier: .three, name: "Fermat's Last", cost: [.sequence: 7], bonus: .prime, points: 5),
            
            // EVEN bonus cards (4 cards)
            Card(tier: .three, name: "Perfect Number", cost: [.prime: 7], bonus: .even, points: 4),
            Card(tier: .three, name: "Abundant Number", cost: [.prime: 3, .odd: 3, .square: 5, .sequence: 3], bonus: .even, points: 3),
            Card(tier: .three, name: "Deficient Number", cost: [.sequence: 7, .prime: 3], bonus: .even, points: 4),
            Card(tier: .three, name: "Amicable Pair", cost: [.square: 7], bonus: .even, points: 5),
            
            // ODD bonus cards (4 cards)
            Card(tier: .three, name: "Collatz Conjecture", cost: [.even: 7], bonus: .odd, points: 4),
            Card(tier: .three, name: "Catalan Number", cost: [.even: 3, .sequence: 3, .prime: 5, .square: 3], bonus: .odd, points: 3),
            Card(tier: .three, name: "Stirling Number", cost: [.prime: 7, .even: 3], bonus: .odd, points: 4),
            Card(tier: .three, name: "Bell Number", cost: [.odd: 7], bonus: .odd, points: 5),
            
            // SQUARE bonus cards (4 cards)
            Card(tier: .three, name: "Pell Equation", cost: [.odd: 7], bonus: .square, points: 4),
            Card(tier: .three, name: "Diophantine Eq", cost: [.odd: 3, .prime: 3, .even: 5, .sequence: 3], bonus: .square, points: 3),
            Card(tier: .three, name: "Quadratic Residue", cost: [.sequence: 7, .odd: 3], bonus: .square, points: 4),
            Card(tier: .three, name: "Mordell Curve", cost: [.prime: 7], bonus: .square, points: 5),
            
            // SEQUENCE bonus cards (4 cards)
            Card(tier: .three, name: "Lucas Sequence", cost: [.square: 7], bonus: .sequence, points: 4),
            Card(tier: .three, name: "Tribonacci", cost: [.square: 3, .even: 3, .odd: 5, .prime: 3], bonus: .sequence, points: 3),
            Card(tier: .three, name: "Padovan Sequence", cost: [.prime: 7, .square: 3], bonus: .sequence, points: 4),
            Card(tier: .three, name: "Recamán Sequence", cost: [.even: 7], bonus: .sequence, points: 5),
        ]
    }
}
