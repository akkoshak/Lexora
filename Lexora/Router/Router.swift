//
//  Router.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI
import Observation

@Observable class Router {
    var path = NavigationPath()
    
    func navigateToWordSearch() {
        path.append(Route.wordSearch)
    }
    
    func navigateToFlashcards() {
        path.append(Route.flashcards)
    }
    
    func navigateToCamera() {
        path.append(Route.camera)
    }
    
    func navigateToVoiceDetector() {
        path.append(Route.voiceDetector)
    }
    
    func navigateToVideoExtractor() {
        path.append(Route.videoExtractor)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

enum Route: Hashable {
    case wordSearch
    case flashcards
    case camera
    case voiceDetector
    case videoExtractor
}
