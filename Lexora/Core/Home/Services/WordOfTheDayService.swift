//
//  WordOfTheDayService.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import Foundation

struct WordOfTheDayService {
    /// Returns a deterministic entry based on the current date
    /// so the word stays the same all day but changes daily.
    static func todaysWord() -> GlossaryEntry? {
        let entries = GlossaryService.shared.entries
        guard !entries.isEmpty else { return nil }
 
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = dayOfYear % entries.count
        return entries[index]
    }
}
