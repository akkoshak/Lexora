//
//  CustomTabBar.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/7/26.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @Binding var showCapture: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                if tab == .add {
                    PlusTabButton(isActive: showCapture) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            showCapture.toggle()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .offset(y: -50) // lifts it above the bar
                } else {
                    Button {
                        selectedTab = tab
                    } label: {
                        ZStack {
                            if selectedTab == tab {
                                Circle()
                                    .fill(Color.primary700.opacity(0.3))
                                    .frame(width: 52, height: 52)
                            }
                            
                            Image(systemName: tab.icon)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(
                                    selectedTab == tab ? Color.primary700 : Color.neutral700
                                )
                        }
                        .frame(width: 48, height: 48)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: -2)
        )
    }
}

#Preview {
    @Previewable @State var selectedTab: TabItem = .home
    @Previewable @State var showCapture = false
    
    ZStack(alignment: .bottom) {
        switch selectedTab {
        case .home:
            HomeView()
                .ignoresSafeArea()
        case .dictionary:
            Text("Dictionary")
                .ignoresSafeArea()
        case .add:
            Text("Add")
        case .flashcards:
            Text("Flashcards")
        case .profile:
            Text("Profile")
        }
        
        CustomTabBar(selectedTab: $selectedTab, showCapture: $showCapture)
    }
    .ignoresSafeArea(edges: .bottom)
}
