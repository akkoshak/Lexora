//
//  VideoExtractorState.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import Foundation

enum VideoExtractorState: Equatable {
    case idle
    case loading(Double) // progress 0.0 - 1.0
    case transcribing
    case playing
    case done
    case error(String)
}
