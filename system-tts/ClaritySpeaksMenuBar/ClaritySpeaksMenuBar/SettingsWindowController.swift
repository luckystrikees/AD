// SettingsWindowController.swift
// AppKit settings window

import AppKit

class SettingsWindowController: NSWindowController {
    
    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 450),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "ClaritySpeaks Settings"
        window.center()
        
        self.init(window: window)
        
        let contentView = SettingsViewController()
        window.contentViewController = contentView
    }
}

class SettingsViewController: NSViewController {
    let settings = SettingsManager.shared
    let service = SpeechService.shared
    
    // UI elements
    var statusIndicator: NSView!
    var statusLabel: NSTextField!
    var actionButton: NSButton!
    var voicePopup: NSPopUpButton!
    var speedSlider: NSSlider!
    var speedLabel: NSTextField!
    var hotkeyToggle: NSButton!
    var autoStartToggle: NSButton!
    var notificationsToggle: NSButton!
    
    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 500, height: 450))
        
        buildUI()
        updateUI()
    }
    
    func buildUI() {
        let stackView = NSStackView(frame: view.bounds)
        stackView.orientation = .vertical
        stackView.spacing = 16
        stackView.edgeInsets = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.autoresizingMask = [.width, .height]
        
        // Service Status Section
        let statusBox = NSBox()
        statusBox.title = "Service Status"
        let statusStack = NSStackView(frame: NSRect(x: 0, y: 0, width: 460, height: 50))
        statusStack.orientation = .horizontal
        statusStack.spacing = 10
        
        statusIndicator = NSView(frame: NSRect(x: 0, y: 0, width: 12, height: 12))
        statusIndicator.wantsLayer = true
        statusIndicator.layer?.cornerRadius = 6
        statusIndicator.layer?.backgroundColor = NSColor.gray.cgColor
        
        statusLabel = NSTextField(labelWithString: "Starting...")
        statusLabel.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        
        actionButton = NSButton(title: "Stop", target: self, action: #selector(toggleService))
        actionButton.bezelStyle = .rounded
        
        statusStack.addArrangedSubview(statusIndicator)
        statusStack.addArrangedSubview(statusLabel)
        statusStack.addArrangedSubview(NSView()) // Spacer
        statusStack.addArrangedSubview(actionButton)
        
        statusBox.contentView = statusStack
        
        // Voice Selection
        let voiceBox = NSBox()
        voiceBox.title = "Voice"
        let voiceStack = NSStackView(frame: NSRect(x: 0, y: 0, width: 460, height: 30))
        voiceStack.orientation = .horizontal
        voiceStack.spacing = 10
        
        voicePopup = NSPopUpButton(frame: .zero)
        voicePopup.target = self
        voicePopup.action = #selector(voiceChanged)
        
        for voice in settings.allVoices {
            voicePopup.addItem(withTitle: "\(voice.name) (\(voice.description))")
            voicePopup.lastItem?.representedObject = voice.id
        }
        
        voiceStack.addArrangedSubview(NSTextField(labelWithString: "Voice:"))
        voiceStack.addArrangedSubview(voicePopup)
        
        voiceBox.contentView = voiceStack
        
        // Speed Control
        let speedBox = NSBox()
        speedBox.title = "Speed"
        let speedStack = NSStackView(frame: NSRect(x: 0, y: 0, width: 460, height: 50))
        speedStack.orientation = .vertical
        speedStack.spacing = 8
        
        let speedTopRow = NSStackView()
        speedTopRow.orientation = .horizontal
        speedTopRow.addArrangedSubview(NSTextField(labelWithString: "Speech Speed:"))
        speedLabel = NSTextField(labelWithString: "1.00x")
        speedLabel.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        speedLabel.alignment = .right
        speedTopRow.addArrangedSubview(NSView())
        speedTopRow.addArrangedSubview(speedLabel)
        
        speedSlider = NSSlider(value: 1.0, minValue: 0.5, maxValue: 2.0, target: self, action: #selector(speedChanged))
        speedSlider.numberOfTickMarks = 7
        speedSlider.allowsTickMarkValuesOnly = false
        
        let presetsRow = NSStackView()
        presetsRow.orientation = .horizontal
        for speed in [0.5, 0.75, 1.0, 1.25, 1.5, 2.0] {
            let btn = NSButton(title: String(format: "%.2f", speed), target: self, action: #selector(presetSpeed))
            btn.bezelStyle = .rounded
            btn.controlSize = .small
            btn.tag = Int(speed * 100)
            presetsRow.addArrangedSubview(btn)
        }
        
        speedStack.addArrangedSubview(speedTopRow)
        speedStack.addArrangedSubview(speedSlider)
        speedStack.addArrangedSubview(presetsRow)
        
        speedBox.contentView = speedStack
        
        // Options
        let optionsBox = NSBox()
        optionsBox.title = "Options"
        let optionsStack = NSStackView(frame: NSRect(x: 0, y: 0, width: 460, height: 80))
        optionsStack.orientation = .vertical
        optionsStack.spacing = 8
        
        hotkeyToggle = NSButton(checkboxWithTitle: "Enable global hotkey (⌘⇧Space)", target: self, action: #selector(hotkeyToggled))
        autoStartToggle = NSButton(checkboxWithTitle: "Start TTS service on login", target: self, action: #selector(autoStartToggled))
        notificationsToggle = NSButton(checkboxWithTitle: "Show notifications", target: self, action: #selector(notificationsToggled))
        
        optionsStack.addArrangedSubview(hotkeyToggle)
        optionsStack.addArrangedSubview(autoStartToggle)
        optionsStack.addArrangedSubview(notificationsToggle)
        
        optionsBox.contentView = optionsStack
        
        // Quick Actions
        let actionsBox = NSBox()
        actionsBox.title = "Quick Actions"
        let actionsStack = NSStackView(frame: NSRect(x: 0, y: 0, width: 460, height: 30))
        actionsStack.orientation = .horizontal
        actionsStack.spacing = 10
        
        let testBtn = NSButton(title: "🎤 Test Speech", target: self, action: #selector(testSpeech))
        testBtn.bezelStyle = .rounded
        
        let stopBtn = NSButton(title: "⏹ Stop Speaking", target: self, action: #selector(stopSpeech))
        stopBtn.bezelStyle = .rounded
        
        actionsStack.addArrangedSubview(testBtn)
        actionsStack.addArrangedSubview(stopBtn)
        
        actionsBox.contentView = actionsStack
        
        // Add all sections
        stackView.addArrangedSubview(statusBox)
        stackView.addArrangedSubview(voiceBox)
        stackView.addArrangedSubview(speedBox)
        stackView.addArrangedSubview(optionsBox)
        stackView.addArrangedSubview(actionsBox)
        
        view.addSubview(stackView)
    }
    
    func updateUI() {
        // Status
        let isRunning = service.isRunning
        statusIndicator.layer?.backgroundColor = isRunning ? NSColor.systemGreen.cgColor : NSColor.gray.cgColor
        statusLabel.stringValue = isRunning ? "Running" : "Stopped"
        actionButton.title = isRunning ? "Stop" : "Start"
        
        // Voice
        for item in voicePopup.itemArray {
            if (item.representedObject as? String) == settings.selectedVoice {
                voicePopup.select(item)
                break
            }
        }
        
        // Speed
        speedSlider.doubleValue = settings.speed
        speedLabel.stringValue = String(format: "%.2fx", settings.speed)
        updatePresetButtons()
        
        // Toggles
        hotkeyToggle.state = settings.hotkeyEnabled ? .on : .off
        autoStartToggle.state = settings.autoStart ? .on : .off
        notificationsToggle.state = settings.showNotifications ? .on : .off
    }
    
    func updatePresetButtons() {
        if let speedBox = speedSlider.superview?.superview as? NSBox,
           let speedStack = speedBox.contentView as? NSStackView,
           let presetsRow = speedStack.arrangedSubviews.last as? NSStackView {
            for btn in presetsRow.arrangedSubviews.compactMap({ $0 as? NSButton }) {
                let speed = Double(btn.tag) / 100.0
                btn.isEnabled = abs(speed - settings.speed) > 0.01
            }
        }
    }
    
    @objc func toggleService() {
        if service.isRunning {
            service.stop()
        } else {
            service.start()
        }
        updateUI()
    }
    
    @objc func voiceChanged(_ sender: NSPopUpButton) {
        if let voiceId = sender.selectedItem?.representedObject as? String {
            settings.selectedVoice = voiceId
        }
    }
    
    @objc func speedChanged(_ sender: NSSlider) {
        settings.speed = sender.doubleValue
        speedLabel.stringValue = String(format: "%.2fx", sender.doubleValue)
        updatePresetButtons()
    }
    
    @objc func presetSpeed(_ sender: NSButton) {
        let speed = Double(sender.tag) / 100.0
        settings.speed = speed
        speedSlider.doubleValue = speed
        speedLabel.stringValue = String(format: "%.2fx", speed)
        updatePresetButtons()
    }
    
    @objc func hotkeyToggled() {
        settings.hotkeyEnabled = hotkeyToggle.state == .on
    }
    
    @objc func autoStartToggled() {
        settings.autoStart = autoStartToggle.state == .on
    }
    
    @objc func notificationsToggled() {
        settings.showNotifications = notificationsToggle.state == .on
    }
    
    @objc func testSpeech() {
        service.testSpeech()
    }
    
    @objc func stopSpeech() {
        service.stopSpeaking()
    }
}
