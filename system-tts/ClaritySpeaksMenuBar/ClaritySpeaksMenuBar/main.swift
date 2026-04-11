// main.swift
// Pure AppKit menu bar app - no SwiftUI lifecycle issues

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var menu: NSMenu!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set accessory activation policy (no dock icon, no main window)
        NSApp.setActivationPolicy(.accessory)
        
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "waveform.circle.fill", accessibilityDescription: "ClaritySpeaks")
            button.image?.isTemplate = true
            button.action = #selector(showMenu)
            button.sendAction(on: [.leftMouseDown, .rightMouseDown])
        }
        
        buildMenu()
        
        // Start the Python TTS service
        SpeechService.shared.start()
        
        print("ClaritySpeaks MenuBar app launched successfully")
    }
    
    func buildMenu() {
        menu = NSMenu()
        
        // Header
        let header = NSMenuItem(title: "ClaritySpeaks TTS", action: nil, keyEquivalent: "")
        header.isEnabled = false
        menu.addItem(header)
        menu.addItem(NSMenuItem.separator())
        
        // Status
        let statusItem = NSMenuItem(title: "Status: Starting...", action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        statusItem.tag = 100 // For updating later
        menu.addItem(statusItem)
        menu.addItem(NSMenuItem.separator())
        
        // Quick actions
        menu.addItem(NSMenuItem(title: "🎤 Test Speech", action: #selector(testSpeech), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "⏹ Stop Speaking", action: #selector(stopSpeech), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        // Voice submenu
        let voiceMenu = NSMenu()
        let voices = SettingsManager.shared.allVoices
        for voice in voices {
            let item = NSMenuItem(title: voice.name, action: #selector(selectVoice(_:)), keyEquivalent: "")
            item.representedObject = voice.id
            if voice.id == SettingsManager.shared.selectedVoice {
                item.state = .on
            }
            voiceMenu.addItem(item)
        }
        let voiceItem = NSMenuItem(title: "Voice", action: nil, keyEquivalent: "")
        voiceItem.submenu = voiceMenu
        menu.addItem(voiceItem)
        
        // Speed submenu
        let speedMenu = NSMenu()
        let speeds: [Double] = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
        for speed in speeds {
            let item = NSMenuItem(title: String(format: "%.2fx", speed), action: #selector(selectSpeed(_:)), keyEquivalent: "")
            item.representedObject = speed
            if abs(speed - SettingsManager.shared.speed) < 0.01 {
                item.state = .on
            }
            speedMenu.addItem(item)
        }
        let speedItem = NSMenuItem(title: "Speed", action: nil, keyEquivalent: "")
        speedItem.submenu = speedMenu
        menu.addItem(speedItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Settings
        menu.addItem(NSMenuItem(title: "Settings…", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
        // Update status after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.updateStatus()
        }
    }
    
    func updateStatus() {
        let isRunning = SpeechService.shared.isRunning
        let statusText = isRunning ? "● Running" : "○ Stopped"
        
        if let item = menu.item(withTag: 100) {
            item.title = "Status: \(statusText)"
        }
    }
    
    @objc func showMenu() {
        updateStatus()
        statusItem.menu?.popUp(positioning: nil, at: NSPoint(x: 0, y: 0), in: statusItem.button)
    }
    
    @objc func testSpeech() {
        SpeechService.shared.testSpeech()
    }
    
    @objc func stopSpeech() {
        SpeechService.shared.stopSpeaking()
    }
    
    @objc func selectVoice(_ sender: NSMenuItem) {
        if let voiceId = sender.representedObject as? String {
            SettingsManager.shared.selectedVoice = voiceId
            
            // Update checkmarks
            if let submenu = sender.menu {
                for item in submenu.items {
                    item.state = (item.representedObject as? String) == voiceId ? .on : .off
                }
            }
        }
    }
    
    @objc func selectSpeed(_ sender: NSMenuItem) {
        if let speed = sender.representedObject as? Double {
            SettingsManager.shared.speed = speed
            
            // Update checkmarks
            if let submenu = sender.menu {
                for item in submenu.items {
                    item.state = abs((item.representedObject as? Double ?? 0) - speed) < 0.01 ? .on : .off
                }
            }
        }
    }
    
    @objc func openSettings() {
        let settingsWindow = SettingsWindowController()
        settingsWindow.showWindow(self)
        settingsWindow.window?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func quitApp() {
        SpeechService.shared.stop()
        NSApp.terminate(nil)
    }
}

// Main entry point
let appDelegate = AppDelegate()
let app = NSApplication.shared
app.delegate = appDelegate
app.run()
