// SpeechService.swift
// Manages communication with the Python TTS backend

import Foundation
import AppKit
import UserNotifications

class SpeechService: NSObject {
    static let shared = SpeechService()
    
    var isRunning = false
    var isSpeaking = false
    var lastError: String?
    var queueCount: Int = 0
    
    private var process: Process?
    private var outputPipe: Pipe?
    private var errorPipe: Pipe?
    private var serviceURL: URL?
    
    // Find the Python service path
    private func findServicePath() -> URL? {
        // Check common locations
        let possiblePaths = [
            // Relative to app bundle
            Bundle.main.resourceURL?
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("tts_service.py"),
            
            // Fixed path
            URL(fileURLWithPath: "/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/system-tts/tts_service.py"),
            
            // Home directory
            FileManager.default.homeDirectoryForCurrentUser
                .appendingPathComponent("system-tts/tts_service.py")
        ]
        
        for path in possiblePaths.compactMap({ $0 }) {
            if FileManager.default.fileExists(atPath: path.path) {
                return path
            }
        }
        
        return nil
    }
    
    private func findPythonPath() -> String {
        // Check for venv python first
        let venvPython = "/Users/macbookpro16/Desktop/AutisticScholars.org/github/AD/system-tts/venv/bin/python3"
        
        if FileManager.default.fileExists(atPath: venvPython) {
            return venvPython
        }
        
        // Fallback to system python
        return "/usr/bin/python3"
    }
    
    func start() {
        guard !isRunning else { return }
        
        guard let servicePath = findServicePath() else {
            lastError = "TTS service not found. Please check installation."
            showNotification(title: "ClaritySpeaks Error", message: lastError!)
            return
        }
        
        serviceURL = servicePath
        let pythonPath = findPythonPath()
        
        // Create process
        process = Process()
        process?.launchPath = pythonPath
        process?.arguments = [servicePath.path, "--daemon"]
        
        // Setup output handling
        outputPipe = Pipe()
        errorPipe = Pipe()
        process?.standardOutput = outputPipe
        process?.standardError = errorPipe
        
        // Read output asynchronously
        setupOutputReading()
        
        // Start process
        do {
            try process?.run()
            isRunning = true
            lastError = nil
            showNotification(title: "ClaritySpeaks Started", message: "TTS service is now running")
        } catch {
            lastError = "Failed to start service: \(error.localizedDescription)"
            showNotification(title: "ClaritySpeaks Error", message: lastError!)
        }
    }
    
    func stop() {
        guard isRunning else { return }
        
        process?.terminate()
        process = nil
        isRunning = false
        isSpeaking = false
        
        showNotification(title: "ClaritySpeaks Stopped", message: "TTS service has been stopped")
    }
    
    func testSpeech() {
        speak(text: "Hello! This is a test of ClaritySpeaks text-to-speech.")
    }
    
    func speak(text: String) {
        guard isRunning else {
            start()
            // Wait a moment for service to initialize
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.speak(text: text)
            }
            return
        }
        
        // Send text to service via stdin
        guard let process = process, process.isRunning else { return }
        
        let inputPipe = Pipe()
        process.standardInput = inputPipe
        let inputData = Data((text + "\n").utf8)
        inputPipe.fileHandleForWriting.write(inputData)
        inputPipe.fileHandleForWriting.closeFile()
        
        isSpeaking = true
        
        // Reset speaking state after estimated duration
        let estimatedDuration = Double(text.count) / 15.0 * (1.0 / SettingsManager.shared.speed)
        DispatchQueue.main.asyncAfter(deadline: .now() + estimatedDuration) {
            self.isSpeaking = false
        }
    }
    
    func stopSpeaking() {
        // Send stop signal
        if let process = process, process.isRunning {
            // Kill any afplay processes
            let killProcess = Process()
            killProcess.launchPath = "/usr/bin/killall"
            killProcess.arguments = ["afplay"]
            try? killProcess.run()
            
            isSpeaking = false
        }
    }
    
    private func setupOutputReading() {
        guard let outputPipe = outputPipe, let errorPipe = errorPipe else { return }
        
        // Read stdout
        outputPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if let output = String(data: data, encoding: .utf8) {
                self?.parseOutput(output)
            }
        }
        
        // Read stderr
        errorPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if let error = String(data: data, encoding: .utf8) {
                self?.parseError(error)
            }
        }
    }
    
    private func parseOutput(_ output: String) {
        // Parse service output for status updates
        if output.contains("Queued") {
            // Extract queue count
            if let range = output.range(of: "\\((\\d+) items\\)", options: .regularExpression) {
                let match = output[range]
                if let count = Int(match.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)) {
                    DispatchQueue.main.async {
                        self.queueCount = count
                    }
                }
            }
        }
        
        if output.contains("Playing audio") {
            DispatchQueue.main.async {
                self.isSpeaking = true
            }
        }
        
        if output.contains("Stopped") {
            DispatchQueue.main.async {
                self.isSpeaking = false
            }
        }
    }
    
    private func parseError(_ error: String) {
        if !error.isEmpty && error.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            print("[TTS Error] \(error)")
        }
    }
    
    private func showNotification(title: String, message: String) {
        guard SettingsManager.shared.showNotifications else { return }
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = message
                content.sound = .default
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                center.add(request)
            }
        }
    }
    
    deinit {
        stop()
    }
}
