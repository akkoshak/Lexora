//
//  CameraWordScannerState.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import Foundation

enum CameraWordScannerState {
    case idle
    case scanning
    case found(GlossaryEntry)
    case permissionDenied
    case error(String)
}
