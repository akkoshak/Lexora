//
//  WordSearchCell.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import Foundation

struct WordSearchCell: Identifiable {
    let id: UUID = UUID()
    let row: Int
    let col: Int
    var letter: Character
    var isPartOfWord: Bool = false
}
