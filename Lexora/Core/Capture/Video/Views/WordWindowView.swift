//
//  WordWindowView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct WordWindowView: View {
    let words: [TranscriptWord]
    let onTap: (TranscriptWord) -> Void
 
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if words.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "waveform.and.mic")
                        .font(.system(size: 40))
                        .foregroundColor(Color(.systemGray3))
                    
                    Text("Words will appear here")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                FlowLayoutView(words: words, onTap: onTap)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
