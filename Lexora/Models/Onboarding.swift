//
//  Onboarding.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/5/26.
//

import SwiftUI

struct Onboarding: Identifiable {
    let id = UUID().uuidString
    let title: String
    let subtitle: String
    let image: ImageResource
    
    static var screens: [Self] {
        [
            Onboarding(
                title: "Learn smarter every day",
                subtitle: "Build knowledge with smart practice",
                image: .onboarding1
            ),
            
            Onboarding(
                title: "Say it. Get it instantly",
                subtitle: "Find definitions using your voice",
                image: .onboarding2
            ),
            
            Onboarding(
                title: "Point. Scan. Understand",
                subtitle: "Detect terms directly from text",
                image: .onboarding3
            )
        ]
    }
}
