//
//  OptionsGridView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct OptionsGridView: View {
    let card: Flashcard
    let answerState: AnswerState
    let onSelect: (GlossaryEntry) -> Void
 
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
 
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(card.options) { option in
                OptionButtonView(
                    option: option,
                    answerState: answerState,
                    correctId: card.entry.id,
                    onSelect: onSelect
                )
            }
        }
    }
}
