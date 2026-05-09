//
//  FlowLayoutView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct FlowLayoutView: View {
    let words: [TranscriptWord]
    let onTap: (TranscriptWord) -> Void
 
    var body: some View {
        GeometryReader { geo in
            generateContent(in: geo)
        }
    }
 
    private func generateContent(in geo: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var lastHeight = CGFloat.zero
        let spacing: CGFloat = 6
        let lineSpacing: CGFloat = 10
 
        return ZStack(alignment: .topLeading) {
            ForEach(words) { word in
                wordView(for: word)
                    .opacity(word.isVisible ? 1 : 0)
                    .scaleEffect(word.isVisible ? 1 : 0.4)
                    .alignmentGuide(.leading) { d in
                        if abs(width - d.width) > geo.size.width {
                            width = 0
                            height -= lastHeight + lineSpacing
                        }
                        let result = width
                        if word.id == words.last?.id { width = 0 }
                        else { width -= d.width + spacing }
                        lastHeight = d.height
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        if word.id == words.last?.id { height = 0 }
                        return result
                    }
            }
        }
    }
 
    @ViewBuilder
    private func wordView(for word: TranscriptWord) -> some View {
        if word.isGlossaryWord {
            Button { onTap(word) } label: {
                Text(word.text)
                    .font(.system(.title3, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.primary700)
                    .clipShape(Capsule())
            }
        } else {
            Text(word.text)
                .font(.title3)
                .foregroundColor(.primary)
                .padding(.vertical, 6)
        }
    }
}
