//
//  CameraWordScannerView.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI

struct CameraWordScannerView: View {
    @Environment(Router.self) private var router
    
    @State private var viewModel = CameraWordScannerViewModel()
 
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                BackButton {
                    router.popToRoot()
                }
                
                Text("AI Camera Dictionary")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.neutral900)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            ZStack {
                CameraPreviewView(session: viewModel.session)
                    .ignoresSafeArea()
                    .clipShape(.rect(cornerRadius: 20))
                    .padding(.horizontal, 16)
                
                ScanningOverlayView(isScanning: {
                    if case .scanning = viewModel.state { return true }
                    return false
                }())
                .clipShape(.rect(cornerRadius: 20))
                .padding(.horizontal, 16)
                
                VStack {
                    Spacer()
                    
                    switch viewModel.state {
                    case .scanning:
                        ScanningHintView()
                            .padding(.bottom, 48)
                            .transition(.opacity)
                        
                        if case .scanning = viewModel.state {
                            VStack(spacing: 4) {
                                ForEach(viewModel.detectedTexts.prefix(5), id: \.self) { text in
                                    Text(text)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .background(Color.black.opacity(0.5))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        
                    case .found(let entry):
                        DetectedWordCardView(entry: entry) {
                            withAnimation(.spring(response: 0.35)) {
                                viewModel.resumeScanning()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 48)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        
                    case .permissionDenied:
                        PermissionDeniedView()
                            .padding(.bottom, 48)
                        
                    case .error(let message):
                        ErrorView(message: message)
                            .padding(.bottom, 48)
                        
                    default:
                        EmptyView()
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: stateKey)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.body)
        .onAppear {
            viewModel.requestPermission()
        }
        .onDisappear {
            viewModel.stopScanning()
        }
    }
 
    private var stateKey: String {
        switch viewModel.state {
        case .idle:             return "idle"
        case .scanning:         return "scanning"
        case .found(let e):     return "found-\(e.id)"
        case .permissionDenied: return "denied"
        case .error:            return "error"
        }
    }
}

#Preview {
    @Previewable @State var router = Router()
    
    CameraWordScannerView()
        .withRouter(router: router, hideTabBar: .constant(true))
}
