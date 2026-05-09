//
//  WordSearchEngine.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import Foundation

class WordSearchEngine {
    let gridSize = 10
    
    private(set) var grid: [[WordSearchCell]] = []
    private(set) var placedWords: [PlacedWord] = []
    
    // All 8 directions: (rowDelta, colDelta)
    private let directions: [(Int, Int)] = [
        (0, 1),   // right
        (0, -1),  // left
        (1, 0),   // down
        (-1, 0),  // up
        (1, 1),   // down-right
        (1, -1),  // down-left
        (-1, 1),  // up-right
        (-1, -1)  // up-left
    ]
    
    private let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    
    /// Picks 6 random single-word entries and builds the board.
    func generate(from entries: [GlossaryEntry]) {
        // Filter to single words only (no spaces) and short enough to fit
        let eligible = entries.filter {
            !$0.englishTerm.contains(" ") &&
            !$0.englishTerm.contains("/") &&
            !$0.englishTerm.contains("-") &&
            $0.englishTerm.count <= gridSize &&
            $0.englishTerm.count >= 3
        }
        
        let selected = Array(eligible.shuffled().prefix(6))
        
        // Initialize empty grid
        grid = (0..<gridSize).map { row in
            (0..<gridSize).map { col in
                WordSearchCell(row: row, col: col, letter: " ")
            }
        }
        placedWords = []
        
        // Place each word
        for entry in selected {
            let word = entry.englishTerm.uppercased()
            placeWord(word, definition: entry.englishDefinition)
        }
        
        // Fill remaining cells with random letters
        fillEmpty()
    }
    
    private func placeWord(_ word: String, definition: String) {
        let letters = Array(word)
        var placed = false
        var attempts = 0
        
        while !placed && attempts < 100 {
            attempts += 1
            
            let direction = directions.randomElement()!
            let (dr, dc) = direction
            
            // Calculate valid starting range based on direction
            let startRow = dr == 1 ? (0...(gridSize - letters.count)).randomElement()! :
            dr == -1 ? ((letters.count - 1)...(gridSize - 1)).randomElement()! :
            (0...(gridSize - 1)).randomElement()!
            
            let startCol = dc == 1 ? (0...(gridSize - letters.count)).randomElement()! :
            dc == -1 ? ((letters.count - 1)...(gridSize - 1)).randomElement()! :
            (0...(gridSize - 1)).randomElement()!
            
            // Check if word fits
            var cells: [(row: Int, col: Int)] = []
            var fits = true
            
            for i in 0..<letters.count {
                let r = startRow + dr * i
                let c = startCol + dc * i
                
                guard r >= 0, r < gridSize, c >= 0, c < gridSize else {
                    fits = false
                    break
                }
                
                let existing = grid[r][c].letter
                if existing != " " && existing != letters[i] {
                    fits = false
                    break
                }
                
                cells.append((row: r, col: c))
            }
            
            if fits {
                // Write letters to grid
                for (i, cell) in cells.enumerated() {
                    grid[cell.row][cell.col].letter = letters[i]
                    grid[cell.row][cell.col].isPartOfWord = true
                }
                placedWords.append(PlacedWord(word: word, definition: definition, cells: cells))
                placed = true
            }
        }
    }
    
    private func fillEmpty() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col].letter == " " {
                    grid[row][col].letter = alphabet.randomElement()!
                }
            }
        }
    }
    
    /// Given an ordered list of selected (row, col) pairs, checks if they match any unFound word.
    /// Returns the index of the matched word or nil.
    func checkSelection(_ selected: [(row: Int, col: Int)]) -> Int? {
        for (index, placed) in placedWords.enumerated() {
            guard !placed.isFound else { continue }
            
            let placedCoords = placed.cells.map { "\($0.row),\($0.col)" }
            let selectedCoords = selected.map { "\($0.row),\($0.col)" }
            let reversedCoords = selectedCoords.reversed().map { $0 }
            
            if selectedCoords == placedCoords || reversedCoords == placedCoords {
                return index
            }
        }
        return nil
    }
    
    /// Marks a word as found by index.
    func markFound(at index: Int) {
        placedWords[index].isFound = true
    }
}
