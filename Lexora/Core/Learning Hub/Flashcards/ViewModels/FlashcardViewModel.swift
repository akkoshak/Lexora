//
//  FlashcardViewModel.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI
import Observation

@Observable class FlashcardViewModel {
    private(set) var flashcards: [Flashcard] = []
    private(set) var currentIndex: Int = 0
    private(set) var answerState: AnswerState = .unanswered
    private(set) var correctCount: Int = 0
    private(set) var incorrectCount: Int = 0
    private(set) var isSessionComplete: Bool = false
 
    let totalCards = 10
 
    var currentCard: Flashcard? {
        guard currentIndex < flashcards.count else { return nil }
        return flashcards[currentIndex]
    }
 
    var progress: Double {
        guard !flashcards.isEmpty else { return 0 }
        return Double(currentIndex) / Double(flashcards.count)
    }
 
    func startSession() {
        let all = GlossaryService.shared.entries
        guard all.count >= 4 else { return }
 
        let selected = Array(all.shuffled().prefix(totalCards))
 
        flashcards = selected.map { entry in
            // Pick 3 wrong options (excluding the correct one)
            let wrong = all
                .filter { $0.id != entry.id }
                .shuffled()
                .prefix(3)
 
            let options = ([entry] + wrong).shuffled()
            return Flashcard(entry: entry, options: options)
        }
 
        currentIndex = 0
        answerState = .unanswered
        correctCount = 0
        incorrectCount = 0
        isSessionComplete = false
    }
 
    func select(option: GlossaryEntry) {
        guard answerState == .unanswered,
              let card = currentCard else { return }
 
        if option.id == card.entry.id {
            answerState = .correct
            correctCount += 1
        } else {
            answerState = .incorrect(selected: option.englishTerm)
            incorrectCount += 1
        }
 
        // Auto-advance after 1.2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.advance()
        }
    }
 
    private func advance() {
        if currentIndex + 1 >= flashcards.count {
            isSessionComplete = true
        } else {
            currentIndex += 1
            answerState = .unanswered
        }
    }
}
