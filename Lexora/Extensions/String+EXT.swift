//
//  String+EXT.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import NaturalLanguage

extension String {
    
    /// Returns an abbreviated part of speech for the term.
    /// Tags all words and picks the most representative one.
    var partOfSpeech: String {
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = self
        
        var tags: [NLTag] = []
        
        tagger.enumerateTags(
            in: startIndex..<endIndex,
            unit: .word,
            scheme: .lexicalClass,
            options: [.omitWhitespace, .omitPunctuation]
        ) { tag, _ in
            if let tag = tag {
                tags.append(tag)
            }
            return true // tag ALL words
        }
        
        return bestTag(from: tags).abbreviated
    }
    
    /// Picks the most representative tag.
    /// Priority: last noun → first of any other class → "term"
    private func bestTag(from tags: [NLTag]) -> NLTag {
        if let lastNoun = tags.last(where: { $0 == .noun }) {
            return lastNoun
        }
        return tags.first ?? NLTag("")
    }
}

private extension NLTag {
    var abbreviated: String {
        switch self {
        case .noun:                 return "noun"
        case .verb:                 return "verb"
        case .adjective:            return "adj."
        case .adverb:               return "adv."
        case .pronoun:              return "pron."
        case .determiner:           return "det."
        case .particle:             return "part."
        case .preposition:          return "prep."
        case .number:               return "num."
        case .conjunction:          return "conj."
        case .interjection:         return "interj."
        case .classifier:           return "class."
        case .idiom:                return "idiom"
        case .otherWord:            return "term"
        case .openParenthesis:      return "term"
        case .closeParenthesis:     return "term"
        case .word:                 return "term"
        case .punctuation:          return "term"
        case .whitespace:           return "term"
        case .sentenceTerminator:   return "term"
        default:                    return "term"
        }
    }
}
