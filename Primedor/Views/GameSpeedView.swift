import SwiftUI

struct GameSpeedPickerView: View {
    @StateObject private var speedManager = GameSpeedManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Game Speed")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Choose your preferred pace")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                VStack(spacing: 12) {
                    ForEach(GameSpeed.allCases) { speed in
                        SpeedOptionCard(
                            speed: speed,
                            isSelected: speedManager.currentSpeed == speed,
                            onSelect: {
                                speedManager.setSpeed(speed)
                            }
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Info box about current selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current: \(speedManager.currentSpeed.rawValue)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    
                    Text(speedManager.currentSpeed.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.05))
                .cornerRadius(8)
                .padding(.horizontal)
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .navigationTitle("Game Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SpeedOptionCard: View {
    let speed: GameSpeed
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(speed.rawValue)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(speed.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: "circle")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                
                // Speed details
                VStack(alignment: .leading, spacing: 4) {
                    SpeedDetailRow(label: "AI Thinking", time: speed.aiThinkingDelay)
                    SpeedDetailRow(label: "Actions", time: speed.aiActionDelay)
                    SpeedDetailRow(label: "Animations", time: speed.animationDelay)
                }
                .padding(.top, 4)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
            .border(
                isSelected ? Color.blue : Color.gray.opacity(0.3),
                width: isSelected ? 2 : 1
            )
            .cornerRadius(8)
        }
        .foregroundColor(.primary)
    }
}

struct SpeedDetailRow: View {
    let label: String
    let time: TimeInterval
    
    var timeString: String {
        if time < 0.5 {
            return "~\(Int(time * 1000))ms"
        } else {
            return String(format: "%.1fs", time)
        }
    }
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(timeString)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }
    }
}

#Preview {
    GameSpeedPickerView()
}
