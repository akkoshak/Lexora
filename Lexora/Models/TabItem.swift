//
//  TabItem.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/7/26.
//

import Foundation

enum TabItem: Int, CaseIterable {
    case home, dictionary, add, flashcards, profile
 
    var icon: String {
        switch self {
        case .home:         return "house.fill"
        case .dictionary:   return "doc.fill"
        case .add:          return "plus"
        case .flashcards:   return "wand.and.stars"
        case .profile:      return "person.fill"
        }
    }
}
