//
//  GlossaryEntry.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import Foundation

struct GlossaryEntry: Identifiable {
    let id = UUID()
    let englishTerm: String
    let englishDefinition: String
    let arabicTerm: String
    let arabicDefinition: String
}
