//
//  SplashView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/5/26.
//

import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void
    
    @State private var showOnboarding = false
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            GeometryReader { geometry in
                let size = geometry.size
                
                VStack(spacing: 10) {
                    Image(.logo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 264, height: 264)
                        .padding(.top, size.height / 6)
                    
                    Text("Lexora")
                        .font(.system(size: 48, weight: .bold))
                    
                    Text("See it. Say it. Know it.")
                        .font(.system(size: 24, weight: .medium))
                    
                    LexoraButton(title: "Let's Begin") {
                        showOnboarding.toggle()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, size.height / 9)
                    
                    Text("Built by Team 404 Brain Not Found")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.gray)
                        .padding(.top, size.height / 6)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .offset(y: showOnboarding ? -size.height : 0)
            }
            .ignoresSafeArea()
            
            OnboardingView(showOnboarding: $showOnboarding, currentIndex: $currentIndex, onFinish: onFinish)
            
            navigationBar()
        }
        .animation(.interactiveSpring(response: 1.1, dampingFraction: 0.85, blendDuration: 0.85), value: showOnboarding)
    }
    
    @ViewBuilder
    private func navigationBar() -> some View {
        HStack {
            BackButton {
                if currentIndex > 0 {
                    currentIndex -= 1
                } else {
                    showOnboarding.toggle()
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .frame(maxHeight: .infinity, alignment: .top)
        .offset(y: showOnboarding ? 0 : -130)
    }
}

#Preview {
    SplashView {
        
    }
}
