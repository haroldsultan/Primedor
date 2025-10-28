import SwiftUI

// MARK: - Utility Function
func colorFor(_ type: TokenType) -> Color {
    switch type {
    case .prime: return .red
    case .even: return .blue
    case .odd: return .green
    case .square: return .black
    case .sequence: return .gray
    case .perfect: return .yellow
    }
}

// MARK: - Card Detail View
struct CardDetailView: View {
    let card: Card
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 4) {
                        Text(card.name)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.primary)
                        
                        Text("\(card.points) Victory Points")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                    
                    Divider()
                    
                    VStack(spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(CardDescription.description(for: card.name))
                            .font(.body)
                            .italic()
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Purchase Cost")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 15) {
                            ForEach(TokenType.allCases, id: \.self) { type in
                                if let cost = card.cost[type], cost > 0 {
                                    VStack {
                                        Circle()
                                            .fill(colorFor(type))
                                            .frame(width: 45, height: 45)
                                            .shadow(radius: 2)
                                            .overlay(
                                                Text("\(cost)")
                                                    .font(.system(size: 18, weight: .bold))
                                                    .foregroundColor(.white)
                                            )
                                        Text(type.rawValue.capitalized)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Resource")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Circle()
                                .fill(colorFor(card.bonus))
                                .frame(width: 40, height: 40)
                                .shadow(radius: 2)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
    
    struct TokenBadge: View {
        let type: TokenType
        let count: Int
        var body: some View {
            VStack {
                Circle()
                    .fill(colorFor(type))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text("\(count)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                Text(type.rawValue.capitalized)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    struct StatView: View {
        let title: String
        let value: String
        let iconName: String
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }

// MARK: - Noble Detail View
struct NobleDetailView: View {
    let noble: Mathematician
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 4) {
                        Text(noble.name)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.primary)
                        
                        Text("Illustrious Mathematician")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(CardDescription.description(for: noble.name))
                            .font(.body)
                            .italic()
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 5) {
                        Text("Claim Value")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 15) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.yellow)
                            Text("\(noble.points)")
                                .font(.system(size: 40, weight: .heavy))
                                .foregroundColor(.purple)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(10)

                    Divider()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Collection Requirements")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 20) {
                            ForEach(noble.requirements.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { type, required in
                                VStack {
                                    Circle()
                                        .fill(colorFor(type))
                                        .frame(width: 55, height: 55)
                                        .shadow(radius: 2)
                                        .overlay(
                                            Text("\(required)")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                    Text("\(required) \(type.rawValue.capitalized) Cards")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
