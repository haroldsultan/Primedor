import SwiftUI

struct PlayerHandDetailView: View {
    let player: Player
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with close button
                HStack {
                    Text(player.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                
                // Scrollable content
                ScrollView {
                    VStack(spacing: 20) {
                        // TOKENS SECTION
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tokens")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            HStack(spacing: 12) {
                                ForEach(TokenType.allCases, id: \.self) { type in
                                    let count = (player.tokens[type] ?? []).count
                                    VStack(spacing: 4) {
                                        Circle()
                                            .fill(colorFor(type))
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Text("\(count)")
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                            )
                                        Text(type.rawValue.capitalized)
                                            .font(.caption2)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // PURCHASED CARDS SECTION
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Purchased Cards (\(player.purchasedCards.count))")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if player.purchasedCards.isEmpty {
                                Text("No cards purchased")
                                    .foregroundColor(.secondary)
                                    .padding()
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(player.purchasedCards, id: \.id) { card in
                                        CardDetailRow(card: card)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // RESERVED CARDS SECTION
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Reserved Cards (\(player.reservedCards.count))")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if player.reservedCards.isEmpty {
                                Text("No cards reserved")
                                    .foregroundColor(.secondary)
                                    .padding()
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(player.reservedCards, id: \.id) { card in
                                        CardDetailRow(card: card)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // MATHEMATICIANS SECTION
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mathematicians (\(player.mathematicians.count))")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if player.mathematicians.isEmpty {
                                Text("No mathematicians claimed")
                                    .foregroundColor(.secondary)
                                    .padding()
                            } else {
                                VStack(spacing: 12) {
                                    ForEach(player.mathematicians, id: \.id) { mathematician in
                                        MathematicianDetailRow(mathematician: mathematician)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // POINTS SUMMARY
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Victory Points Breakdown")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            let cardPoints = player.purchasedCards.reduce(0) { $0 + $1.points }
                            let nobilePoints = player.mathematicians.count * 3
                            let totalPoints = player.victoryPoints
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("From Cards:")
                                        .font(.caption)
                                    Spacer()
                                    Text("\(cardPoints) pts")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                
                                HStack {
                                    Text("From Mathematicians:")
                                        .font(.caption)
                                    Spacer()
                                    Text("\(nobilePoints) pts")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                
                                Divider()
                                    .padding(.vertical, 4)
                                
                                HStack {
                                    Text("Total:")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("\(totalPoints) pts")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.purple)
                                }
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}

// MARK: - Card Detail Row
struct CardDetailRow: View {
    let card: Card
    @State private var showModal = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Card name and resource
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(card.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(CardDescription.description(for: card.name))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Resource bonus
                Circle()
                    .fill(colorFor(card.bonus))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(bonusIcon(for: card.bonus))
                            .font(.system(size: 14))
                    )
            }
            
            // Victory points and tier
            HStack(spacing: 12) {
                if card.points > 0 {
                    HStack(spacing: 4) {
                        Text("VP:")
                            .font(.caption2)
                            .fontWeight(.semibold)
                        Text("\(card.points)")
                            .font(.headline)
                    }
                    .padding(6)
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(4)
                }
                
                HStack(spacing: 4) {
                    Text("Tier:")
                        .font(.caption2)
                        .fontWeight(.semibold)
                    Text(card.tier.name)
                        .font(.headline)
                }
                .padding(6)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(4)
                
                Spacer()
            }
            
            // Cost
            if !card.cost.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Cost:")
                        .font(.caption2)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 8) {
                        ForEach(TokenType.allCases, id: \.self) { type in
                            if let cost = card.cost[type], cost > 0 {
                                HStack(spacing: 3) {
                                    Circle()
                                        .fill(colorFor(type))
                                        .frame(width: 18, height: 18)
                                        .overlay(
                                            Text("\(cost)")
                                                .font(.system(size: 9, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                    
                                    Text(type.rawValue.capitalized)
                                        .font(.caption2)
                                }
                                .padding(4)
                                .background(Color(.systemGray6))
                                .cornerRadius(4)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .onTapGesture {
            showModal = true
        }
        .sheet(isPresented: $showModal) {
            CardDetailView(card: card)
        }
    }
}

func bonusIcon(for type: TokenType) -> String {
    switch type {
    case .prime: return "🔴"
    case .even: return "🔵"
    case .odd: return "🟢"
    case .square: return "⚫"
    case .sequence: return "⚪"
    case .perfect: return "👑"
    }
}

// MARK: - Mathematician Detail Row
struct MathematicianDetailRow: View {
    let mathematician: Mathematician
    @State private var showModal = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Text("👨‍🔬")
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(mathematician.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(CardDescription.description(for: mathematician.name))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text("VP")
                        .font(.caption2)
                        .fontWeight(.semibold)
                    Text("\(mathematician.points)")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .padding(6)
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(4)
            }
            
            // Requirements
            if !mathematician.requirements.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Requirements:")
                        .font(.caption2)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 8) {
                        ForEach(TokenType.allCases, id: \.self) { type in
                            if let required = mathematician.requirements[type], required > 0 {
                                HStack(spacing: 3) {
                                    Circle()
                                        .fill(colorFor(type))
                                        .frame(width: 18, height: 18)
                                        .overlay(
                                            Text("\(required)")
                                                .font(.system(size: 9, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                    
                                    Text(type.rawValue.capitalized)
                                        .font(.caption2)
                                }
                                .padding(4)
                                .background(Color(.systemGray6))
                                .cornerRadius(4)
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .onTapGesture {
            showModal = true
        }
        .sheet(isPresented: $showModal) {
            NobleDetailView(noble: mathematician)
        }
    }
}
