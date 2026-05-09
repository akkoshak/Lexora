//
//  RootView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/7/26.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab = TabItem.home
    @State private var hideTabBar = false
    @State private var showCapture = false
    @State private var router = Router()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            switch selectedTab {
            case .home:
                HomeView()
            case .dictionary:
                DictionaryView()
            case .add:
                EmptyView()
            case .flashcards:
                LearningHubView()
                    .withRouter(router: router, hideTabBar: $hideTabBar)
            case .profile:
                ProfileView()
            }
            
            // Capture sheet slides up above tab bar
            if showCapture {
                VStack {
                    Spacer()
                    
                    CaptureSheetView(
                        onCamera: {
                            showCapture = false
                            selectedTab = .flashcards
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                router.navigateToCamera()
                            }
                        },
                        onVoice: {
                            showCapture = false
                            selectedTab = .flashcards
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                router.navigateToVoiceDetector()
                            }
                        },
                        onVideo: {
                            showCapture = false
                            selectedTab = .flashcards
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                router.navigateToVideoExtractor()
                            }
                        }
                    )
                    .padding(.bottom, 175)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea()
                .background(
                    Color.black.opacity(0.1)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                showCapture = false
                            }
                        }
                )
                .zIndex(1)
            }
            
            if !hideTabBar {
                CustomTabBar(selectedTab: $selectedTab, showCapture: $showCapture)
                    .zIndex(2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showCapture)
    }
}

#Preview {
    RootView()
}
