struct CardArtwork {
    let name: String
    let theme: String
    let asciiArt: String
    let opacity: Double = 0.3
    let centered: Bool = true
}

struct CardArtworkDatabase {
    static let artworks: [String: CardArtwork] = [
        "Apery's Constant": CardArtwork(
            name: "Apery's Constant",
            theme: "infinite_symbol",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                                         │\n    │          ╭───╮         ╭───╮           │\n    │         ╱     ╲       ╱     ╲          │\n    │        │   ∞   │     │   ∞   │         │\n    │         ╲     ╱       ╲     ╱          │\n    │          ╰───╯         ╰───╯           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Arithmetic Progression": CardArtwork(
            name: "Arithmetic Progression",
            theme: "number_sequence",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      1  →  1  →  2  →  3  →  5        │\n    │                                         │\n    │      ┌─────────────────────────────┐   │\n    │      │                             │   │\n    │      │    Sequence Pattern         │   │\n    │      │                             │   │\n    │      └─────────────────────────────┘   │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Asymmetric Array": CardArtwork(
            name: "Asymmetric Array",
            theme: "symmetry_axis",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                  │                     │\n    │              ╱   │   ╲                 │\n    │             ╱    │    ╲                │\n    │            │     │     │               │\n    │             ╲    │    ╱                │\n    │              ╲   │   ╱                 │\n    │                  │                     │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Binary Bit": CardArtwork(
            name: "Binary Bit",
            theme: "geometric_grid",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      ┌─────┬─────┬─────┬─────┐        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      └─────┴─────┴─────┴─────┘        │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Catalan Number": CardArtwork(
            name: "Catalan Number",
            theme: "pascals_triangle",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                   1                    │\n    │                  1 1                   │\n    │                 1 2 1                  │\n    │                1 3 3 1                 │\n    │               1 4 6 4 1                │\n    │              1 5 10 10 5 1             │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Catalan's Conjecture": CardArtwork(
            name: "Catalan's Conjecture",
            theme: "pascals_triangle",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                   1                    │\n    │                  1 1                   │\n    │                 1 2 1                  │\n    │                1 3 3 1                 │\n    │               1 4 6 4 1                │\n    │              1 5 10 10 5 1             │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Centered Polygonal": CardArtwork(
            name: "Centered Polygonal",
            theme: "hexagonal_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │        ╱╲    ╱╲    ╱╲    ╱╲            │\n    │       ╱  ╲  ╱  ╲  ╱  ╲  ╱  ╲           │\n    │       ╲  ╱  ╲  ╱  ╲  ╱  ╲  ╱           │\n    │        ╲╱    ╲╱    ╲╱    ╲╱            │\n    │        ╱╲    ╱╲    ╱╲    ╱╲            │\n    │       ╱  ╲  ╱  ╲  ╱  ╲  ╱  ╲           │\n    │       ╲  ╱  ╲  ╱  ╲  ╱  ╲  ╱           │\n    │        ╲╱    ╲╱    ╲╱    ╲╱            │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Chebyshev Bias": CardArtwork(
            name: "Chebyshev Bias",
            theme: "prime_factors",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │           2, 3, 5, 7, 11               │\n    │           13, 17, 19, 23               │\n    │                                         │\n    │         ◆ ◇ ◆ ◇ ◆ ◇ ◆ ◇               │\n    │         ◇ ◆ ◇ ◆ ◇ ◆ ◇ ◆               │\n    │         ◆ ◇ ◆ ◇ ◆ ◇ ◆ ◇               │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Congruence Check": CardArtwork(
            name: "Congruence Check",
            theme: "symmetry_axis",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                  │                     │\n    │              ╱   │   ╲                 │\n    │             ╱    │    ╲                │\n    │            │     │     │               │\n    │             ╲    │    ╱                │\n    │              ╲   │   ╱                 │\n    │                  │                     │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Cousin Prime": CardArtwork(
            name: "Cousin Prime",
            theme: "prime_peaks",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │          ▲      ▲      ▲      ▲        │\n    │         ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲       │\n    │        ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲      │\n    │       ╱  2  ╲╱  3  ╲╱  5  ╲╱  7  ╲     │\n    │      ╱───────╱─────────────────────╲    │\n    │     ╱                               ╲   │\n    │    ╱─────────────────────────────────╲  │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Cubic Root": CardArtwork(
            name: "Cubic Root",
            theme: "pythagorean_triangle",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                  ╱╲                    │\n    │                 ╱  ╲                   │\n    │                ╱    ╲                  │\n    │               ╱      ╲                 │\n    │              ╱________╲                │\n    │             ╱          ╲               │\n    │            ╱            ╲              │\n    │           ╱              ╲             │\n    │          ╱________________╲            │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Diophantine Solution": CardArtwork(
            name: "Diophantine Solution",
            theme: "mathematical_symbols",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ∑  ∏  ∫  ∞  √  π  φ           │\n    │                                         │\n    │         ±  ≈  ≠  ≡  ⊕  ⊗  ⊂           │\n    │                                         │\n    │         ∧  ∨  ¬  ∀  ∃  ∇  ∂           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Divisible by Two": CardArtwork(
            name: "Divisible by Two",
            theme: "even_pattern",
            asciiArt: ""
        ),
        "Double Value": CardArtwork(
            name: "Double Value",
            theme: "even_pattern",
            asciiArt: ""
        ),
        "Euclidean Proof": CardArtwork(
            name: "Euclidean Proof",
            theme: "mathematical_symbols",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ∑  ∏  ∫  ∞  √  π  φ           │\n    │                                         │\n    │         ±  ≈  ≠  ≡  ⊕  ⊗  ⊂           │\n    │                                         │\n    │         ∧  ∨  ¬  ∀  ∃  ∇  ∂           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Euler's Identity": CardArtwork(
            name: "Euler's Identity",
            theme: "mathematical_symbols",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ∑  ∏  ∫  ∞  √  π  φ           │\n    │                                         │\n    │         ±  ≈  ≠  ≡  ⊕  ⊗  ⊂           │\n    │                                         │\n    │         ∧  ∨  ¬  ∀  ∃  ∇  ∂           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Even Square Pairs": CardArtwork(
            name: "Even Square Pairs",
            theme: "even_pattern",
            asciiArt: ""
        ),
        "Factorial Base": CardArtwork(
            name: "Factorial Base",
            theme: "pascals_triangle",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                   1                    │\n    │                  1 1                   │\n    │                 1 2 1                  │\n    │                1 3 3 1                 │\n    │               1 4 6 4 1                │\n    │              1 5 10 10 5 1             │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Fermat's Theorem": CardArtwork(
            name: "Fermat's Theorem",
            theme: "pythagorean_triangle",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                  ╱╲                    │\n    │                 ╱  ╲                   │\n    │                ╱    ╲                  │\n    │               ╱      ╲                 │\n    │              ╱________╲                │\n    │             ╱          ╲               │\n    │            ╱            ╲              │\n    │           ╱              ╲             │\n    │          ╱________________╲            │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Fibonacci Base": CardArtwork(
            name: "Fibonacci Base",
            theme: "fibonacci_spiral",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ╔════════════════════╗         │\n    │         ║    ╔════════╗      ║         │\n    │         ║    ║ ╔════╗ ║      ║         │\n    │         ║    ║ ║ ╔╗ ║ ║      ║         │\n    │         ║    ║ ║ ╚╝ ║ ║      ║         │\n    │         ║    ║ ╚════╝ ║      ║         │\n    │         ║    ╚════════╝      ║         │\n    │         ╚════════════════════╝         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Fibonacci Limit": CardArtwork(
            name: "Fibonacci Limit",
            theme: "fibonacci_spiral",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ╔════════════════════╗         │\n    │         ║    ╔════════╗      ║         │\n    │         ║    ║ ╔════╗ ║      ║         │\n    │         ║    ║ ║ ╔╗ ║ ║      ║         │\n    │         ║    ║ ║ ╚╝ ║ ║      ║         │\n    │         ║    ║ ╚════╝ ║      ║         │\n    │         ║    ╚════════╝      ║         │\n    │         ╚════════════════════╝         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Four-Color Theorem": CardArtwork(
            name: "Four-Color Theorem",
            theme: "geometric_grid",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      ┌─────┬─────┬─────┬─────┐        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      └─────┴─────┴─────┴─────┘        │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Fourth Power": CardArtwork(
            name: "Fourth Power",
            theme: "square_numbers",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      □  □□  □□□  □□□□  □□□□□           │\n    │         □□  □□□  □□□□  □□□□□           │\n    │             □□□  □□□□  □□□□□           │\n    │                  □□□□  □□□□□           │\n    │      1    4    9   16    25            │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Fractal Dimension": CardArtwork(
            name: "Fractal Dimension",
            theme: "fractal_tree",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                   *                    │\n    │                  * *                   │\n    │                 * * *                  │\n    │                * * * *                 │\n    │               * * * * *                │\n    │              * * * * * *               │\n    │             * * * * * * *              │\n    │            * * * * * * * *             │\n    │                  ║ ║                   │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Fundamental Theorem": CardArtwork(
            name: "Fundamental Theorem",
            theme: "mathematical_symbols",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ∑  ∏  ∫  ∞  √  π  φ           │\n    │                                         │\n    │         ±  ≈  ≠  ≡  ⊕  ⊗  ⊂           │\n    │                                         │\n    │         ∧  ∨  ¬  ∀  ∃  ∇  ∂           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Fundamental Unit": CardArtwork(
            name: "Fundamental Unit",
            theme: "prime_peaks",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │          ▲      ▲      ▲      ▲        │\n    │         ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲       │\n    │        ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲      │\n    │       ╱  2  ╲╱  3  ╲╱  5  ╲╱  7  ╲     │\n    │      ╱───────╱─────────────────────╲    │\n    │     ╱                               ╲   │\n    │    ╱─────────────────────────────────╲  │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "G-series": CardArtwork(
            name: "G-series",
            theme: "number_sequence",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      1  →  1  →  2  →  3  →  5        │\n    │                                         │\n    │      ┌─────────────────────────────┐   │\n    │      │                             │   │\n    │      │    Sequence Pattern         │   │\n    │      │                             │   │\n    │      └─────────────────────────────┘   │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),

        "Gaussian Sum": CardArtwork(
            name: "Gaussian Sum",
            theme: "number_sequence",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      1  →  1  →  2  →  3  →  5        │\n    │                                         │\n    │      ┌─────────────────────────────┐   │\n    │      │                             │   │\n    │      │    Sequence Pattern         │   │\n    │      │                             │   │\n    │      └─────────────────────────────┘   │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Geometric Mean": CardArtwork(
            name: "Geometric Mean",
            theme: "golden_ratio",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │              φ ≈ 1.618                │\n    │          ╔════════════════╗            │\n    │          ║                ║            │\n    │          ║    ╭────╮      ║            │\n    │          ║    │ ∘  │      ║            │\n    │          ║    ╰────╯      ║            │\n    │          ╚════════════════╝            │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Gnomon Accumulation": CardArtwork(
            name: "Gnomon Accumulation",
            theme: "geometric_grid",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      ┌─────┬─────┬─────┬─────┐        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      └─────┴─────┴─────┴─────┘        │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Goldbach Sum": CardArtwork(
            name: "Goldbach Sum",
            theme: "prime_peaks",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │          ▲      ▲      ▲      ▲        │\n    │         ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲       │\n    │        ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲      │\n    │       ╱  2  ╲╱  3  ╲╱  5  ╲╱  7  ╲     │\n    │      ╱───────╱─────────────────────╲    │\n    │     ╱                               ╲   │\n    │    ╱─────────────────────────────────╲  │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Golden Ratio": CardArtwork(
            name: "Golden Ratio",
            theme: "golden_ratio",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │              φ ≈ 1.618                │\n    │          ╔════════════════╗            │\n    │          ║                ║            │\n    │          ║    ╭────╮      ║            │\n    │          ║    │ ∘  │      ║            │\n    │          ║    ╰────╯      ║            │\n    │          ╚════════════════╝            │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Harmonic Series": CardArtwork(
            name: "Harmonic Series",
            theme: "number_sequence",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      1  →  1  →  2  →  3  →  5        │\n    │                                         │\n    │      ┌─────────────────────────────┐   │\n    │      │                             │   │\n    │      │    Sequence Pattern         │   │\n    │      │                             │   │\n    │      └─────────────────────────────┘   │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Hexagonal Grid": CardArtwork(
            name: "Hexagonal Grid",
            theme: "hexagonal_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │        ╱╲    ╱╲    ╱╲    ╱╲            │\n    │       ╱  ╲  ╱  ╲  ╱  ╲  ╱  ╲           │\n    │       ╲  ╱  ╲  ╱  ╲  ╱  ╲  ╱           │\n    │        ╲╱    ╲╱    ╲╱    ╲╱            │\n    │        ╱╲    ╱╲    ╱╲    ╱╲            │\n    │       ╱  ╲  ╱  ╲  ╱  ╲  ╱  ╲           │\n    │       ╲  ╱  ╲  ╱  ╲  ╱  ╲  ╱           │\n    │        ╲╱    ╲╱    ╲╱    ╲╱            │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Integer Base": CardArtwork(
            name: "Integer Base",
            theme: "square_numbers",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      □  □□  □□□  □□□□  □□□□□           │\n    │         □□  □□□  □□□□  □□□□□           │\n    │             □□□  □□□□  □□□□□           │\n    │                  □□□□  □□□□□           │\n    │      1    4    9   16    25            │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Irreducible Polynomial": CardArtwork(
            name: "Irreducible Polynomial",
            theme: "prime_factors",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │           2, 3, 5, 7, 11               │\n    │           13, 17, 19, 23               │\n    │                                         │\n    │         ◆ ◇ ◆ ◇ ◆ ◇ ◆ ◇               │\n    │         ◇ ◆ ◇ ◆ ◇ ◆ ◇ ◆               │\n    │         ◆ ◇ ◆ ◇ ◆ ◇ ◆ ◇               │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Kolakoski String": CardArtwork(
            name: "Kolakoski String",
            theme: "number_sequence",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      1  →  1  →  2  →  3  →  5        │\n    │                                         │\n    │      ┌─────────────────────────────┐   │\n    │      │                             │   │\n    │      │    Sequence Pattern         │   │\n    │      │                             │   │\n    │      └─────────────────────────────┘   │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Lagrange's Four-Square": CardArtwork(
            name: "Lagrange's Four-Square",
            theme: "square_numbers",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      □  □□  □□□  □□□□  □□□□□           │\n    │         □□  □□□  □□□□  □□□□□           │\n    │             □□□  □□□□  □□□□□           │\n    │                  □□□□  □□□□□           │\n    │      1    4    9   16    25            │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Landau's Problem": CardArtwork(
            name: "Landau's Problem",
            theme: "prime_peaks",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │          ▲      ▲      ▲      ▲        │\n    │         ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲       │\n    │        ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲      │\n    │       ╱  2  ╲╱  3  ╲╱  5  ╲╱  7  ╲     │\n    │      ╱───────╱─────────────────────╲    │\n    │     ╱                               ╲   │\n    │    ╱─────────────────────────────────╲  │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Linear Recurrence": CardArtwork(
            name: "Linear Recurrence",
            theme: "number_sequence",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      1  →  1  →  2  →  3  →  5        │\n    │                                         │\n    │      ┌─────────────────────────────┐   │\n    │      │                             │   │\n    │      │    Sequence Pattern         │   │\n    │      │                             │   │\n    │      └─────────────────────────────┘   │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Lucas Sequence": CardArtwork(
            name: "Lucas Sequence",
            theme: "fibonacci_spiral",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ╔════════════════════╗         │\n    │         ║    ╔════════╗      ║         │\n    │         ║    ║ ╔════╗ ║      ║         │\n    │         ║    ║ ║ ╔╗ ║ ║      ║         │\n    │         ║    ║ ║ ╚╝ ║ ║      ║         │\n    │         ║    ║ ╚════╝ ║      ║         │\n    │         ║    ╚════════╝      ║         │\n    │         ╚════════════════════╝         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Mersenne Exponent": CardArtwork(
            name: "Mersenne Exponent",
            theme: "prime_peaks",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │          ▲      ▲      ▲      ▲        │\n    │         ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲       │\n    │        ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲      │\n    │       ╱  2  ╲╱  3  ╲╱  5  ╲╱  7  ╲     │\n    │      ╱───────╱─────────────────────╲    │\n    │     ╱                               ╲   │\n    │    ╱─────────────────────────────────╲  │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Mersenne Number": CardArtwork(
            name: "Mersenne Number",
            theme: "prime_peaks",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │          ▲      ▲      ▲      ▲        │\n    │         ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲       │\n    │        ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲      │\n    │       ╱  2  ╲╱  3  ╲╱  5  ╲╱  7  ╲     │\n    │      ╱───────╱─────────────────────╲    │\n    │     ╱                               ╲   │\n    │    ╱─────────────────────────────────╲  │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Modulo Zero": CardArtwork(
            name: "Modulo Zero",
            theme: "geometric_grid",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      ┌─────┬─────┬─────┬─────┐        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      └─────┴─────┴─────┴─────┘        │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Non-Zero Root": CardArtwork(
            name: "Non-Zero Root",
            theme: "mathematical_symbols",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ∑  ∏  ∫  ∞  √  π  φ           │\n    │                                         │\n    │         ±  ≈  ≠  ≡  ⊕  ⊗  ⊂           │\n    │                                         │\n    │         ∧  ∨  ¬  ∀  ∃  ∇  ∂           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Odd Factor": CardArtwork(
            name: "Odd Factor",
            theme: "odd_even_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Odd Integer": CardArtwork(
            name: "Odd Integer",
            theme: "odd_even_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Padovan Series": CardArtwork(
            name: "Padovan Series",
            theme: "fibonacci_spiral",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ╔════════════════════╗         │\n    │         ║    ╔════════╗      ║         │\n    │         ║    ║ ╔════╗ ║      ║         │\n    │         ║    ║ ║ ╔╗ ║ ║      ║         │\n    │         ║    ║ ║ ╚╝ ║ ║      ║         │\n    │         ║    ║ ╚════╝ ║      ║         │\n    │         ║    ╚════════╝      ║         │\n    │         ╚════════════════════╝         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Parity Check": CardArtwork(
            name: "Parity Check",
            theme: "odd_even_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Pell Sequence": CardArtwork(
            name: "Pell Sequence",
            theme: "fibonacci_spiral",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ╔════════════════════╗         │\n    │         ║    ╔════════╗      ║         │\n    │         ║    ║ ╔════╗ ║      ║         │\n    │         ║    ║ ║ ╔╗ ║ ║      ║         │\n    │         ║    ║ ║ ╚╝ ║ ║      ║         │\n    │         ║    ║ ╚════╝ ║      ║         │\n    │         ║    ╚════════╝      ║         │\n    │         ╚════════════════════╝         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Perfect Power": CardArtwork(
            name: "Perfect Power",
            theme: "square_numbers",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      □  □□  □□□  □□□□  □□□□□           │\n    │         □□  □□□  □□□□  □□□□□           │\n    │             □□□  □□□□  □□□□□           │\n    │                  □□□□  □□□□□           │\n    │      1    4    9   16    25            │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Polygonal Formula": CardArtwork(
            name: "Polygonal Formula",
            theme: "hexagonal_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │        ╱╲    ╱╲    ╱╲    ╱╲            │\n    │       ╱  ╲  ╱  ╲  ╱  ╲  ╱  ╲           │\n    │       ╲  ╱  ╲  ╱  ╲  ╱  ╲  ╱           │\n    │        ╲╱    ╲╱    ╲╱    ╲╱            │\n    │        ╱╲    ╱╲    ╱╲    ╱╲            │\n    │       ╱  ╲  ╱  ╲  ╱  ╲  ╱  ╲           │\n    │       ╲  ╱  ╲  ╱  ╲  ╱  ╲  ╱           │\n    │        ╲╱    ╲╱    ╲╱    ╲╱            │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Power of Two": CardArtwork(
            name: "Power of Two",
            theme: "square_numbers",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      □  □□  □□□  □□□□  □□□□□           │\n    │         □□  □□□  □□□□  □□□□□           │\n    │             □□□  □□□□  □□□□□           │\n    │                  □□□□  □□□□□           │\n    │      1    4    9   16    25            │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Prime Gap": CardArtwork(
            name: "Prime Gap",
            theme: "prime_peaks",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │          ▲      ▲      ▲      ▲        │\n    │         ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲       │\n    │        ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲      │\n    │       ╱  2  ╲╱  3  ╲╱  5  ╲╱  7  ╲     │\n    │      ╱───────╱─────────────────────╲    │\n    │     ╱                               ╲   │\n    │    ╱─────────────────────────────────╲  │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Prime Number Theorem": CardArtwork(
            name: "Prime Number Theorem",
            theme: "mathematical_symbols",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ∑  ∏  ∫  ∞  √  π  φ           │\n    │                                         │\n    │         ±  ≈  ≠  ≡  ⊕  ⊗  ⊂           │\n    │                                         │\n    │         ∧  ∨  ¬  ∀  ∃  ∇  ∂           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Pythagorean Identity": CardArtwork(
            name: "Pythagorean Identity",
            theme: "pythagorean_triangle",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                  ╱╲                    │\n    │                 ╱  ╲                   │\n    │                ╱    ╲                  │\n    │               ╱      ╲                 │\n    │              ╱________╲                │\n    │             ╱          ╲               │\n    │            ╱            ╲              │\n    │           ╱              ╲             │\n    │          ╱________________╲            │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Pythagorean Triplet": CardArtwork(
            name: "Pythagorean Triplet",
            theme: "pythagorean_triangle",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                  ╱╲                    │\n    │                 ╱  ╲                   │\n    │                ╱    ╲                  │\n    │               ╱      ╲                 │\n    │              ╱________╲                │\n    │             ╱          ╲               │\n    │            ╱            ╲              │\n    │           ╱              ╲             │\n    │          ╱________________╲            │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Quadratic Term": CardArtwork(
            name: "Quadratic Term",
            theme: "square_numbers",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      □  □□  □□□  □□□□  □□□□□           │\n    │         □□  □□□  □□□□  □□□□□           │\n    │             □□□  □□□□  □□□□□           │\n    │                  □□□□  □□□□□           │\n    │      1    4    9   16    25            │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Recurrence Relation": CardArtwork(
            name: "Recurrence Relation",
            theme: "number_sequence",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      1  →  1  →  2  →  3  →  5        │\n    │                                         │\n    │      ┌─────────────────────────────┐   │\n    │      │                             │   │\n    │      │    Sequence Pattern         │   │\n    │      │                             │   │\n    │      └─────────────────────────────┘   │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Root Check": CardArtwork(
            name: "Root Check",
            theme: "mathematical_symbols",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ∑  ∏  ∫  ∞  √  π  φ           │\n    │                                         │\n    │         ±  ≈  ≠  ≡  ⊕  ⊗  ⊂           │\n    │                                         │\n    │         ∧  ∨  ¬  ∀  ∃  ∇  ∂           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Safe Prime": CardArtwork(
            name: "Safe Prime",
            theme: "prime_peaks",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │          ▲      ▲      ▲      ▲        │\n    │         ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲       │\n    │        ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲      │\n    │       ╱  2  ╲╱  3  ╲╱  5  ╲╱  7  ╲     │\n    │      ╱───────╱─────────────────────╲    │\n    │     ╱                               ╲   │\n    │    ╱─────────────────────────────────╲  │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Safe Prime Extended": CardArtwork(
            name: "Safe Prime Extended",
            theme: "prime_peaks",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │          ▲      ▲      ▲      ▲        │\n    │         ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲       │\n    │        ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲      │\n    │       ╱  2  ╲╱  3  ╲╱  5  ╲╱  7  ╲     │\n    │      ╱───────╱─────────────────────╲    │\n    │     ╱                               ╲   │\n    │    ╱─────────────────────────────────╲  │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Sierpinski Number": CardArtwork(
            name: "Sierpinski Number",
            theme: "fractal_tree",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                   *                    │\n    │                  * *                   │\n    │                 * * *                  │\n    │                * * * *                 │\n    │               * * * * *                │\n    │              * * * * * *               │\n    │             * * * * * * *              │\n    │            * * * * * * * *             │\n    │                  ║ ║                   │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Single Digit": CardArtwork(
            name: "Single Digit",
            theme: "odd_even_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Single Value": CardArtwork(
            name: "Single Value",
            theme: "odd_even_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Smallest Factor": CardArtwork(
            name: "Smallest Factor",
            theme: "prime_factors",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │           2, 3, 5, 7, 11               │\n    │           13, 17, 19, 23               │\n    │                                         │\n    │         ◆ ◇ ◆ ◇ ◆ ◇ ◆ ◇               │\n    │         ◇ ◆ ◇ ◆ ◇ ◆ ◇ ◆               │\n    │         ◆ ◇ ◆ ◇ ◆ ◇ ◆ ◇               │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Sophie Germain": CardArtwork(
            name: "Sophie Germain",
            theme: "prime_peaks",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │          ▲      ▲      ▲      ▲        │\n    │         ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲       │\n    │        ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲      │\n    │       ╱  2  ╲╱  3  ╲╱  5  ╲╱  7  ╲     │\n    │      ╱───────╱─────────────────────╲    │\n    │     ╱                               ╲   │\n    │    ╱─────────────────────────────────╲  │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Sum of Squares": CardArtwork(
            name: "Sum of Squares",
            theme: "square_numbers",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      □  □□  □□□  □□□□  □□□□□           │\n    │         □□  □□□  □□□□  □□□□□           │\n    │             □□□  □□□□  □□□□□           │\n    │                  □□□□  □□□□□           │\n    │      1    4    9   16    25            │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Tesselation Base": CardArtwork(
            name: "Tesselation Base",
            theme: "geometric_grid",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      ┌─────┬─────┬─────┬─────┐        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      └─────┴─────┴─────┴─────┘        │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Tetrahedral Point": CardArtwork(
            name: "Tetrahedral Point",
            theme: "geometric_grid",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      ┌─────┬─────┬─────┬─────┐        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      └─────┴─────┴─────┴─────┘        │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Three-Term Oddity": CardArtwork(
            name: "Three-Term Oddity",
            theme: "odd_even_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Tribonacci Sum": CardArtwork(
            name: "Tribonacci Sum",
            theme: "fibonacci_spiral",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ╔════════════════════╗         │\n    │         ║    ╔════════╗      ║         │\n    │         ║    ║ ╔════╗ ║      ║         │\n    │         ║    ║ ║ ╔╗ ║ ║      ║         │\n    │         ║    ║ ║ ╚╝ ║ ║      ║         │\n    │         ║    ║ ╚════╝ ║      ║         │\n    │         ║    ╚════════╝      ║         │\n    │         ╚════════════════════╝         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Turing Machine": CardArtwork(
            name: "Turing Machine",
            theme: "geometric_grid",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      ┌─────┬─────┬─────┬─────┐        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      ├─────┼─────┼─────┼─────┤        │\n    │      │     │     │     │     │        │\n    │      └─────┴─────┴─────┴─────┘        │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Twin Primes": CardArtwork(
            name: "Twin Primes",
            theme: "prime_peaks",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │          ▲      ▲      ▲      ▲        │\n    │         ╱ ╲    ╱ ╲    ╱ ╲    ╱ ╲       │\n    │        ╱   ╲  ╱   ╲  ╱   ╲  ╱   ╲      │\n    │       ╱  2  ╲╱  3  ╲╱  5  ╲╱  7  ╲     │\n    │      ╱───────╱─────────────────────╲    │\n    │     ╱                               ╲   │\n    │    ╱─────────────────────────────────╲  │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Unbalanced Set": CardArtwork(
            name: "Unbalanced Set",
            theme: "odd_even_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Unique Divisor": CardArtwork(
            name: "Unique Divisor",
            theme: "prime_factors",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │           2, 3, 5, 7, 11               │\n    │           13, 17, 19, 23               │\n    │                                         │\n    │         ◆ ◇ ◆ ◇ ◆ ◇ ◆ ◇               │\n    │         ◇ ◆ ◇ ◆ ◇ ◆ ◇ ◆               │\n    │         ◆ ◇ ◆ ◇ ◆ ◇ ◆ ◇               │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Unique Factorization": CardArtwork(
            name: "Unique Factorization",
            theme: "prime_factors",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │           2, 3, 5, 7, 11               │\n    │           13, 17, 19, 23               │\n    │                                         │\n    │         ◆ ◇ ◆ ◇ ◆ ◇ ◆ ◇               │\n    │         ◇ ◆ ◇ ◆ ◇ ◆ ◇ ◆               │\n    │         ◆ ◇ ◆ ◇ ◆ ◇ ◆ ◇               │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Unpaired Count": CardArtwork(
            name: "Unpaired Count",
            theme: "odd_even_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │      O E O E O E O E O E O E           │\n    │      E O E O E O E O E O E O           │\n    │                                         │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Zero Pair": CardArtwork(
            name: "Zero Pair",
            theme: "even_pattern",
            asciiArt: ""
        ),
        "Convergence Limit": CardArtwork(
            name: "Convergence Limit",
            theme: "infinite_convergence",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         →→→→→→→→→→→→→→→→→→→→→        │\n    │        ╱╲                              │\n    │       ╱  ╲        ╭────────╮           │\n    │      ╱    ╲       │  Limit │           │\n    │     ╱      ╲  →   │   L    │           │\n    │    ╱        ╲     │        │           │\n    │   ╱          ╲    ╰────────╯           │\n    │  ╱            ╲                        │\n    │ ╱              ╲                       │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Dirichlet Theorem": CardArtwork(
            name: "Dirichlet Theorem",
            theme: "prime_distribution",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │     2, 5, 7, 11, 13, 17, 19, 23        │\n    │                                         │\n    │     ◆ ◆ ◆ ◆ ◆ ◆ ◆ ◆ ◆ ◆ ◆             │\n    │     ◆ ◆ ◆ ◆ ◆ ◆ ◆ ◆ ◆ ◆ ◆             │\n    │                                         │\n    │     ∞ primes in arithmetic sequences   │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Riemann Zeta": CardArtwork(
            name: "Riemann Zeta",
            theme: "complex_function",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │                 ζ(s)                   │\n    │                  │                     │\n    │         ───────┼─────────              │\n    │        ╱        │        ╲             │\n    │       ╱         │         ╲            │\n    │      ╱    ●     │    ●     ╲           │\n    │     ╱  zeros on│ critical   ╲          │\n    │    ╱   line Re=│ 1/2         ╲        │\n    │   ╱            │              ╲       │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Odd Harmonics": CardArtwork(
            name: "Odd Harmonics",
            theme: "wave_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │   1 ╱╲    ╱╲    ╱╲    ╱╲    ╱╲        │\n    │     ╱  ╲  ╱  ╲  ╱  ╲  ╱  ╲  ╱  ╲       │\n    │    ╱    ╲╱    ╲╱    ╲╱    ╲╱    ╲      │\n    │ ─────────────────────────────────────  │\n    │   1/3 ╱╲╱╲╱╲╱╲╱╲╱╲╱╲╱╲╱╲╱╲╱╲╱╲╱╲  │\n    │                                         │\n    │   1/5 │││││││││││││││││││││││││││││    │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Twin Conjecture": CardArtwork(
            name: "Twin Conjecture",
            theme: "prime_pairs",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │   (3,5) (5,7) (11,13) (17,19) ...     │\n    │    ◆◆    ◆◆    ◆◆◆     ◆◆◆            │\n    │                                         │\n    │   Twin Primes: p and p+2               │\n    │                                         │\n    │   Are there infinitely many?            │\n    │   ✓ Still an open question             │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Boolean Algebra": CardArtwork(
            name: "Boolean Algebra",
            theme: "logic_gates",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │        AND     OR      NOT              │\n    │      ┌─────┐┌─────┐┌────┐              │\n    │   1 ─┤  &  ├┤  |  ├┤ ¬  ├─ 0           │\n    │   0 ─┤     ├┤     ├┤    ├─ 1           │\n    │      └─────┘└─────┘└────┘              │\n    │                                         │\n    │   {0, 1} with operations ∧, ∨, ¬      │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Gray Codes": CardArtwork(
            name: "Gray Codes",
            theme: "binary_sequence",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │   Standard    Gray Code                 │\n    │   00      →    00                       │\n    │   01      →    01                       │\n    │   10      →    11                       │\n    │   11      →    10                       │\n    │                                         │\n    │   One bit changes per step              │\n    │   (Reflected Binary Code)               │\n    │                                         │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Gauss Circle Problem": CardArtwork(
            name: "Gauss Circle Problem",
            theme: "circle_lattice",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │            ◆ ◆ ◆ ◆                   │\n    │          ◆ · · · · ◆                  │\n    │        ◆ · · · · · · ◆                │\n    │       ◆ · · ● · · · · ◆               │\n    │        ◆ · · · · · · ◆                │\n    │          ◆ · · · · ◆                  │\n    │            ◆ ◆ ◆ ◆                   │\n    │                                         │\n    │   How many lattice points in circle?   │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Lattice Points": CardArtwork(
            name: "Lattice Points",
            theme: "grid_pattern",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │   · · · · · · · · · · · · · · ·        │\n    │   · · · · · · · · · · · · · · ·        │\n    │   · · · · · · · · · · · · · · ·        │\n    │   · · · · · · ● · · · · · · · ·        │\n    │   · · · · · · · · · · · · · · ·        │\n    │   · · · · · · · · · · · · · · ·        │\n    │   · · · · · · · · · · · · · · ·        │\n    │                                         │\n    │   Integer coordinate points in ℤ²      │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Sphere Geometry": CardArtwork(
            name: "Sphere Geometry",
            theme: "3d_geometry",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │              ╭─────╮                   │\n    │            ╱         ╲                 │\n    │          ╱             ╲               │\n    │         │       ●       │              │\n    │          ╲             ╱               │\n    │            ╲         ╱                 │\n    │              ╰─────╯                   │\n    │                                         │\n    │   Surface area = 4πr²                  │\n    │   Volume = (4/3)πr³                    │\n    ╰─────────────────────────────────────────╯\n    "
        ),
        "Sphere Packing": CardArtwork(
            name: "Sphere Packing",
            theme: "3d_packing",
            asciiArt: "\n    ╭─────────────────────────────────────────╮\n    │                                         │\n    │         ◎   ◎   ◎   ◎   ◎             │\n    │       ◎   ◎   ◎   ◎   ◎   ◎           │\n    │         ◎   ◎   ◎   ◎   ◎             │\n    │       ◎   ◎   ◎   ◎   ◎   ◎           │\n    │         ◎   ◎   ◎   ◎   ◎             │\n    │                                         │\n    │   Optimal sphere arrangement            │\n    │   in 3D space (FCC/HCP)                │\n    ╰─────────────────────────────────────────╯\n    "
        ),
    ]

    static func artwork(for cardName: String) -> CardArtwork? {
//        return artworks[cardName] // artwork does not look good
        return nil
    }
}
