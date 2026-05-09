//
//  GlossaryView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/8/26.
//

import SwiftUI

struct GlossaryView: View {
    @State private var viewModel = GlossaryViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $viewModel.searchQuery)
                .onChange(of: viewModel.searchQuery) {
                    viewModel.search()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            
            if viewModel.displayedEntries.isEmpty {
                // Empty state
                Spacer()
                
                VStack(spacing: 8) {
                    Image(systemName: "text.magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("Search for an AI term")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Over 1,200 terms in English and Arabic")
                        .font(.subheadline)
                        .foregroundColor(Color(.tertiaryLabel))
                }
                
                Spacer()
            } else {
                List {
                    ForEach(viewModel.displayedEntries) { entry in
                        VStack(spacing: 16) {
                            GlossaryCard(
                                term: entry.englishTerm,
                                definition: entry.englishDefinition,
                                arabicTerm: entry.arabicTerm,
                                arabicDefinition: entry.arabicDefinition
                            )
                        }
                        .listRowSeparator(.hidden) // removes the divider
                        .listRowBackground(Color.clear) // removes the white row background
                    }
                    
                    // Load more trigger
                    if viewModel.hasMore {
                        HStack {
                            Spacer()
                            
                            ProgressView()
                                .onAppear {
                                    viewModel.loadNextPage()
                                }
                            
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    GlossaryView()
}
