import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var soundPlayers: [String: AVAudioPlayer] = [:]
    private var musicPlayer: AVAudioPlayer?
    private var currentSFXVolume: Float = 1.0
    
    private init() {
        configureAudioSession()
        preloadSounds()
        currentSFXVolume = GameSettings.shared.sfxVolume
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ Audio session configured for playback.")
        } catch {
            print("⚠️ Failed to configure audio session:", error)
        }
    }
    
    // MARK: - Preload Sounds
    private func preloadSounds() {
        let soundFiles = [
            "token_collect",
            "card_buy",
            "card_reserve",
            "turn_end",
            "noble_claim",
            "game_win",
            "button_click"
        ]
        for sound in soundFiles {
            loadSound(named: sound)
        }
    }
    
    private func loadSound(named soundName: String) {
        let extensions = ["mp3", "wav", "m4a"]
        for ext in extensions {
            if let path = Bundle.main.path(forResource: soundName, ofType: ext) {
                print("✅ Found sound file:", "\(soundName).\(ext)")
                let url = URL(fileURLWithPath: path)
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    player.volume = currentSFXVolume
                    soundPlayers[soundName] = player
                    return
                } catch {
                    print("⚠️ Error loading sound \(soundName).\(ext): \(error)")
                }
            }
        }
        print("ℹ️ Sound file not found:", soundName)
    }
    
    // MARK: - Play Sounds
    private func playSound(_ soundName: String) {
        guard GameSettings.shared.areSoundEffectsEnabled else { return }
        
        guard let player = soundPlayers[soundName] else {
            print("⚠️ No player for sound:", soundName)
            return
        }
        player.currentTime = 0
        player.volume = currentSFXVolume
        player.play()
    }
    
    // MARK: - Volume Control
    func setMusicVolume(_ volume: Float) {
        musicPlayer?.volume = volume
    }
    
    func setSFXVolume(_ volume: Float) {
        currentSFXVolume = volume
        for (_, player) in soundPlayers {
            player.volume = volume
        }
    }
    
    // MARK: - Game Sounds
    func playTokenCollectSound() { playSound("token_collect") }
    func playCardBuySound() { playSound("card_buy") }
    func playCardReserveSound() { playSound("card_reserve") }
    func playTurnEndSound() { playSound("turn_end") }
    func playNobleClaimSound() { playSound("noble_claim") }
    func playGameWinSound() { playSound("game_win") }
    func playButtonClickSound() { playSound("button_click") }
    
    // MARK: - Background Music
    func startBackgroundMusic() {
        guard GameSettings.shared.isBackgroundMusicEnabled else { return }
        guard musicPlayer == nil || musicPlayer?.isPlaying == false else { return }
        
        let musicFiles = ["background_music", "game_music", "primedor_music"]
        let extensions = ["mp3", "m4a", "wav"]
        
        for musicFile in musicFiles {
            for ext in extensions {
                if let path = Bundle.main.path(forResource: musicFile, ofType: ext) {
                    print("✅ Found background music:", "\(musicFile).\(ext)")
                    let url = URL(fileURLWithPath: path)
                    do {
                        musicPlayer = try AVAudioPlayer(contentsOf: url)
                        musicPlayer?.numberOfLoops = -1
                        musicPlayer?.volume = GameSettings.shared.musicVolume
                        musicPlayer?.play()
                        print("🎵 Background music started.")
                        return
                    } catch {
                        print("⚠️ Error loading background music: \(error)")
                    }
                }
            }
        }
        print("ℹ️ No background music file found")
    }
    
    func stopBackgroundMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }
    
    func fadeOutBackgroundMusic(duration: TimeInterval = 1.0) {
        guard let player = musicPlayer, player.isPlaying else { return }
        
        let steps = 20
        let stepDuration = duration / Double(steps)
        let volumeStep = player.volume / Float(steps)
        
        for i in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(i)) {
                player.volume -= volumeStep
                if i == steps { self.stopBackgroundMusic() }
            }
        }
    }
}
