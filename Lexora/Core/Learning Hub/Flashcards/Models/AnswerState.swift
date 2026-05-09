//
//  AnswerState.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import Foundation

enum AnswerState: Equatable {
    case unanswered
    case correct
    case incorrect(selected: String)
}
