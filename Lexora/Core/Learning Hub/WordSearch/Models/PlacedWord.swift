//
//  PlacedWord.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import Foundation

struct PlacedWord {
    let word: String
    let definition: String
    let cells: [(row: Int, col: Int)] // ordered list of cells the word occupies
    var isFound: Bool = false
}
