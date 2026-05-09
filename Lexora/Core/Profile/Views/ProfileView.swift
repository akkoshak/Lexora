//
//  ProfileView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct ProfileView: View {
    
    private var bookmarks: [GlossaryEntry] {
        BookmarkService.shared.bookmarkedEntries
    }
 
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
                    .foregroundStyle(Color.neutral700)
                
                Text("Your Profile")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.neutral900)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            ZStack {
                if bookmarks.isEmpty {
                    EmptyBookmarksView()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            // Stats bar
                            StatsBarView(count: bookmarks.count)
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
 
                            // Saved words
                            ForEach(bookmarks) { entry in
                                GlossaryCard(
                                    term: entry.englishTerm,
                                    definition: entry.englishDefinition,
                                    arabicTerm: entry.arabicTerm,
                                    arabicDefinition: entry.arabicDefinition
                                )
                                .padding(.horizontal, 20)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
 
                            Spacer().frame(height: 100) // tab bar clearance
                        }
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: bookmarks.count)
                    }
                }
            }
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.body)
    }
}

#Preview {
    ProfileView()
}
