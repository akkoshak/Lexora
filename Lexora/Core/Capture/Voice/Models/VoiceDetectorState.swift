//
//  VoiceDetectorState.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import Foundation

enum VoiceDetectorState {
    case idle
    case listening
    case processing
    case found(GlossaryEntry)
    case notFound(String)
    case permissionDenied
    case error(String)
}
