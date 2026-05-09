//
//  VideoWordExtractorView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI
import AVKit
import PhotosUI

struct VideoWordExtractorView: View {
    @Environment(Router.self) private var router
    
    @State private var viewModel = VideoWordExtractorViewModel()
    @State private var photosItem: PhotosPickerItem? = nil
    @State private var isPickerPresented = false
 
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                BackButton {
                    router.popToRoot()
                }
                
                Text("Word Detector")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.neutral900)
                
                Spacer()
                
                if case .playing = viewModel.state {
                    Button("New Video") {
                        viewModel.cleanup()
                        viewModel.state = .idle
                        isPickerPresented = true
                    }
                    .font(.system(.subheadline, weight: .medium))
                    .foregroundColor(Color.primary700)
                }
            }
            .padding(.horizontal, 16)
            
            ZStack(alignment: .bottom) {
                
                VStack(spacing: 0) {
                    switch viewModel.state {
                    case .idle:
                        IdleUploadView { isPickerPresented = true }
                        
                    case .loading(let progress):
                        VideoLoadingView(progress: progress)
                        
                    case .transcribing:
                        TranscribingView()
                        
                    case .playing, .done:
                        if let player = viewModel.player {
                            VideoPlayer(player: player)
                                .frame(height: 240)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .padding(.horizontal, 16)
                                .padding(.top, 12)
                        }
                        
                        HStack {
                            if case .done = viewModel.state {
                                Label("Complete", systemImage: "checkmark.circle.fill")
                                    .font(.caption.weight(.medium))
                                    .foregroundColor(.green)
                            } else {
                                Label("Live", systemImage: "waveform")
                                    .font(.caption.weight(.medium))
                                    .foregroundColor(Color.primary700)
                            }
                            
                            Spacer()
                            
                            Text("\(viewModel.visibleWordCount) words")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        
                        Divider()
                            .padding(.horizontal, 16)
                        
                        WordWindowView(
                            words: viewModel.currentWindowWords,
                            onTap: { viewModel.selectWord($0) }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(20)
                        
                    case .error(let message):
                        ErrorStateView(message: message) { isPickerPresented = true }
                    }
                }
                
                if viewModel.showDefinitionCard, let entry = viewModel.selectedEntry {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture { viewModel.dismissCard() }
                        .transition(.opacity)
                    
                    DetectedWordCardView(entry: entry) {
                        viewModel.dismissCard()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.body)
        .photosPicker(isPresented: $isPickerPresented, selection: $photosItem, matching: .videos)
        .onChange(of: photosItem) {
            guard let item = photosItem else { return }
            
            // Set loading state immediately so UI responds right away
            viewModel.state = .loading(0.0)
            
            Task {
                if let transferable = try? await item.loadTransferable(type: VideoTransferable.self) {
                    await MainActor.run {
                        viewModel.loadFromPhotosPicker(url: transferable.url)
                    }
                } else {
                    await MainActor.run {
                        viewModel.state = .error("Could not load the selected video.")
                    }
                }
            }
        }
        .onDisappear { viewModel.cleanup() }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.showDefinitionCard)
    }
}

#Preview {
    @Previewable @State var router = Router()
    
    VideoWordExtractorView()
        .withRouter(router: router, hideTabBar: .constant(false))
}
