//
//  TranscriptWord.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import Foundation

struct TranscriptWord: Identifiable {
    let id = UUID()
    let text: String
    let isGlossaryWord: Bool
    let entry: GlossaryEntry?
    var isVisible: Bool = false
    var timestamp: TimeInterval = 0  // exact time this word should appear
}
