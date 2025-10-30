//
//  Mathematician.swift
//  Primedor
//
//  Represents a famous mathematician that visits players who meet requirements
//

import Foundation

// MARK: - Card & Mathematician Descriptions
struct CardDescription {
    static let descriptions: [String: String] = [
        // WHITE CARDS (SEQUENCE) - 18 Cards
        "Arithmetic Progression": "Numbers increasing by a constant difference in perfect mathematical order.",
        "Fibonacci Base": "The foundational sequence where each number is the sum of the two before it.",
        "Harmonic Series": "Reciprocals of counting numbers that mysteriously diverge to infinity.",
        "Geometric Mean": "The middle value in a multiplicative sequence creating exponential growth.",
        "Linear Recurrence": "Functions defined by their own previous values creating elegant patterns.",
        "Tribonacci Sum": "An extension of Fibonacci where each term sums three previous terms.",
        "Catalan Number": "Recursive sequences appearing in trees, brackets, parentheses, and polygon divisions.",
        "Lucas Sequence": "A companion to Fibonacci with different starting values but similar recursive structure.",
        
        "Pell Sequence": "Numbers solving the equation x² - 2y² = 1 in infinite integer solutions.",
        "Golden Ratio": "The divine proportion φ ≈ 1.618 appearing throughout nature and art.",
        "Padovan Series": "A lesser-known sequence where each term is the sum of two terms two positions back.",
        "Fibonacci Limit": "The ratio between consecutive Fibonacci numbers converging to the golden ratio.",
        "Kolakoski String": "A self-describing sequence that encodes its own run lengths.",
        "Recurrence Relation": "Mathematical rules defining sequences through relationships with previous terms.",
        
        "Fractal Dimension": "Non-integer dimensions measuring the complexity of self-similar geometric shapes.",
        "Apery's Constant": "The sum of reciprocals of cubes ζ(3) ≈ 1.202, mysteriously irrational.",
        "Sphere Packing": "The optimal arrangement of spheres in space maximizing density.",
        "Convergence Limit": "The stable value that sequences approach as their terms grow indefinitely.",
        
        // RED CARDS (PRIME) - 18 Cards
        "Prime Number": "a whole number greater than 1 that cannot be exactly divided by any whole number other than itself and 1.",
        "Twin Primes": "Two primes that differ by 2 (e.g. 11 and 13).",
        "Smallest Factor": "The prime factor that divides a number with the least multiplicative power.",
        "Sophie Germain": "Groundbreaking number theorist who made major contributions to Fermat's Last Theorem.",
        "Prime Gap": "The spacing between consecutive primes that grows mysteriously as numbers increase.",
        "Unique Divisor": "A number whose only divisors are one and itself, the definition of prime.",
        "Safe Prime": "A prime p where (p-1)/2 is also prime, protecting against certain attacks.",
        "Goldbach Sum": "Every even number greater than two is the sum of two prime numbers.",

        "Cousin Prime": "Two primes separated by exactly four, like 3 and 7 or 13 and 17.",
        "Mersenne Number": "Numbers of the form 2ⁿ - 1 that often yield the largest known primes.",
        "Safe Prime Extended": "Advanced applications of safe primes in secure cryptographic protocols.",
        "Unique Factorization": "Every integer has exactly one way to express itself as a product of primes.",
        "Irreducible Polynomial": "A polynomial that cannot be factored into lower-degree polynomials.",
        "Chebyshev Bias": "Primes ≡ 3 (mod 4) appear slightly more often than primes ≡ 1 (mod 4).",
        
        "Fundamental Theorem": "The central theorem of arithmetic: unique prime factorization for all integers.",
        "Euclidean Proof": "The ancient proof showing infinitely many primes exist by contradiction.",
        "Dirichlet Theorem": "Arithmetic progressions contain infinitely many primes in regular distribution.",
        "Riemann Zeta": "The zeta function ζ(s) connecting primes to deep analytical mathematics.",
        
        // GREEN CARDS (ODD) - 18 Cards
        "Odd Integer": "Numbers not divisible by two, forming exactly half of all integers.",
        "Gaussian Sum": "Sums over roots of unity encoding deep arithmetic properties in complex numbers.",
        "Three-Term Oddity": "Mathematical patterns involving three odd numbers in specific relationships.",
        "Unbalanced Set": "Collections of numbers with odd total count creating asymmetric properties.",
        "Mersenne Exponent": "The exponent n in Mersenne numbers 2ⁿ - 1, often requiring odd n.",
        "Single Digit": "Numbers from 1 to 9, the foundational digits of positional notation.",
        "Asymmetric Array": "An arrangement with odd dimensions creating inherent asymmetry.",
        "Odd Factor": "The odd part remaining after removing all factors of two from a number.",
        
        "Sierpinski Number": "Numbers k where k·2ⁿ + 1 is composite for all positive integers n.",
        "Non-Zero Root": "An odd root of a number distinct from zero, revealing hidden structure.",
        "Single Value": "A unique odd number standing alone in mathematical significance.",
        "Unpaired Count": "A count of odd size that cannot be perfectly paired or halved.",
        "Fermat's Theorem": "If p is an odd prime, then aᵖ⁻¹ ≡ 1 (mod p) for gcd(a,p)=1.",
        "Catalan's Conjecture": "The conjecture that 3² and 2³ are the only consecutive perfect powers.",
        
        "Prime Number Theorem": "The density of primes decreases logarithmically as numbers grow larger.",
        "Landau's Problem": "Four conjectures about primes, including twin primes and Goldbach variants.",
        "Odd Harmonics": "In music, odd-numbered harmonics create the rich overtone series.",
        "Twin Conjecture": "The unproven hypothesis that infinitely many twin prime pairs exist.",
        
        // BLUE CARDS (EVEN) - 18 Cards
        "Divisible by Two": "The most basic even property: divisibility by the smallest prime.",
        "Euler's Identity": "The equation e^(iπ) + 1 = 0 linking five fundamental mathematical constants.",
        "Even Square Pairs": "Even numbers that can be expressed as the difference of two squares.",
        "Power of Two": "Numbers of the form 2ⁿ appearing naturally in binary and computer science.",
        "Binary Bit": "The fundamental unit of information in computers, representing 0 or 1.",
        "Modulo Zero": "The property of divisibility expressed as a ≡ 0 (mod 2) for even numbers.",
        "Factorial Base": "A numbering system using factorials as place values instead of powers.",
        "Congruence Check": "Verifying that numbers are equivalent under modular arithmetic.",
        
        "Zero Pair": "Two values that sum to zero, fundamental to balanced equations.",
        "Double Value": "A number multiplied by two, the most basic even transformation.",
        "Parity Check": "A method for detecting single-bit errors in digital transmission.",
        "Lagrange's Four-Square": "Every positive integer is a sum of at most four perfect squares.",
        "Diophantine Solution": "Integer solutions to polynomial equations defining geometric curves.",
        "G-series": "Advanced generating function series used in combinatorial mathematics.",
        
        "Turing Machine": "The theoretical model of computation deciding what is algorithmically computable.",
        "Four-Color Theorem": "Any map can be colored with at most four colors without adjacent conflicts.",
        "Boolean Algebra": "Logical operations (AND, OR, NOT) forming the foundation of digital circuits.",
        "Gray Codes": "Binary sequences where consecutive numbers differ in exactly one bit.",
        
        // BLACK CARDS (SQUARE) - 18 Cards
        "Integer Base": "A whole number that when multiplied by itself yields a perfect square.",
        "Tesselation Base": "Shapes that perfectly tile a plane, often involving square grids.",
        "Perfect Power": "Numbers expressible as aⁿ for integers a and n ≥ 2.",
        "Tetrahedral Point": "Points in a tetrahedral lattice, extending square lattices to 3D.",
        "Cubic Root": "The number that when multiplied by itself three times yields the original.",
        "Polygonal Formula": "The formula for counting dots in regular polygonal arrangements.",
        "Root Check": "Verification that a number is a perfect root of another number.",
        "Quadratic Term": "The degree-2 term in a polynomial defining parabolic behavior.",
        
        "Pythagorean Triplet": "Three integers (a,b,c) satisfying a² + b² = c² forming right triangles.",
        "Fourth Power": "A number raised to the power of four, emphasizing exponential growth.",
        "Hexagonal Grid": "A grid of hexagons where each hexagon touches six neighbors.",
        "Centered Polygonal": "Numbers counting dots in polygons with a dot at the center.",
        "Sum of Squares": "Numbers expressible as the sum of two or more perfect squares.",
        "Gnomon Accumulation": "L-shaped figures whose areas sum to square numbers.",
        
        "Pythagorean Identity": "The fundamental trigonometric identity sin²θ + cos²θ = 1.",
        "Gauss Circle Problem": "Counting lattice points inside circles, a deep problem in analytic number theory.",
        "Lattice Points": "Integer coordinate points forming a regular grid throughout space.",
        "Sphere Geometry": "The geometric properties of spheres including surface area and volume.",
        
        // MATHEMATICIANS (3 points each)
        "Alan Turing": "Pioneer of computer science and artificial intelligence.",
        "Carl F. Gauss": "The Prince of Mathematicians, master of number theory and statistics.",
        "Maryam Mirzakhani": "She mapped the hidden shapes of infinite surfaces.",
        "Pythagoras": "Ancient Greek mathematician whose theorem defines the relationship between triangle sides.",
        "Srinivasa Ramanujan": "Intuitive genius who discovered thousands of remarkable mathematical identities.",
        "Rene Descartes": "Founder of analytic geometry, bridging algebra and geometry.",
        "Hypatia": "Ancient astronomer and mathematician, first famous female mathematician.",
        "G. W. Leibniz": "Co-inventor of calculus and pioneer of symbolic mathematics.",
        "Emmy Noether": "Revolutionary abstract algebraist whose theorem connects symmetry and conservation laws.",
        "Archimedes": "Ancient Greek mathematician who invented calculus concepts 2000 years early.",
    ]
    
