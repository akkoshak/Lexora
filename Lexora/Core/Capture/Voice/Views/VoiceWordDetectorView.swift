//
//  VoiceWordDetectorView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct VoiceWordDetectorView: View {
    @Environment(Router.self) private var router
    
    @State private var viewModel = VoiceWordDetectorViewModel()
    @State private var navigateToDetail: GlossaryEntry? = nil
    
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
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 32) {
                Spacer()
                
                statusView
                
                MicButtonView(isListening: viewModel.isListening) {
                    viewModel.toggleListening()
                }
                
                if !viewModel.transcript.isEmpty {
                    Text("\"\(viewModel.transcript)\"")
                        .font(.system(.body, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .transition(.opacity)
                }
                
                Spacer()
                
                Text(viewModel.isListening ? "Tap to stop" : "Tap the mic and say an AI term")
                    .font(.subheadline)
                    .foregroundColor(Color(.tertiaryLabel))
                    .padding(.bottom, 32)
            }
            .animation(.spring(response: 0.4), value: viewModel.isListening)
            
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.body)
        .onAppear {
            viewModel.requestPermissions()
        }
        .navigationDestination(isPresented: Binding(get: { navigateToDetail != nil }, set: { if !$0 { navigateToDetail = nil; viewModel.reset() }})) {
            if let entry = navigateToDetail {
                GlossaryDetailView(entry: entry)
            }
        }
        .onChange(of: stateKey) {
            if case .found(let entry) = viewModel.state {
                navigateToDetail = entry
            }
        }
    }
    
    @ViewBuilder
    private var statusView: some View {
        switch viewModel.state {
        case .idle:
            VStack(spacing: 8) {
                Image(systemName: "waveform")
                    .font(.system(size: 48))
                    .foregroundColor(Color(.systemGray3))
                
                Text("Ready to listen")
                    .font(.title3.bold())
                    .foregroundColor(.secondary)
            }
            
        case .listening:
            VStack(spacing: 8) {
                WaveformAnimationView()
                    .frame(width: 120, height: 48)
                
                Text("Listening...")
                    .font(.title3.bold())
                    .foregroundColor(Color.primary700)
            }
            
        case .processing:
            VStack(spacing: 8) {
                ProgressView()
                    .scaleEffect(1.4)
                
                Text("Detecting word...")
                    .font(.title3.bold())
                    .foregroundColor(.secondary)
            }
            
        case .found(let entry):
            VStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.green)
                
                Text("Found: \(entry.englishTerm)")
                    .font(.title3.bold())
                    .foregroundColor(.green)
            }
            
        case .notFound(let word):
            VStack(spacing: 12) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                Text("No match found")
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                
                Text("\"\(word)\" is not in the glossary")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button("Try Again") {
                    viewModel.reset()
                }
                .font(.system(.body, weight: .semibold))
                .foregroundColor(Color.primary700)
                .padding(.top, 4)
            }
            
        case .permissionDenied:
            VStack(spacing: 12) {
                Image(systemName: "mic.slash.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.red)
                
                Text("Microphone access denied")
                    .font(.title3.bold())
                
                Text("Please enable microphone access in Settings.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
        case .error(let message):
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.orange)
                
                Text("Something went wrong")
                    .font(.title3.bold())
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    /// Used to trigger onChange for enum state
    private var stateKey: String {
        switch viewModel.state {
        case .found(let e): return "found-\(e.id)"
        default: return "\(viewModel.state)"
        }
    }
}

#Preview {
    @Previewable @State var router = Router()
    
    VoiceWordDetectorView()
        .withRouter(router: router, hideTabBar: .constant(true))
}
