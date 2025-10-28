//import Foundation
//
//// MARK: - Card & Mathematician Descriptions
//// One-sentence explanation for every card and mathematician
//
//struct CardDescription {
//    static let descriptions: [String: String] = [
//        // WHITE CARDS (SEQUENCE) - 18 Cards
//        "Arithmetic Progression": "Numbers increasing by a constant difference in perfect mathematical order.",
//        "Fibonacci Base": "The foundational sequence where each number is the sum of the two before it.",
//        "Harmonic Series": "Reciprocals of counting numbers that mysteriously diverge to infinity.",
//        "Geometric Mean": "The middle value in a multiplicative sequence creating exponential growth.",
//        "Linear Recurrence": "Functions defined by their own previous values creating elegant patterns.",
//        "Tribonacci Sum": "An extension of Fibonacci where each term sums three previous terms.",
//        "Catalan Number": "Recursive sequences appearing in trees, brackets, parentheses, and polygon divisions.",
//        "Lucas Sequence": "A companion to Fibonacci with different starting values but similar recursive structure.",
//        
//        "Pell Sequence": "Numbers solving the equation x² - 2y² = 1 in infinite integer solutions.",
//        "Golden Ratio": "The divine proportion φ ≈ 1.618 appearing throughout nature and art.",
//        "Padovan Series": "A lesser-known sequence where each term is the sum of two terms two positions back.",
//        "Fibonacci Limit": "The ratio between consecutive Fibonacci numbers converging to the golden ratio.",
//        "Kolakoski String": "A self-describing sequence that encodes its own run lengths.",
//        "Recurrence Relation": "Mathematical rules defining sequences through relationships with previous terms.",
//        
//        "Fractal Dimension": "Non-integer dimensions measuring the complexity of self-similar geometric shapes.",
//        "Apery's Constant": "The sum of reciprocals of cubes ζ(3) ≈ 1.202, mysteriously irrational.",
//        "Sphere Packing": "The optimal arrangement of spheres in space maximizing density.",
//        "Convergence Limit": "The stable value that sequences approach as their terms grow indefinitely.",
//        
//        // RED CARDS (PRIME) - 18 Cards
//        "Fundamental Unit": "The basic building block from which all composite numbers are constructed.",
//        "Twin Primes": "Two consecutive odd numbers separated by exactly one even number.",
//        "Smallest Factor": "The prime factor that divides a number with the least multiplicative power.",
//        "Sophie Germain": "A special prime p where 2p+1 is also prime, crucial for cryptography.",
//        "Prime Gap": "The spacing between consecutive primes that grows mysteriously as numbers increase.",
//        "Unique Divisor": "A number whose only divisors are one and itself, the definition of prime.",
//        "Safe Prime": "A prime p where (p-1)/2 is also prime, protecting against certain attacks.",
//        "Goldbach Sum": "Every even number greater than two is the sum of two prime numbers.",
//        
//        "Cousin Prime": "Two primes separated by exactly four, like 3 and 7 or 13 and 17.",
//        "Mersenne Number": "Numbers of the form 2ⁿ - 1 that often yield the largest known primes.",
//        "Safe Prime Extended": "Advanced applications of safe primes in secure cryptographic protocols.",
//        "Unique Factorization": "Every integer has exactly one way to express itself as a product of primes.",
//        "Irreducible Polynomial": "A polynomial that cannot be factored into lower-degree polynomials.",
//        "Chebyshev Bias": "Primes ≡ 3 (mod 4) appear slightly more often than primes ≡ 1 (mod 4).",
//        
//        "Fundamental Theorem": "The central theorem of arithmetic: unique prime factorization for all integers.",
//        "Euclidean Proof": "The ancient proof showing infinitely many primes exist by contradiction.",
//        "Dirichlet Theorem": "Arithmetic progressions contain infinitely many primes in regular distribution.",
//        "Riemann Zeta": "The zeta function ζ(s) connecting primes to deep analytical mathematics.",
//        
//        // GREEN CARDS (ODD) - 18 Cards
//        "Odd Integer": "Numbers not divisible by two, forming exactly half of all integers.",
//        "Gaussian Sum": "Sums over roots of unity encoding deep arithmetic properties in complex numbers.",
//        "Three-Term Oddity": "Mathematical patterns involving three odd numbers in specific relationships.",
//        "Unbalanced Set": "Collections of numbers with odd total count creating asymmetric properties.",
//        "Mersenne Exponent": "The exponent n in Mersenne numbers 2ⁿ - 1, often requiring odd n.",
//        "Single Digit": "Numbers from 1 to 9, the foundational digits of positional notation.",
//        "Asymmetric Array": "An arrangement with odd dimensions creating inherent asymmetry.",
//        "Odd Factor": "The odd part remaining after removing all factors of two from a number.",
//        
//        "Sierpinski Number": "Numbers k where k·2ⁿ + 1 is composite for all positive integers n.",
//        "Non-Zero Root": "An odd root of a number distinct from zero, revealing hidden structure.",
//        "Single Value": "A unique odd number standing alone in mathematical significance.",
//        "Unpaired Count": "A count of odd size that cannot be perfectly paired or halved.",
//        "Fermat's Theorem": "If p is an odd prime, then aᵖ⁻¹ ≡ 1 (mod p) for gcd(a,p)=1.",
//        "Catalan's Conjecture": "The conjecture that 3² and 2³ are the only consecutive perfect powers.",
//        
//        "Prime Number Theorem": "The density of primes decreases logarithmically as numbers grow larger.",
//        "Landau's Problem": "Four conjectures about primes, including twin primes and Goldbach variants.",
//        "Odd Harmonics": "In music, odd-numbered harmonics create the rich overtone series.",
//        "Twin Conjecture": "The unproven hypothesis that infinitely many twin prime pairs exist.",
//        
//        // BLUE CARDS (EVEN) - 18 Cards
//        "Divisible by Two": "The most basic even property: divisibility by the smallest prime.",
//        "Euler's Identity": "The equation e^(iπ) + 1 = 0 linking five fundamental mathematical constants.",
//        "Even Square Pairs": "Even numbers that can be expressed as the difference of two squares.",
//        "Power of Two": "Numbers of the form 2ⁿ appearing naturally in binary and computer science.",
//        "Binary Bit": "The fundamental unit of information in computers, representing 0 or 1.",
//        "Modulo Zero": "The property of divisibility expressed as a ≡ 0 (mod 2) for even numbers.",
//        "Factorial Base": "A numbering system using factorials as place values instead of powers.",
//        "Congruence Check": "Verifying that numbers are equivalent under modular arithmetic.",
//        
//        "Zero Pair": "Two values that sum to zero, fundamental to balanced equations.",
//        "Double Value": "A number multiplied by two, the most basic even transformation.",
//        "Parity Check": "A method for detecting single-bit errors in digital transmission.",
//        "Lagrange's Four-Square": "Every positive integer is a sum of at most four perfect squares.",
//        "Diophantine Solution": "Integer solutions to polynomial equations defining geometric curves.",
//        "G-series": "Advanced generating function series used in combinatorial mathematics.",
//        
//        "Turing Machine": "The theoretical model of computation deciding what is algorithmically computable.",
//        "Four-Color Theorem": "Any map can be colored with at most four colors without adjacent conflicts.",
//        "Boolean Algebra": "Logical operations (AND, OR, NOT) forming the foundation of digital circuits.",
//        "Gray Codes": "Binary sequences where consecutive numbers differ in exactly one bit.",
//        
//        // BLACK CARDS (SQUARE) - 18 Cards
//        "Integer Base": "A whole number that when multiplied by itself yields a perfect square.",
//        "Tesselation Base": "Shapes that perfectly tile a plane, often involving square grids.",
//        "Perfect Power": "Numbers expressible as aⁿ for integers a and n ≥ 2.",
//        "Tetrahedral Point": "Points in a tetrahedral lattice, extending square lattices to 3D.",
//        "Cubic Root": "The number that when multiplied by itself three times yields the original.",
//        "Polygonal Formula": "The formula for counting dots in regular polygonal arrangements.",
//        "Root Check": "Verification that a number is a perfect root of another number.",
//        "Quadratic Term": "The degree-2 term in a polynomial defining parabolic behavior.",
//        
//        "Pythagorean Triplet": "Three integers (a,b,c) satisfying a² + b² = c² forming right triangles.",
//        "Fourth Power": "A number raised to the power of four, emphasizing exponential growth.",
//        "Hexagonal Grid": "A grid of hexagons where each hexagon touches six neighbors.",
//        "Centered Polygonal": "Numbers counting dots in polygons with a dot at the center.",
//        "Sum of Squares": "Numbers expressible as the sum of two or more perfect squares.",
//        "Gnomon Accumulation": "L-shaped figures whose areas sum to square numbers.",
//        
//        "Pythagorean Identity": "The fundamental trigonometric identity sin²θ + cos²θ = 1.",
//        "Gauss Circle Problem": "Counting lattice points inside circles, a deep problem in analytic number theory.",
//        "Lattice Points": "Integer coordinate points forming a regular grid throughout space.",
//        "Sphere Geometry": "The geometric properties of spheres including surface area and volume.",
//        
//        // MATHEMATICIANS (3 points each)
//        "Alan Turing": "Pioneer of computer science and artificial intelligence.",
//        "Carl F. Gauss": "The Prince of Mathematicians, master of number theory and statistics.",
//        "Sophie Germain": "Groundbreaking number theorist who made major contributions to Fermat's Last Theorem.",
//        "Pythagoras": "Ancient Greek mathematician whose theorem defines the relationship between triangle sides.",
//        "Srinivasa Ramanujan": "Intuitive genius who discovered thousands of remarkable mathematical identities.",
//        "Rene Descartes": "Founder of analytic geometry, bridging algebra and geometry.",
//        "Hypatia": "Ancient astronomer and mathematician, first famous female mathematician.",
//        "G. W. Leibniz": "Co-inventor of calculus and pioneer of symbolic mathematics.",
//        "Emmy Noether": "Revolutionary abstract algebraist whose theorem connects symmetry and conservation laws.",
//        "Archimedes": "Ancient Greek mathematician who invented calculus concepts 2000 years early.",
//    ]
//    
//    static func description(for name: String) -> String {
//        return descriptions[name] ?? "A card of mathematical significance."
//    }
//}