    static func description(for name: String) -> String {
        return descriptions[name] ?? "A card of mathematical significance."
    }
}

/// A mathematician card worth 3 points, acquired automatically when requirements are met
struct Mathematician: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let specialty: String
    let requirements: [TokenType: Int]
    let points: Int = 3
    
    init(name: String, specialty: String, requirements: [TokenType: Int]) {
        self.id = UUID()
        self.name = name
        self.specialty = specialty
        self.requirements = requirements
    }
    
    init(id: UUID = UUID(), name: String, specialty: String, requirements: [TokenType: Int]) {
        self.id = id
        self.name = name
        self.specialty = specialty
        self.requirements = requirements
    }
    
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
    
    static func twoCombinations() -> [Mathematician] {
        return [
            Mathematician(name: "Alan Turing", specialty: "Computing", requirements: [.sequence: 4, .even: 4]),
            Mathematician(name: "Carl F. Gauss", specialty: "Number Theory", requirements: [.even: 4, .odd: 4]),
            Mathematician(name: "Maryam Mirzakhani", specialty: "Number Theory", requirements: [.odd: 4, .prime: 4]),
            Mathematician(name: "Pythagoras", specialty: "Theorem", requirements: [.prime: 4, .square: 4]),
            Mathematician(name: "Srinivasa Ramanujan", specialty: "Partitions", requirements: [.sequence: 4, .square: 4])
        ]
    }
    
    static func threeCombinations() -> [Mathematician] {
        return [
            Mathematician(name: "Rene Descartes", specialty: "Geometry", requirements: [.sequence: 3, .even: 3, .odd: 3]),
            Mathematician(name: "Hypatia", specialty: "Astronomy", requirements: [.sequence: 3, .odd: 3, .prime: 3]),
            Mathematician(name: "G. W. Leibniz", specialty: "Calculus", requirements: [.sequence: 3, .even: 3, .square: 3]),
            Mathematician(name: "Emmy Noether", specialty: "Abstract Algebra", requirements: [.odd: 3, .prime: 3, .square: 3]),
            Mathematician(name: "Archimedes", specialty: "Mechanics", requirements: [.even: 3, .odd: 3, .square: 3])
        ]
    }
}

