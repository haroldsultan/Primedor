import SwiftUI

struct InstructionsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("How to Play Primedor")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Group {
                        Text("Goal")
                            .font(.headline)
                        Text("Be the first to reach 15 victory points. When someone reaches 15 points, all players finish the round. Highest points wins (fewest cards breaks ties).")
                        
                        Text("On Your Turn")
                            .font(.headline)
                        Text("Choose ONE action:")
                        Text("• Collect 3 different colored tokens")
                        Text("• Collect 2 tokens of the same color (need 4+ available)")
                        Text("• Reserve a card and take 1 gold token")
                        Text("• Buy a card")
                        
                        Text("Buying Cards")
                            .font(.headline)
                        Text("Pay the cost shown on the card using your tokens. Cards give you permanent bonuses (★) that count as tokens for future purchases.")
                        
                        Text("Nobles (Mathematicians)")
                            .font(.headline)
                        Text("Automatically visit you when you have enough bonuses (★). Each noble is worth 3 points.")
                        
                        Text("Token Colors")
                            .font(.headline)
                        HStack(spacing: 12) {
                            VStack {
                                Circle().fill(.red).frame(width: 30, height: 30)
                                Text("Primes").font(.caption)
                            }
                            VStack {
                                Circle().fill(.blue).frame(width: 30, height: 30)
                                Text("Evens").font(.caption)
                            }
                            VStack {
                                Circle().fill(.green).frame(width: 30, height: 30)
                                Text("Odds").font(.caption)
                            }
                        }
                        HStack(spacing: 12) {
                            VStack {
                                Circle().fill(.black).frame(width: 30, height: 30)
                                Text("Squares").font(.caption)
                            }
                            VStack {
                                Circle().fill(.gray).frame(width: 30, height: 30)
                                Text("Sequences").font(.caption)
                            }
                            VStack {
                                Circle().fill(.yellow).frame(width: 30, height: 30)
                                Text("Perfect").font(.caption)
                            }
                        }
                        
                        Text("Tips")
                            .font(.headline)
                        Text("• Focus on one or two colors to get bonuses faster")
                        Text("• Reserve cards your opponents want")
                        Text("• Keep under 10 tokens (you must discard extras)")
                        Text("• Nobles are worth 3 points - plan ahead!")
                    }
                }
                .padding()
            }
            .navigationTitle("Instructions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
