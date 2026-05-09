//
//  GlossaryService.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import Foundation

class GlossaryService {
    static let shared = GlossaryService()
    
    private(set) var entries: [GlossaryEntry] = []
    
    private init() {
        loadCSV()
    }
    
    // MARK: - CSV Parsing
    
    private func loadCSV() {
        guard
            let url = Bundle.main.url(forResource: "glossary", withExtension: "csv"),
            let content = try? String(contentsOf: url, encoding: .utf8)
        else {
            print("GlossaryService: Failed to load glossary.csv")
            return
        }
        
        let rows = content.components(separatedBy: "\n").dropFirst() // skip header
        
        for row in rows {
            let columns = parseCSVRow(row)
            guard columns.count >= 4 else { continue }
            
            let englishTerm       = columns[0].trimmed
            let englishDefinition = columns[1].trimmed
            let arabicTerm        = columns[2].trimmed
            let arabicDefinition  = columns[3].trimmed
            
            guard !englishTerm.isEmpty else { continue }
            
            entries.append(GlossaryEntry(
                englishTerm: englishTerm,
                englishDefinition: englishDefinition,
                arabicTerm: arabicTerm,
                arabicDefinition: arabicDefinition
            ))
        }
    }
    
    /// Properly parses a CSV row, respecting quoted fields that may contain commas.
    private func parseCSVRow(_ row: String) -> [String] {
        var columns: [String] = []
        var current = ""
        var insideQuotes = false
        
        for char in row {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                columns.append(current)
                current = ""
            } else {
                current.append(char)
            }
        }
        columns.append(current) // last column
        return columns
    }
    
    // MARK: - Search
    
    /// Returns entries where the English or Arabic term contains the query.
    func search(_ query: String) -> [GlossaryEntry] {
        let q = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return [] }
        
        return entries.filter {
            $0.englishTerm.lowercased().contains(q) ||
            $0.arabicTerm.lowercased().contains(q)
        }
    }
    
    /// Exact lookup by English term.
    func define(_ term: String) -> GlossaryEntry? {
        let q = term.lowercased().trimmed
        return entries.first { $0.englishTerm.lowercased() == q }
    }
}

// MARK: - String Helper
 
private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
