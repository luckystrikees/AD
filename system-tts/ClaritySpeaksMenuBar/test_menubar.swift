import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var menu: NSMenu!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("App launched, setting up menu bar...")
        
        // Create status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.title = "🔊 CS"
        }
        
        // Build menu
        menu = NSMenu()
        
        let titleItem = NSMenuItem(title: "ClaritySpeaks TTS", action: nil, keyEquivalent: "")
        titleItem.isEnabled = false
        menu.addItem(titleItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let testItem = NSMenuItem(title: "Test Speech", action: #selector(testSpeech), keyEquivalent: "")
        testItem.target = self
        menu.addItem(testItem)
        
        let settingsItem = NSMenuItem(title: "Settings…", action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        // Assign menu directly - no popUp latency
        statusItem.menu = menu
        
        print("Menu assigned to status item")
    }
    
    @objc func testSpeech() {
        print("Test Speech clicked!")
        DispatchQueue.global(qos: .userInitiated).async {
            let task = Process()
            task.launchPath = "/usr/bin/say"
            task.arguments = ["Hello! This is a test of ClaritySpeaks text-to-speech."]
            try? task.run()
            task.waitUntilExit()
        }
    }
    
    @objc func openSettings() {
        print("Settings clicked!")
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "ClaritySpeaks Settings"
            alert.informativeText = "Settings window coming soon!"
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    @objc func quitApp() {
        print("Quitting...")
        NSApp.terminate(nil)
    }
}

let appDelegate = AppDelegate()
NSApplication.shared.delegate = appDelegate
NSApplication.shared.setActivationPolicy(.accessory)
NSApplication.shared.activate(ignoringOtherApps: true)
NSApp.run()
