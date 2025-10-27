struct RealCardDatabase {
    static func allCards() -> [Card] {
        return whiteCards() + redCards() + greenCards() + blueCards() + blackCards()
    }

    // WHITE CARDS (Sequences/Diamonds) - 16 Cards
    static func whiteCards() -> [Card] {
        return [
            // 0 Points (8 cards)
            Card(tier: .one, name: "Arithmetic Progression", cost: [.square: 1, .even: 2, .odd: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Fibonacci Base", cost: [.square: 1, .prime: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Harmonic Series", cost: [.square: 1, .prime: 1, .even: 1, .odd: 1], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Geometric Mean", cost: [.even: 3], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Linear Recurrence", cost: [.even: 2, .odd: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Tribonacci Sum", cost: [.square: 1, .prime: 1, .even: 1, .odd: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Catalan Number", cost: [.square: 3, .even: 1], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Lucas Sequence", cost: [.odd: 4], bonus: .sequence, points: 0),
            
            // 1 Point (2 cards)
            Card(tier: .one, name: "Pell Sequence", cost: [.odd: 4], bonus: .sequence, points: 1),
            Card(tier: .one, name: "Golden Ratio", cost: [.square: 2, .prime: 2, .odd: 3], bonus: .sequence, points: 1),
            
            // 2 Points (4 cards)
            Card(tier: .two, name: "Padovan Series", cost: [.square: 2, .prime: 4, .odd: 1], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Fibonacci Limit", cost: [.prime: 5], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Kolakoski String", cost: [.square: 3, .prime: 5], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Recurrence Relation", cost: [.sequence: 6], bonus: .sequence, points: 2),
            
            // 3+ Points (2 cards)
            Card(tier: .three, name: "Fractal Dimension", cost: [.square: 3, .prime: 5, .even: 3, .odd: 3], bonus: .sequence, points: 3),
            Card(tier: .three, name: "Apery's Constant", cost: [.square: 7, .sequence: 3], bonus: .sequence, points: 5),
        ]
    }

    // RED CARDS (Primes/Rubies) - 16 Cards
    static func redCards() -> [Card] {
        return [
            // 0 Points (8 cards)
            Card(tier: .one, name: "Fundamental Unit", cost: [.sequence: 3], bonus: .prime, points: 0),
            Card(tier: .one, name: "Twin Primes", cost: [.square: 3, .sequence: 1, .prime: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Smallest Factor", cost: [.even: 2, .odd: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Sophie Germain", cost: [.square: 2, .sequence: 2, .odd: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Prime Gap", cost: [.square: 1, .sequence: 2, .even: 1, .odd: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Unique Divisor", cost: [.square: 1, .sequence: 1, .even: 1, .odd: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Safe Prime", cost: [.sequence: 2, .prime: 2], bonus: .prime, points: 0),
            Card(tier: .one, name: "Goldbach Sum", cost: [.sequence: 4], bonus: .prime, points: 0),
            
            // 1 Point (2 cards)
            Card(tier: .one, name: "Cousin Prime", cost: [.sequence: 4], bonus: .prime, points: 1),
            Card(tier: .one, name: "Mersenne Number", cost: [.square: 3, .prime: 2, .even: 3], bonus: .prime, points: 1),
            
            // 2 Points (4 cards)
            Card(tier: .two, name: "Safe Prime Extended", cost: [.sequence: 1, .even: 4, .odd: 2], bonus: .prime, points: 2),
            Card(tier: .two, name: "Unique Factorization", cost: [.square: 5, .sequence: 3], bonus: .prime, points: 2),
            Card(tier: .two, name: "Irreducible Polynomial", cost: [.square: 5], bonus: .prime, points: 2),
            Card(tier: .two, name: "Chebyshev Bias", cost: [.prime: 6], bonus: .prime, points: 2),
            
            // 3+ Points (2 cards)
            Card(tier: .three, name: "Fundamental Theorem", cost: [.square: 3, .sequence: 3, .even: 5, .odd: 3], bonus: .prime, points: 3),
            Card(tier: .three, name: "Euclidean Proof", cost: [.prime: 3, .odd: 7], bonus: .prime, points: 5),
        ]
    }

    // GREEN CARDS (Odds/Emeralds) - 16 Cards
    static func greenCards() -> [Card] {
        return [
            // 0 Points (8 cards)
            Card(tier: .one, name: "Odd Integer", cost: [.sequence: 2, .even: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Gaussian Sum", cost: [.prime: 2, .even: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Three-Term Oddity", cost: [.square: 1, .sequence: 1, .even: 1, .odd: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Unbalanced Set", cost: [.square: 1, .sequence: 1, .prime: 1, .even: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Mersenne Exponent", cost: [.square: 2, .sequence: 1, .prime: 1, .even: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Single Digit", cost: [.square: 2, .prime: 2, .even: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Asymmetric Array", cost: [.sequence: 3, .prime: 2], bonus: .odd, points: 0),
            Card(tier: .one, name: "Odd Factor", cost: [.prime: 3], bonus: .odd, points: 0),
            
            // 1 Point (2 cards)
            Card(tier: .one, name: "Sierpinski Number", cost: [.square: 4], bonus: .odd, points: 1),
            Card(tier: .one, name: "Non-Zero Root", cost: [.sequence: 3, .prime: 3, .odd: 2], bonus: .odd, points: 1),
            
            // 2 Points (4 cards)
            Card(tier: .two, name: "Single Value", cost: [.square: 1, .sequence: 4, .even: 1], bonus: .odd, points: 2),
            Card(tier: .two, name: "Unpaired Count", cost: [.even: 1, .odd: 5], bonus: .odd, points: 2),
            Card(tier: .two, name: "Fermat's Theorem", cost: [.even: 3, .odd: 3], bonus: .odd, points: 2),
            Card(tier: .two, name: "Catalan's Conjecture", cost: [.odd: 6], bonus: .odd, points: 2),
            
            // 3+ Points (2 cards)
            Card(tier: .three, name: "Prime Number Theorem", cost: [.sequence: 5, .prime: 3, .odd: 3], bonus: .odd, points: 3),
            Card(tier: .three, name: "Landau's Problem", cost: [.sequence: 3, .odd: 7], bonus: .odd, points: 5),
        ]
    }

    // BLUE CARDS (Evens/Sapphires) - 16 Cards
    static func blueCards() -> [Card] {
        return [
            // 0 Points (8 cards)
            Card(tier: .one, name: "Divisible by Two", cost: [.square: 1, .sequence: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Euler's Identity", cost: [.square: 1, .sequence: 1, .prime: 2, .odd: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Even Square Pairs", cost: [.square: 1, .sequence: 1, .prime: 1, .odd: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Power of Two", cost: [.prime: 1, .even: 1, .odd: 3], bonus: .even, points: 0),
            Card(tier: .one, name: "Binary Bit", cost: [.square: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Modulo Zero", cost: [.sequence: 1, .prime: 2, .odd: 2], bonus: .even, points: 0),
            Card(tier: .one, name: "Factorial Base", cost: [.prime: 1, .odd: 2], bonus: .even, points: 0),
            Card(tier: .one, name: "Congruence Check", cost: [.prime: 4], bonus: .even, points: 0),
            
            // 1 Point (2 cards)
            Card(tier: .one, name: "Zero Pair", cost: [.prime: 3, .even: 2, .odd: 2], bonus: .even, points: 1),
            Card(tier: .one, name: "Double Value", cost: [.even: 2, .odd: 3], bonus: .even, points: 1),
            
            // 2 Points (4 cards)
            Card(tier: .two, name: "Parity Check", cost: [.sequence: 5, .even: 3], bonus: .even, points: 2),
            Card(tier: .two, name: "Lagrange's Four-Square", cost: [.even: 5], bonus: .even, points: 2),
            Card(tier: .two, name: "Diophantine Solution", cost: [.square: 2, .sequence: 2, .prime: 1], bonus: .even, points: 2),
            Card(tier: .two, name: "G-series", cost: [.even: 6], bonus: .even, points: 2),
            
            // 3+ Points (2 cards)
            Card(tier: .three, name: "Turing Machine", cost: [.sequence: 3, .prime: 3, .odd: 3], bonus: .even, points: 3),
            Card(tier: .three, name: "Four-Color Theorem", cost: [.sequence: 7, .even: 3], bonus: .even, points: 5),
        ]
    }

    // BLACK CARDS (Squares/Onyxes) - 16 Cards
    static func blackCards() -> [Card] {
        return [
            // 0 Points (8 cards)
            Card(tier: .one, name: "Integer Base", cost: [.sequence: 1, .prime: 1, .even: 1, .odd: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Tesselation Base", cost: [.prime: 1, .odd: 2], bonus: .square, points: 0),
            Card(tier: .one, name: "Perfect Power", cost: [.sequence: 2, .odd: 2], bonus: .square, points: 0),
            Card(tier: .one, name: "Tetrahedral Point", cost: [.square: 1, .prime: 3, .odd: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Cubic Root", cost: [.odd: 3], bonus: .square, points: 0),
            Card(tier: .one, name: "Polygonal Formula", cost: [.sequence: 1, .prime: 1, .even: 2, .odd: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Root Check", cost: [.sequence: 2, .prime: 1, .even: 2], bonus: .square, points: 0),
            Card(tier: .one, name: "Quadratic Term", cost: [.even: 4], bonus: .square, points: 0),
            
            // 1 Point (2 cards)
            Card(tier: .one, name: "Pythagorean Triplet", cost: [.even: 4], bonus: .square, points: 1),
            Card(tier: .one, name: "Fourth Power", cost: [.sequence: 3, .even: 2, .odd: 2], bonus: .square, points: 1),
            
            // 2 Points (4 cards)
            Card(tier: .two, name: "Hexagonal Grid", cost: [.prime: 2, .even: 1, .odd: 4], bonus: .square, points: 2),
            Card(tier: .two, name: "Centered Polygonal", cost: [.sequence: 5], bonus: .square, points: 2),
            Card(tier: .two, name: "Sum of Squares", cost: [.prime: 3, .odd: 5], bonus: .square, points: 2),
            Card(tier: .two, name: "Gnomon Accumulation", cost: [.square: 6], bonus: .square, points: 2),
            
            // 3+ Points (2 cards)
            Card(tier: .three, name: "Pythagorean Identity", cost: [.sequence: 3, .prime: 3, .even: 3, .odd: 5], bonus: .square, points: 3),
            Card(tier: .three, name: "Gauss Circle Problem", cost: [.square: 3, .prime: 7], bonus: .square, points: 5),
        ]
    }
}
