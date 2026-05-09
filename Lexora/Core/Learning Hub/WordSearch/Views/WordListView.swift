//
//  WordListView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI

struct WordListView: View {
    let placedWords: [PlacedWord]
    let foundIndices: Set<Int>
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(Array(placedWords.enumerated()), id: \.offset) { index, word in
                HStack(spacing: 6) {
                    Image(systemName: foundIndices.contains(index) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(foundIndices.contains(index) ? Color.primary700 : .secondary)
                        .font(.system(size: 14))
                    
                    Text(word.word.capitalized)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(foundIndices.contains(index) ? .secondary : .primary)
                        .strikethrough(foundIndices.contains(index))
                        .lineLimit(1)
                    
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(foundIndices.contains(index)
                              ? Color.primary700.opacity(0.1)
                              : Color(.systemGray6))
                )
            }
        }
    }
}
