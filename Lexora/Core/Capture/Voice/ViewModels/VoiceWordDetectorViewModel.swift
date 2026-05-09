//
//  VoiceWordDetectorViewModel.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI
import Observation
import Speech
import AVFoundation

@Observable class VoiceWordDetectorViewModel {
    var state: VoiceDetectorState = .idle
    var transcript: String = ""
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var isListening: Bool {
        if case .listening = state { return true }
        return false
    }
    
    func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { [self] authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    AVAudioApplication.requestRecordPermission { granted in
                        DispatchQueue.main.async {
                            if !granted { self.state = .permissionDenied }
                        }
                    }
                default:
                    self.state = .permissionDenied
                }
            }
        }
    }
    
    func toggleListening() {
        if isListening {
            stopListening()
        } else {
            startListening()
        }
    }
    
    private func startListening() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            state = .error("Speech recognition is not available.")
            return
        }
        
        transcript = ""
        state = .listening
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            state = .error("Could not set up audio session.")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let request = recognitionRequest else { return }
        request.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            state = .error("Could not start audio engine.")
            return
        }
        
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }
            if let result = result {
                DispatchQueue.main.async {
                    self.transcript = result.bestTranscription.formattedString
                }
            }
            if error != nil || (result?.isFinal ?? false) {
                DispatchQueue.main.async {
                    self.stopListening()
                }
            }
        }
    }
    
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        
        try? AVAudioSession.sharedInstance().setActive(false)
        
        if !transcript.isEmpty {
            state = .processing
            detectWord(from: transcript)
        } else {
            state = .idle
        }
    }
    
    private func detectWord(from transcript: String) {
        let words = transcript
            .components(separatedBy: .whitespaces)
            .map { $0.trimmingCharacters(in: .punctuationCharacters).lowercased() }
        
        let entries = GlossaryService.shared.entries
        
        // Try matching single words first, then two-word combos
        for entry in entries {
            let term = entry.englishTerm.lowercased()
            let termWords = term.components(separatedBy: .whitespaces)
            
            // Check if all words of the term appear in transcript words
            if termWords.allSatisfy({ words.contains($0) }) {
                DispatchQueue.main.async {
                    self.state = .found(entry)
                }
                return
            }
        }
        
        DispatchQueue.main.async {
            self.state = .notFound(transcript)
        }
    }
    
    func reset() {
        state = .idle
        transcript = ""
    }
}
