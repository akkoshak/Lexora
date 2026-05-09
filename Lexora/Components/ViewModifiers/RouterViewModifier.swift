//
//  RouterViewModifier.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI

struct RouterViewModifier: ViewModifier {
    @Binding var hideTabBar: Bool
    var router: Router
    
    private func routeView(for route: Route) -> some View {
        Group {
            switch route {
            case .wordSearch:
                WordSearchView()
            case .flashcards:
                FlashcardView()
            case .camera:
                CameraWordScannerView()
            case .voiceDetector:
                VoiceWordDetectorView()
            case .videoExtractor:
                VideoWordExtractorView()
            }
        }
        .environment(router)
        .navigationBarBackButtonHidden()
        .onAppear {
            hideTabBar = true
        }
        .onDisappear {
            hideTabBar = false
        }
    }
    
    func body(content: Content) -> some View {
        NavigationStack(path: Binding(get: { router.path }, set: { router.path = $0 })) {
            content
                .environment(router)
                .navigationDestination(for: Route.self) { route in
                    routeView(for: route)
                }
        }
    }
}

extension View {
    
    func withRouter(router: Router, hideTabBar: Binding<Bool>) -> some View {
        modifier(RouterViewModifier(hideTabBar: hideTabBar, router: router))
    }
}