// MARK: - Real Card Database
struct RealCardDatabase {
    static func allCards() -> [Card] {
        return whiteCards() + redCards() + greenCards() + blueCards() + blackCards()
    }

    static func whiteCards() -> [Card] {
        return [
            Card(tier: .one, name: "Arithmetic Progression", cost: [.square: 1, .even: 2, .odd: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Fibonacci Base", cost: [.square: 1, .prime: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Harmonic Series", cost: [.square: 1, .prime: 1, .even: 1, .odd: 1], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Geometric Mean", cost: [.even: 3], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Linear Recurrence", cost: [.even: 2, .odd: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Tribonacci Sum", cost: [.square: 1, .prime: 1, .even: 1, .odd: 2], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Catalan Number", cost: [.square: 1, .sequence: 3, .even: 1], bonus: .sequence, points: 0),
            Card(tier: .one, name: "Lucas Sequence", cost: [.odd: 4], bonus: .sequence, points: 1),
            
            Card(tier: .two, name: "Pell Sequence", cost: [.square: 2, .prime: 2, .odd: 3], bonus: .sequence, points: 1),
            Card(tier: .two, name: "Golden Ratio", cost: [.sequence: 2, .prime: 3, .even: 3], bonus: .sequence, points: 1),
            Card(tier: .two, name: "Padovan Series", cost: [.square: 2, .prime: 4, .odd: 1], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Fibonacci Limit", cost: [.prime: 5], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Kolakoski String", cost: [.square: 3, .prime: 5], bonus: .sequence, points: 2),
            Card(tier: .two, name: "Recurrence Relation", cost: [.sequence: 6], bonus: .sequence, points: 3),
            
            Card(tier: .three, name: "Fractal Dimension", cost: [.square: 3, .prime: 5, .even: 3, .odd: 3], bonus: .sequence, points: 3),
            Card(tier: .three, name: "Apery's Constant", cost: [.square: 7], bonus: .sequence, points: 4),
            Card(tier: .three, name: "Sphere Packing", cost: [.square: 6, .sequence: 3, .prime: 3], bonus: .sequence, points: 4),
            Card(tier: .three, name: "Convergence Limit", cost: [.square: 7, .sequence: 3], bonus: .sequence, points: 5),
        ]
    }

    static func redCards() -> [Card] {
        return [
            Card(tier: .one, name: "Prime Number", cost: [.sequence: 3], bonus: .prime, points: 0),
            Card(tier: .one, name: "Twin Primes", cost: [.square: 3, .sequence: 1, .prime: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Smallest Factor", cost: [.even: 2, .odd: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Sophie Germain", cost: [.square: 2, .sequence: 2, .odd: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Prime Gap", cost: [.square: 1, .sequence: 2, .even: 1, .odd: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Unique Divisor", cost: [.square: 1, .sequence: 1, .even: 1, .odd: 1], bonus: .prime, points: 0),
            Card(tier: .one, name: "Safe Prime", cost: [.sequence: 2, .prime: 2], bonus: .prime, points: 0),
            Card(tier: .one, name: "Goldbach Sum", cost: [.sequence: 4], bonus: .prime, points: 1),
            
            Card(tier: .two, name: "Cousin Prime", cost: [.square: 3, .prime: 2, .even: 3], bonus: .prime, points: 1),
            Card(tier: .two, name: "Mersenne Number", cost: [.square: 3, .sequence: 2, .prime: 2], bonus: .prime, points: 1),
            Card(tier: .two, name: "Safe Prime Extended", cost: [.sequence: 1, .even: 4, .odd: 2], bonus: .prime, points: 2),
            Card(tier: .two, name: "Unique Factorization", cost: [.square: 5, .sequence: 3], bonus: .prime, points: 2),
            Card(tier: .two, name: "Irreducible Polynomial", cost: [.square: 5], bonus: .prime, points: 2),
            Card(tier: .two, name: "Chebyshev Bias", cost: [.prime: 6], bonus: .prime, points: 3),
            
            Card(tier: .three, name: "Fundamental Theorem", cost: [.square:3, .sequence:3, .even:5, .odd: 3], bonus: .prime, points: 3),
            Card(tier: .three, name: "Euclidean Proof", cost: [.odd: 7], bonus: .prime, points: 4),
            Card(tier: .three, name: "Dirichlet Theorem", cost: [.odd: 6, .prime: 3, .even: 3], bonus: .prime, points: 4),
            Card(tier: .three, name: "Riemann Zeta", cost: [.prime: 3, .odd: 7], bonus: .prime, points: 5),
        ]
    }

    static func greenCards() -> [Card] {
        return [
            Card(tier: .one, name: "Odd Integer", cost: [.sequence: 2, .even: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Gaussian Sum", cost: [.prime: 2, .even: 2], bonus: .odd, points: 0),
            Card(tier: .one, name: "Three-Term Oddity", cost: [.sequence: 1, .even: 3, .odd: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Unbalanced Set", cost: [.square: 1, .sequence: 1, .prime: 1, .even: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Mersenne Exponent", cost: [.square: 2, .sequence: 1, .prime: 1, .even: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Single Digit", cost: [.square: 2, .prime: 2, .even: 1], bonus: .odd, points: 0),
            Card(tier: .one, name: "Asymmetric Array", cost: [.prime: 3], bonus: .odd, points: 0),
            Card(tier: .one, name: "Odd Factor", cost: [.square: 4], bonus: .odd, points: 1),
            
            Card(tier: .two, name: "Sierpinski Number", cost: [.sequence: 3, .prime: 3, .odd: 2], bonus: .odd, points: 1),
            Card(tier: .two, name: "Non-Zero Root", cost: [.square: 2, .sequence: 2, .even: 3], bonus: .odd, points: 1),
            Card(tier: .two, name: "Single Value", cost: [.square: 1, .sequence: 4, .even: 2], bonus: .odd, points: 2),
            Card(tier: .two, name: "Unpaired Count", cost: [.odd: 5], bonus: .odd, points: 2),
            Card(tier: .two, name: "Fermat's Theorem", cost: [.even: 5, .odd: 3], bonus: .odd, points: 2),
            Card(tier: .two, name: "Catalan's Conjecture", cost: [.odd: 6], bonus: .odd, points: 3),
            
            Card(tier: .three, name: "Prime Number Theorem", cost: [.square:3, .sequence: 5, .prime:3, .even: 3], bonus: .odd, points: 3),
            Card(tier: .three, name: "Landau's Problem", cost: [.even: 6, .sequence: 3, .odd: 3], bonus: .odd, points: 4),
            Card(tier: .three, name: "Odd Harmonics", cost: [.even: 7], bonus: .odd, points: 4),
            Card(tier: .three, name: "Twin Conjecture", cost: [.even: 7, .odd: 3], bonus: .odd, points: 5),
        ]
    }

    static func blueCards() -> [Card] {
        return [
            Card(tier: .one, name: "Divisible by Two", cost: [.square: 2, .sequence: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Euler's Identity", cost: [.square: 1, .sequence: 1, .prime: 2, .odd: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Even Square Pairs", cost: [.square: 1, .sequence: 1, .prime: 1, .odd: 1], bonus: .even, points: 0),
            Card(tier: .one, name: "Power of Two", cost: [.prime: 1, .even: 1, .odd: 3], bonus: .even, points: 0),
            Card(tier: .one, name: "Binary Bit", cost: [.square: 3], bonus: .even, points: 0),
            Card(tier: .one, name: "Modulo Zero", cost: [.sequence: 1, .prime: 2, .odd: 2], bonus: .even, points: 0),
            Card(tier: .one, name: "Factorial Base", cost: [.square: 2, .odd: 2], bonus: .even, points: 0),
            Card(tier: .one, name: "Congruence Check", cost: [.prime: 4], bonus: .even, points: 1),
            
            Card(tier: .two, name: "Zero Pair", cost: [.prime: 3, .even: 2, .odd: 2], bonus: .even, points: 1),
            Card(tier: .two, name: "Double Value", cost: [.square: 3, .even: 2, .odd: 3], bonus: .even, points: 1),
            Card(tier: .two, name: "Parity Check", cost: [.sequence: 5, .even: 3], bonus: .even, points: 2),
            Card(tier: .two, name: "Lagrange's Four-Square", cost: [.even: 5], bonus: .even, points: 2),
            Card(tier: .two, name: "Diophantine Solution", cost: [.square: 4, .sequence: 2, .prime: 1], bonus: .even, points: 2),
            Card(tier: .two, name: "G-series", cost: [.even: 6], bonus: .even, points: 3),
            
            Card(tier: .three, name: "Turing Machine", cost: [.square: 5, .sequence: 3, .prime: 3, .odd: 3], bonus: .even, points: 3),
            Card(tier: .three, name: "Four-Color Theorem", cost: [.sequence: 7], bonus: .even, points: 4),
            Card(tier: .three, name: "Boolean Algebra", cost: [.sequence: 6, .square: 3, .even: 3], bonus: .even, points: 4),
            Card(tier: .three, name: "Gray Codes", cost: [.sequence: 7, .even: 3], bonus: .even, points: 5),
        ]
    }

    static func blackCards() -> [Card] {
        return [
            Card(tier: .one, name: "Integer Base", cost: [.sequence: 1, .prime: 1, .even: 1, .odd: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Tesselation Base", cost: [.prime: 1, .odd: 2], bonus: .square, points: 0),
            Card(tier: .one, name: "Perfect Power", cost: [.sequence: 2, .odd: 2], bonus: .square, points: 0),
            Card(tier: .one, name: "Tetrahedral Point", cost: [.square: 1, .prime: 3, .odd: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Cubic Root", cost: [.odd: 3], bonus: .square, points: 0),
            Card(tier: .one, name: "Polygonal Formula", cost: [.sequence: 1, .prime: 1, .even: 2, .odd: 1], bonus: .square, points: 0),
            Card(tier: .one, name: "Root Check", cost: [.sequence: 2, .prime: 1, .even: 2], bonus: .square, points: 0),
            Card(tier: .one, name: "Quadratic Term", cost: [.even: 4], bonus: .square, points: 1),
            
            Card(tier: .two, name: "Pythagorean Triplet", cost: [.sequence: 3, .even: 2, .odd: 2], bonus: .square, points: 1),
            Card(tier: .two, name: "Fourth Power", cost: [.square: 2, .sequence: 3, .odd: 3], bonus: .square, points: 1),
            Card(tier: .two, name: "Hexagonal Grid", cost: [.prime: 2, .even: 1, .odd: 4], bonus: .square, points: 2),
            Card(tier: .two, name: "Centered Polygonal", cost: [.sequence: 5], bonus: .square, points: 2),
            Card(tier: .two, name: "Sum of Squares", cost: [.prime: 3, .odd: 5], bonus: .square, points: 2),
            Card(tier: .two, name: "Gnomon Accumulation", cost: [.square: 6], bonus: .square, points: 3),
            
            Card(tier: .three, name: "Pythagorean Identity", cost: [.sequence: 3, .prime: 3, .even: 3, .odd: 5], bonus: .square, points: 3),
            Card(tier: .three, name: "Gauss Circle Problem", cost: [.prime: 7], bonus: .square, points: 4),
            Card(tier: .three, name: "Lattice Points", cost: [.square: 3, .prime: 6, .odd: 3], bonus: .square, points: 4),
            Card(tier: .three, name: "Sphere Geometry", cost: [.square: 3, .prime: 7], bonus: .square, points: 5),
        ]
    }
}
