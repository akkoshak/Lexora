//
//  TabBarView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/7/26.
//

import SwiftUI

struct TabBarView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        if hasSeenOnboarding {
            RootView()
        } else {
            SplashView {
                hasSeenOnboarding = true
            }
        }
    }
}

#Preview {
    TabBarView()
}
