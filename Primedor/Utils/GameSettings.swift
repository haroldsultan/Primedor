import Foundation
import Combine

class GameSettings: ObservableObject {
    static let shared = GameSettings()
    
    @Published var playerName: String {
        didSet {
            UserDefaults.standard.set(playerName, forKey: "playerName")
        }
    }
    
    @Published var isBackgroundMusicEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isBackgroundMusicEnabled, forKey: "isBackgroundMusicEnabled")
            if isBackgroundMusicEnabled {
                SoundManager.shared.startBackgroundMusic()
            } else {
                SoundManager.shared.stopBackgroundMusic()
            }
        }
    }
    
    @Published var areSoundEffectsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(areSoundEffectsEnabled, forKey: "areSoundEffectsEnabled")
        }
    }
    
    @Published var musicVolume: Float {
        didSet {
            UserDefaults.standard.set(musicVolume, forKey: "musicVolume")
            SoundManager.shared.setMusicVolume(musicVolume)
        }
    }
    
    @Published var sfxVolume: Float {
        didSet {
            UserDefaults.standard.set(sfxVolume, forKey: "sfxVolume")
            SoundManager.shared.setSFXVolume(sfxVolume)
        }
    }
    
    private init() {
        self.playerName = UserDefaults.standard.string(forKey: "playerName") ?? "Player"
        self.isBackgroundMusicEnabled = UserDefaults.standard.object(forKey: "isBackgroundMusicEnabled") as? Bool ?? true
        self.areSoundEffectsEnabled = UserDefaults.standard.object(forKey: "areSoundEffectsEnabled") as? Bool ?? true
        self.musicVolume = UserDefaults.standard.object(forKey: "musicVolume") as? Float ?? 0.5
        self.sfxVolume = UserDefaults.standard.object(forKey: "sfxVolume") as? Float ?? 0.7
    }
}
