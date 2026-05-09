//
//  BookmarkService.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI
import Observation

@Observable class BookmarkService {
    static let shared = BookmarkService()
    
    private let key = "bookmarked_terms"
    private(set) var bookmarkedTerms: Set<String> = []
    
    private init() {
        load()
    }
    
    func isBookmarked(_ term: String) -> Bool {
        bookmarkedTerms.contains(term.lowercased())
    }
 
    func toggle(_ entry: GlossaryEntry) {
        let term = entry.englishTerm.lowercased()
        if bookmarkedTerms.contains(term) {
            bookmarkedTerms.remove(term)
        } else {
            bookmarkedTerms.insert(term)
        }
        save()
    }
    
    var bookmarkedEntries: [GlossaryEntry] {
        GlossaryService.shared.entries
            .filter { bookmarkedTerms.contains($0.englishTerm.lowercased()) }
            .sorted { $0.englishTerm < $1.englishTerm }
    }
    
    private func save() {
        let array = Array(bookmarkedTerms)
        if let data = try? JSONEncoder().encode(array),
           let str = String(data: data, encoding: .utf8) {
            UserDefaults.standard.set(str, forKey: key)
        }
    }
    
    private func load() {
        guard let str = UserDefaults.standard.string(forKey: key),
              let data = str.data(using: .utf8),
              let array = try? JSONDecoder().decode([String].self, from: data) else { return }
        bookmarkedTerms = Set(array)
    }
}
