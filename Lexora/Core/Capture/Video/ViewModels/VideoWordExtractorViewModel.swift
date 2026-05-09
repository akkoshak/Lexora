//
//  VideoWordExtractorViewModel.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI
import Speech
import AVFoundation

@Observable class VideoWordExtractorViewModel {
    var state: VideoExtractorState = .idle
    var currentWindowWords: [TranscriptWord] = []
    var visibleWordCount: Int = 0
    var selectedEntry: GlossaryEntry? = nil
    var showDefinitionCard: Bool = false
    var player: AVPlayer? = nil
    
    private let windowSize = 10
    private var allWords: [TranscriptWord] = []
    private var revealedWordIDs: Set<UUID> = []   // track which words have been shown
    private var timeObserver: Any? = nil
    
    func loadFromPhotosPicker(url: URL) {
        // Set loading state immediately on main thread
        state = .loading(0.0)
 
        Task {
            let dest = FileManager.default.temporaryDirectory
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension("mov")
 
            do {
                let data = try Data(contentsOf: url)
                let totalSize = Double(data.count)
                let chunkSize = max(1, data.count / 20)
                var written = 0
 
                FileManager.default.createFile(atPath: dest.path, contents: nil)
                let handle = try FileHandle(forWritingTo: dest)
 
                while written < data.count {
                    let end = min(written + chunkSize, data.count)
                    handle.write(data[written..<end])
                    written = end
 
                    let progress = Double(written) / totalSize
                    await MainActor.run {
                        self.state = .loading(progress)
                    }
                    try await Task.sleep(nanoseconds: 15_000_000)
                }
 
                try handle.close()
 
                await MainActor.run {
                    self.state = .loading(1.0)
                }
                try await Task.sleep(nanoseconds: 300_000_000)
 
                await MainActor.run {
                    self.player = AVPlayer(url: dest)
                    self.state = .transcribing
                    self.transcribeVideo(url: dest)
                }
            } catch {
                await MainActor.run {
                    self.state = .error("Failed to load video.")
                }
            }
        }
    }
    
    private func transcribeVideo(url: URL) {
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false
 
        recognizer?.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }
 
            if let error = error {
                DispatchQueue.main.async { self.state = .error(error.localizedDescription) }
                return
            }
 
            guard let result = result, result.isFinal else { return }
 
            DispatchQueue.main.async {
                self.buildWords(from: result.bestTranscription.segments)
                self.state = .playing
                self.startPlayback()
            }
        }
    }
    
    private func buildWords(from segments: [SFTranscriptionSegment]) {
        let entries = GlossaryService.shared.entries
        var result: [TranscriptWord] = []
        var i = 0
 
        while i < segments.count {
            var matched = false
 
            for length in stride(from: min(4, segments.count - i), through: 1, by: -1) {
                let phrase = segments[i..<(i + length)]
                    .map { $0.substring }
                    .joined(separator: " ")
                    .lowercased()
                    .trimmingCharacters(in: .punctuationCharacters)
 
                if let entry = entries.first(where: { $0.englishTerm.lowercased() == phrase }) {
                    result.append(TranscriptWord(
                        text: segments[i..<(i + length)].map { $0.substring }.joined(separator: " "),
                        isGlossaryWord: true,
                        entry: entry,
                        timestamp: segments[i].timestamp
                    ))
                    i += length
                    matched = true
                    break
                }
            }
 
            if !matched {
                result.append(TranscriptWord(
                    text: segments[i].substring,
                    isGlossaryWord: false,
                    entry: nil,
                    timestamp: segments[i].timestamp
                ))
                i += 1
            }
        }
 
        allWords = result
        revealedWordIDs = []
        currentWindowWords = []
        visibleWordCount = 0
    }
    
    private func startPlayback() {
        guard let player else { return }
 
        player.seek(to: .zero)
        player.play()
 
        let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            let currentTime = time.seconds
 
            // Find words due to appear that haven't been revealed yet
            let dueWords = self.allWords.filter {
                $0.timestamp <= currentTime && !self.revealedWordIDs.contains($0.id)
            }
 
            for word in dueWords {
                // Mark as revealed immediately to prevent duplicates
                self.revealedWordIDs.insert(word.id)
                self.visibleWordCount += 1
 
                // If window is full, clear it first
                if self.currentWindowWords.count >= self.windowSize {
                    withAnimation(.easeOut(duration: 0.25)) {
                        self.currentWindowWords.removeAll()
                    }
                }
 
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    var newWord = word
                    newWord.isVisible = true
                    self.currentWindowWords.append(newWord)
                }
            }
 
            // Mark done when video ends
            if let duration = player.currentItem?.duration.seconds,
               duration > 0, currentTime >= duration - 0.2 {
                self.state = .done
            }
        }
    }
    
    func selectWord(_ word: TranscriptWord) {
        guard word.isGlossaryWord, let entry = word.entry else { return }
        selectedEntry = entry
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            showDefinitionCard = true
        }
    }
 
    func dismissCard() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            showDefinitionCard = false
        }
        selectedEntry = nil
    }
    
    func cleanup() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        player?.pause()
        player = nil
        allWords = []
        revealedWordIDs = []
        currentWindowWords = []
    }
}
