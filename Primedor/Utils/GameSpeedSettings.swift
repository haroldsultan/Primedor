import Foundation
import Combine

/// Defines game speed presets with all relevant timing parameters
enum GameSpeed: String, CaseIterable, Identifiable {
    case slow = "Slow"
    case normal = "Normal"
    case fast = "Fast"
    
    var id: String { self.rawValue }
    
    // AI action delays (time between deciding and executing)
    var aiActionDelay: TimeInterval {
        switch self {
        case .slow:    return 1.0
        case .normal:  return 0.5
        case .fast:    return 0.1
        }
    }
    
    // AI thinking delay (time AI spends "thinking" before acting)
    var aiThinkingDelay: TimeInterval {
        switch self {
        case .slow:    return 1.5
        case .normal:  return 0.8
        case .fast:    return 0.2
        }
    }
    
    // Delay after action before next thing happens
    var animationDelay: TimeInterval {
        switch self {
        case .slow:    return 0.8
        case .normal:  return 0.5
        case .fast:    return 0.2
        }
    }
    
    // Delay for card replacement animation
    var cardReplacementDelay: TimeInterval {
        switch self {
        case .slow:    return 1.0
        case .normal:  return 0.5
        case .fast:    return 0.15
        }
    }
    
    // Turn end delay before next player
    var turnEndDelay: TimeInterval {
        switch self {
        case .slow:    return 0.8
        case .normal:  return 0.3
        case .fast:    return 0.05
        }
    }
    
    var description: String {
        switch self {
        case .slow:
            return "Relaxed pace - Great for learning"
        case .normal:
            return "Balanced - Recommended"
        case .fast:
            return "Quick gameplay - Speed run mode"
        }
    }
}

/// Centralized game speed settings
class GameSpeedManager: ObservableObject {
    static let shared = GameSpeedManager()
    
    @Published var currentSpeed: GameSpeed = .normal
    
    private let speedKey = "com.primedor.gameSpeed"
    
    init() {
        // Load saved speed preference
        if let savedSpeed = UserDefaults.standard.string(forKey: speedKey),
           let speed = GameSpeed(rawValue: savedSpeed) {
            self.currentSpeed = speed
        }
    }
    
    func setSpeed(_ speed: GameSpeed) {
        self.currentSpeed = speed
        // Save preference
        UserDefaults.standard.set(speed.rawValue, forKey: speedKey)
    }
}
