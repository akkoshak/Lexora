//
//  TranscriptView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct TranscriptView: View {
    let words: [TranscriptWord]
    let onTap: (TranscriptWord) -> Void
 
    var body: some View {
        // Flow layout using wrapping HStack via custom approach
        var lines: [[TranscriptWord]] = [[]]
 
        // Simple line-break simulation (SwiftUI doesn't have native flow layout)
        // We use a LazyVGrid with flexible columns via a wrapping ZStack trick
        // Instead, render as a Text with inline components via a custom flow view
        FlowLayoutView(words: words, onTap: onTap)
    }
}
