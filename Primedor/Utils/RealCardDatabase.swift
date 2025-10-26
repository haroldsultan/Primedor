struct RealCardDatabase {
    static func allCards() -> [Card] {
        return tier1Cards() + tier2Cards() + tier3Cards()
    }

    // TIER 1 - 40 cards (0-1 point)
    static func tier1Cards() -> [Card] {
        return [
            // --- SEQUENCE (White Bonus) - 8 Cards ---
            Card(tier: .one, name: "Chain Rule", cost: [.prime: 1, .even: 1, .odd: 1, .square: 1], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Lucas Sequence", cost: [.even: 2, .odd: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Tribonacci Base", cost: [.odd: 2, .even: 1], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Arithmetic Progression", cost: [.prime: 3], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Geometric Ratio", cost: [.even: 1, .odd: 1, .prime: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Harmonic Average", cost: [.even: 1, .odd: 2, .prime: 1, .square: 1], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Term Difference", cost: [.even: 1, .square: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Recursive Step", cost: [.square: 4], bonus: .sequence, points: 1),

            // --- EVEN (Blue Bonus) - 8 Cards ---
            Card(tier: .one, name: "Divisible by Two", cost: [.prime: 1, .odd: 1, .square: 1, .sequence: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Euler's Identity", cost: [.prime: 2, .square: 2], bonus: .even, points: 0),
            Card(tier: .one, name: "Even Square Pairs", cost: [.square: 1, .prime: 2], bonus: .even, points: 0),
            Card(tier: .one, name: "Power of Two", cost: [.odd: 3], bonus: .even, points: 0),
            Card(tier: .one, name: "Binary Bit", cost: [.prime: 2, .odd: 1, .sequence: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Modulo Zero", cost: [.prime: 2, .odd: 1, .square: 1, .sequence: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Factorial Base", cost: [.prime: 2, .sequence: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Congruence Check", cost: [.sequence: 4], bonus: .even, points: 1),

            // --- ODD (Green Bonus) - 8 Cards ---
            Card(tier: .one, name: "Odd Integer", cost: [.prime: 1, .even: 1, .square: 1, .sequence: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Gaussian Sum", cost: [.prime: 2, .sequence: 2], bonus: .odd, points: 0),
            Card(tier: .one, name: "Three-Term Oddity", cost: [.even: 1, .prime: 2], bonus: .odd, points: 0),
            Card(tier: .one, name: "Unbalanced Set", cost: [.square: 3], bonus: .odd, points: 0),
            Card(tier: .one, name: "Mersenne Exponent", cost: [.even: 1, .prime: 1, .square: 2], bonus: .odd, points: 0),
            Card(tier: .one, name: "Single Digit", cost: [.even: 2, .prime: 1, .square: 1, .sequence: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Asymmetric Array", cost: [.even: 2, .sequence: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Odd Factor", cost: [.even: 4], bonus: .odd, points: 1),

            // --- PRIME (Red Bonus) - 8 Cards ---
            Card(tier: .one, name: "Fundamental Unit", cost: [.even: 1, .odd: 1, .square: 1, .sequence: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Twin Primes", cost: [.even: 2, .odd: 2], bonus: .prime, points: 0),
            Card(tier: .one, name: "Smallest Factor", cost: [.odd: 2, .square: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Sophie Germain", cost: [.sequence: 3], bonus: .prime, points: 0),
            Card(tier: .one, name: "Prime Gap", cost: [.sequence: 1, .odd: 2, .square: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Unique Divisor", cost: [.sequence: 1, .even: 2, .odd: 1, .square: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Safe Prime", cost: [.even: 2, .square: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Goldbach Sum", cost: [.odd: 4], bonus: .prime, points: 1),

            // --- SQUARE (Black Bonus) - 8 Cards ---
            Card(tier: .one, name: "Integer Base", cost: [.prime: 1, .even: 1, .odd: 1, .sequence: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Tesselation Base", cost: [.even: 2, .prime: 2], bonus: .square, points: 0),
            Card(tier: .one, name: "Perfect Power", cost: [.prime: 1, .odd: 2], bonus: .square, points: 0),
            Card(tier: .one, name: "Tetrahedral Point", cost: [.even: 3], bonus: .square, points: 0),
            Card(tier: .one, name: "Cubic Root", cost: [.even: 2, .odd: 1, .prime: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Polygonal Formula", cost: [.even: 1, .odd: 1, .prime: 2, .sequence: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Root Check", cost: [.odd: 1, .sequence: 2], bonus: .square, points: 0),
            Card(tier: .one, name: "Quadratic Term", cost: [.prime: 4], bonus: .square, points: 1)
        ]
    }

    // ---
    
    // TIER 2 - 30 cards (1-3 points)
    static func tier2Cards() -> [Card] {
        return [
            // --- SEQUENCE (White Bonus) - 6 Cards ---
            Card(tier: .two, name: "Catalan Count", cost: [.square: 2, .prime: 3, .odd: 2], bonus: .sequence, points: 1),
            Card(tier: .two, name: "Golden Ratio", cost: [.square: 5], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Fibonacci Limit", cost: [.odd: 5], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Kolakoski String", cost: [.square: 3, .prime: 3, .odd: 2], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Recurrence Relation", cost: [.even: 5, .prime: 3], bonus: .sequence, points: 3),
            // Fixed: Cost 6 Prime, Bonus Sequence
            Card(tier: .two, name: "Apery's Constant", cost: [.prime: 6], bonus: .sequence, points: 3),

            // --- EVEN (Blue Bonus) - 6 Cards ---
            Card(tier: .two, name: "Zero Pair", cost: [.prime: 3, .odd: 2, .square: 2], bonus: .even, points: 1),
            Card(tier: .two, name: "Double Value", cost: [.odd: 5], bonus: .even, points: 2),
            Card(tier: .two, name: "Parity Check", cost: [.prime: 5], bonus: .even, points: 2),
            Card(tier: .two, name: "Lagrange's Four-Square", cost: [.prime: 3, .square: 3, .sequence: 2], bonus: .even, points: 2),
            Card(tier: .two, name: "Diophantine Solution", cost: [.square: 5, .sequence: 3], bonus: .even, points: 3),
            // Fixed: Cost 6 Square, Bonus Even
            Card(tier: .two, name: "G-series", cost: [.square: 6], bonus: .even, points: 3),

            // --- ODD (Green Bonus) - 6 Cards ---
            Card(tier: .two, name: "Sierpinski Number", cost: [.sequence: 2, .even: 3, .prime: 2], bonus: .odd, points: 1),
            Card(tier: .two, name: "Non-Zero Root", cost: [.prime: 5], bonus: .odd, points: 2),
            Card(tier: .two, name: "Single Value", cost: [.square: 5], bonus: .odd, points: 2),
            Card(tier: .two, name: "Unpaired Count", cost: [.prime: 2, .even: 2, .square: 3], bonus: .odd, points: 2),
            Card(tier: .two, name: "Fermat's Theorem", cost: [.even: 5, .sequence: 3], bonus: .odd, points: 3),
            // Fixed: Cost 6 Sequence, Bonus Odd
            Card(tier: .two, name: "Catalan's Conjecture", cost: [.sequence: 6], bonus: .odd, points: 3),

            // --- PRIME (Red Bonus) - 6 Cards ---
            Card(tier: .two, name: "Cousin Prime", cost: [.even: 3, .odd: 2, .sequence: 2], bonus: .prime, points: 1),
            Card(tier: .two, name: "Mersenne Number", cost: [.sequence: 5], bonus: .prime, points: 2),
            Card(tier: .two, name: "Safe Prime", cost: [.even: 5], bonus: .prime, points: 2),
            Card(tier: .two, name: "Unique Factorization", cost: [.sequence: 3, .even: 3, .odd: 2], bonus: .prime, points: 2),
            Card(tier: .two, name: "Irreducible Polynomial", cost: [.odd: 5, .square: 3], bonus: .prime, points: 3),
            // Fixed: Cost 6 Odd, Bonus Prime
            Card(tier: .two, name: "Chebyshev Bias", cost: [.odd: 6], bonus: .prime, points: 3),

            // --- SQUARE (Black Bonus) - 6 Cards ---
            Card(tier: .two, name: "Pythagorean Triplet", cost: [.odd: 2, .prime: 3, .even: 2], bonus: .square, points: 1),
            Card(tier: .two, name: "Fourth Power", cost: [.even: 5], bonus: .square, points: 2),
            Card(tier: .two, name: "Hexagonal Grid", cost: [.odd: 5], bonus: .square, points: 2),
            Card(tier: .two, name: "Centered Polygonal", cost: [.even: 2, .odd: 2, .sequence: 3], bonus: .square, points: 2),
            Card(tier: .two, name: "Sum of Squares", cost: [.prime: 5, .even: 3], bonus: .square, points: 3),
            // Fixed: Cost 6 Even, Bonus Square
            Card(tier: .two, name: "Gnomon Accumulation", cost: [.even: 6], bonus: .square, points: 3)
        ]
    }

    // ---

    // TIER 3 - 20 cards (3-5 points)
    static func tier3Cards() -> [Card] {
        return [
            // --- SEQUENCE (White Bonus) - 4 Cards ---
            Card(tier: .three, name: "Fractal Dimension", cost: [.prime: 3, .even: 3, .odd: 3, .square: 5], bonus: .sequence, points: 3),
            Card(tier: .three, name: "Pell Number", cost: [.prime: 3, .even: 5, .odd: 3, .square: 3], bonus: .sequence, points: 3),
            Card(tier: .three, name: "Padovan Series", cost: [.square: 7], bonus: .sequence, points: 4),
            Card(tier: .three, name: "Fibonacci Sequence", cost: [.prime: 7, .square: 3], bonus: .sequence, points: 5),

            // --- EVEN (Blue Bonus) - 4 Cards ---
            Card(tier: .three, name: "Turing Machine", cost: [.prime: 3, .odd: 3, .square: 3, .sequence: 5], bonus: .even, points: 3),
            Card(tier: .three, name: "Gödel's Incompleteness", cost: [.prime: 5, .odd: 3, .square: 3, .sequence: 3], bonus: .even, points: 3),
            Card(tier: .three, name: "Four-Color Theorem", cost: [.odd: 7], bonus: .even, points: 4),
            Card(tier: .three, name: "Riemann Hypothesis", cost: [.square: 7, .odd: 3], bonus: .even, points: 5),
            
            // --- ODD (Green Bonus) - 4 Cards ---
            Card(tier: .three, name: "Prime Number Theorem", cost: [.prime: 5, .even: 3, .square: 3, .sequence: 3], bonus: .odd, points: 3),
            Card(tier: .three, name: "Archimedes Spiral", cost: [.prime: 3, .even: 5, .square: 3, .sequence: 3], bonus: .odd, points: 3),
            Card(tier: .three, name: "Fermat's Last Theorem", cost: [.prime: 7], bonus: .odd, points: 4),
            Card(tier: .three, name: "Landau's Problem", cost: [.square: 7, .prime: 3], bonus: .odd, points: 5),
            
            // --- PRIME (Red Bonus) - 4 Cards ---
            Card(tier: .three, name: "Fundamental Theorem", cost: [.sequence: 3, .even: 3, .odd: 5, .square: 3], bonus: .prime, points: 3),
            Card(tier: .three, name: "Cullen Number", cost: [.sequence: 3, .even: 5, .odd: 3, .square: 3], bonus: .prime, points: 3),
            Card(tier: .three, name: "Strong Primes", cost: [.sequence: 7], bonus: .prime, points: 4),
            Card(tier: .three, name: "Euclidean Proof", cost: [.even: 7, .sequence: 3], bonus: .prime, points: 5),
            
            // --- SQUARE (Black Bonus) - 4 Cards ---
            Card(tier: .three, name: "Pythagorean Identity", cost: [.prime: 3, .even: 3, .odd: 5, .sequence: 3], bonus: .square, points: 3),
            Card(tier: .three, name: "Perfect Square", cost: [.prime: 3, .even: 5, .odd: 3, .sequence: 3], bonus: .square, points: 3),
            Card(tier: .three, name: "Icosidodecahedron", cost: [.even: 7], bonus: .square, points: 4),
            Card(tier: .three, name: "Gauss Circle Problem", cost: [.odd: 7, .even: 3], bonus: .square, points: 5)
        ]
    }
}
