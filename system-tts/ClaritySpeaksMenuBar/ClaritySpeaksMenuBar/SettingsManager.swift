// SettingsManager.swift
// Manages app settings with UserDefaults persistence

import Foundation

class SettingsManager: NSObject {
    static let shared = SettingsManager()
    
    // Voice definitions
    struct VoiceInfo: Hashable {
        let id: String
        let name: String
        let description: String
        let region: String
        
        var displayName: String {
            "\(name) (\(description))"
        }
    }
    
    struct VoiceDefaults {
        static let allVoices: [VoiceInfo] = [
            // American Female
            VoiceInfo(id: "af_heart", name: "Heart", description: "American Female", region: "US"),
            VoiceInfo(id: "af_alloy", name: "Alloy", description: "American Female", region: "US"),
            VoiceInfo(id: "af_aoede", name: "Aoede", description: "American Female", region: "US"),
            VoiceInfo(id: "af_bella", name: "Bella", description: "American Female", region: "US"),
            VoiceInfo(id: "af_jessica", name: "Jessica", description: "American Female", region: "US"),
            VoiceInfo(id: "af_kore", name: "Kore", description: "American Female", region: "US"),
            VoiceInfo(id: "af_nicole", name: "Nicole", description: "American Female", region: "US"),
            VoiceInfo(id: "af_nova", name: "Nova", description: "American Female", region: "US"),
            VoiceInfo(id: "af_river", name: "River", description: "American Female", region: "US"),
            VoiceInfo(id: "af_sarah", name: "Sarah", description: "American Female", region: "US"),
            VoiceInfo(id: "af_sky", name: "Sky", description: "American Female", region: "US"),
            // American Male
            VoiceInfo(id: "am_adam", name: "Adam", description: "American Male", region: "US"),
            VoiceInfo(id: "am_echo", name: "Echo", description: "American Male", region: "US"),
            VoiceInfo(id: "am_eric", name: "Eric", description: "American Male", region: "US"),
            VoiceInfo(id: "am_fenrir", name: "Fenrir", description: "American Male", region: "US"),
            VoiceInfo(id: "am_liam", name: "Liam", description: "American Male", region: "US"),
            VoiceInfo(id: "am_michael", name: "Michael", description: "American Male", region: "US"),
            VoiceInfo(id: "am_onyx", name: "Onyx", description: "American Male", region: "US"),
            VoiceInfo(id: "am_puck", name: "Puck", description: "American Male", region: "US"),
            VoiceInfo(id: "am_santa", name: "Santa", description: "American Male", region: "US"),
            // British Female
            VoiceInfo(id: "bf_emma", name: "Emma", description: "British Female", region: "UK"),
            VoiceInfo(id: "bf_isabella", name: "Isabella", description: "British Female", region: "UK"),
            VoiceInfo(id: "bf_alice", name: "Alice", description: "British Female", region: "UK"),
            VoiceInfo(id: "bf_lily", name: "Lily", description: "British Female", region: "UK"),
            // British Male
            VoiceInfo(id: "bm_george", name: "George", description: "British Male", region: "UK"),
            VoiceInfo(id: "bm_lewis", name: "Lewis", description: "British Male", region: "UK"),
            VoiceInfo(id: "bm_daniel", name: "Daniel", description: "British Male", region: "UK"),
            VoiceInfo(id: "bm_fable", name: "Fable", description: "British Male", region: "UK"),
        ]
        
        static func voiceInfo(for id: String) -> VoiceInfo? {
            allVoices.first { $0.id == id }
        }
    }
    
    // Settings
    var selectedVoice: String {
        didSet {
            UserDefaults.standard.set(selectedVoice, forKey: "selectedVoice")
            updatePythonService()
        }
    }
    
    var speed: Double {
        didSet {
            UserDefaults.standard.set(speed, forKey: "speed")
            updatePythonService()
        }
    }
    
    var hotkeyEnabled: Bool {
        didSet {
            UserDefaults.standard.set(hotkeyEnabled, forKey: "hotkeyEnabled")
        }
    }
    
    var autoStart: Bool {
        didSet {
            UserDefaults.standard.set(autoStart, forKey: "autoStart")
            updateLaunchdService()
        }
    }
    
    var showNotifications: Bool {
        didSet {
            UserDefaults.standard.set(showNotifications, forKey: "showNotifications")
        }
    }
    
    // Convenience accessor
    var allVoices: [VoiceInfo] {
        VoiceDefaults.allVoices
    }
    
    private override init() {
        // Load from UserDefaults or use defaults
        self.selectedVoice = UserDefaults.standard.string(forKey: "selectedVoice") ?? "af_bella"
        self.speed = UserDefaults.standard.double(forKey: "speed") != 0 ? UserDefaults.standard.double(forKey: "speed") : 1.0
        self.hotkeyEnabled = UserDefaults.standard.object(forKey: "hotkeyEnabled") as? Bool ?? true
        self.autoStart = UserDefaults.standard.object(forKey: "autoStart") as? Bool ?? false
        self.showNotifications = UserDefaults.standard.object(forKey: "showNotifications") as? Bool ?? true
    }
    
    // Group voices by region
    var voicesByRegion: [String: [VoiceInfo]] {
        Dictionary(grouping: VoiceDefaults.allVoices) { $0.region }
    }
    
    var currentVoiceInfo: VoiceInfo? {
        VoiceDefaults.voiceInfo(for: selectedVoice)
    }
    
    // Update Python service config file
    private func updatePythonService() {
        let configPath = FileManager.default
            .homeDirectoryForCurrentUser
            .appendingPathComponent(".cache/clarityspeaks-tts/config.json")
        
        let config: [String: Any] = [
            "voice": selectedVoice,
            "speed": speed
        ]
        
        do {
            let directory = configPath.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            
            let data = try JSONSerialization.data(withJSONObject: config, options: .prettyPrinted)
            try data.write(to: configPath)
        } catch {
            print("Failed to save config: \(error)")
        }
    }
    
    // Update launchd service
    private func updateLaunchdService() {
        let plistPath = FileManager.default
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Library/LaunchAgents/com.clarityspeaks.tts.plist")
        
        if autoStart {
            // Enable auto-start
            let sourcePath = Bundle.main.resourceURL?
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("com.clarityspeaks.tts.plist")
            
            if let sourcePath = sourcePath, FileManager.default.fileExists(atPath: sourcePath.path) {
                try? FileManager.default.copyItem(at: sourcePath, to: plistPath)
                
                // Load the service
                Process.launchedProcess(launchPath: "/bin/launchctl", arguments: ["load", plistPath.path])
            }
        } else {
            // Disable auto-start
            if FileManager.default.fileExists(atPath: plistPath.path) {
                Process.launchedProcess(launchPath: "/bin/launchctl", arguments: ["unload", plistPath.path])
                try? FileManager.default.removeItem(at: plistPath)
            }
        }
    }
}
