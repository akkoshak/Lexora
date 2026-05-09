//
//  CameraWordScannerViewModel.swift
//  Lexora
//
//  Created by Abdulkarim Koshak on 5/9/26.
//

import SwiftUI
import Observation
import Vision
import AVFoundation

@Observable class CameraWordScannerViewModel: NSObject {
    var state: CameraWordScannerState = .idle
    var detectedTexts: [String] = []
    
    // Camera
    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    
    // Vision
    private var recognitionRequest: VNRecognizeTextRequest?
    private var isProcessingFrame = false
    
    // Throttle — only process every N frames
    private var frameCount = 0
    private let processEveryNFrames = 8
    
    func requestPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupSession()
                    } else {
                        self?.state = .permissionDenied
                    }
                }
            }
        default:
            state = .permissionDenied
        }
    }
    
    private func setupSession() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            
            session.beginConfiguration()
            session.sessionPreset = .hd1280x720
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: device),
                  session.canAddInput(input) else {
                DispatchQueue.main.async { self.state = .error("Could not set up camera.") }
                return
            }
            
            session.addInput(input)
            
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.video.queue"))
            videoOutput.alwaysDiscardsLateVideoFrames = true
            
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
            }
            
            session.commitConfiguration()
            
            DispatchQueue.main.async { self.state = .scanning }
            self.session.startRunning()
        }
        
        setupVision()
    }
    
    private func setupVision() {
        recognitionRequest = VNRecognizeTextRequest { [weak self] request, _ in
            guard let self,
                  let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            let texts = observations.compactMap { $0.topCandidates(1).first?.string }
            DispatchQueue.main.async {
                self.detectedTexts = texts
                self.matchGlossary(from: texts)
            }
            self.isProcessingFrame = false
        }
        recognitionRequest?.recognitionLevel = .accurate
        recognitionRequest?.usesLanguageCorrection = false
    }
    
    private func matchGlossary(from texts: [String]) {
        let entries = GlossaryService.shared.entries
        
        // Normalize all detected text into one string for flexible matching
        let fullText = texts
            .joined(separator: " ")
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        for entry in entries {
            let term = entry.englishTerm.lowercased()
            
            // Direct substring match — much more lenient than word-by-word
            if fullText.contains(term) {
                DispatchQueue.main.async {
                    if case .found(_) = self.state { return }
                    self.state = .found(entry)
                    self.stopScanning()
                }
                return
            }
        }
    }
    
    func stopScanning() {
        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    func resumeScanning() {
        detectedTexts = []
        state = .scanning
        sessionQueue.async { [weak self] in
            if self?.session.isRunning == false {
                self?.session.startRunning()
            }
        }
    }
}

extension CameraWordScannerViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        frameCount += 1
        guard frameCount % processEveryNFrames == 0,
              !isProcessingFrame,
              let request = recognitionRequest,
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
 
        isProcessingFrame = true
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
}
