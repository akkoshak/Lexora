//
//  GlossaryViewModel.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI
import Observation

@Observable class GlossaryViewModel {
    var searchQuery: String = ""
    var displayedEntries: [GlossaryEntry] = []
    
    private let pageSize = 10
    private var currentPage = 0
    private var filteredEntries: [GlossaryEntry] = []
    
    var hasMore: Bool {
        displayedEntries.count < filteredEntries.count
    }
    
    init() {
        loadNextPage() // show first 10 on launch
    }
    
    // MARK: - Search
    
    func search() {
        currentPage = 0
        filteredEntries = searchQuery.isEmpty ? GlossaryService.shared.entries : GlossaryService.shared.search(searchQuery)
        displayedEntries = []
        loadNextPage()
    }
    
    // MARK: - Pagination
    
    func loadNextPage() {
        if filteredEntries.isEmpty && searchQuery.isEmpty {
            filteredEntries = GlossaryService.shared.entries
        }
        
        let start = currentPage * pageSize
        let end = min(start + pageSize, filteredEntries.count)
        guard start < end else { return }
        
        displayedEntries.append(contentsOf: filteredEntries[start..<end])
        currentPage += 1
    }
}
