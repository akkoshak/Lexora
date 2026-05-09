//
//  Flashcard.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import Foundation

struct Flashcard: Identifiable {
    let id = UUID()
    let entry: GlossaryEntry
    let options: [GlossaryEntry]
}
