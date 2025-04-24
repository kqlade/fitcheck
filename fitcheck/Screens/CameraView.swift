//
//  CameraView.swift
//  FitCheck
//
//  iOS 17+ / Swift 6 / Xcode 16.2
//

import SwiftUI
import AVFoundation
import AVKit

// MARK: – Main Screen (record-only, 6-second clip)
struct CameraView: View {
    var onBack: (() -> Void)? = nil
    @StateObject private var recorder = CameraRecorder(maxDuration: 6)
    
    @State private var recordedURL: URL?
    @State private var showPreview = false
    
    var body: some View {
        ZStack {
            CameraPreview(session: recorder.session)
                .ignoresSafeArea()
            
            // ─── Overlay controls ───────────────────────────────
            VStack {
                HStack {
                    IconButton(system: "chevron.backward", size: 24) {
                        onBack?() // Return to previous tab
                    }
                    Spacer()
                    IconButton(system: "arrow.triangle.2.circlepath", size: 22) {
                        Task { await recorder.flipCamera() }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                Spacer()
                
                RecordButton(
                    isRecording: recorder.isRecording,
                    progress:    recorder.progress
                ) {
                    Task {
                        if recorder.isRecording {
                            await recorder.stopRecording()
                        } else {
                            if let url = await recorder.startRecording() {
                                recordedURL = url
                                showPreview = true
                            }
                        }
                    }
                }
                .padding(.bottom, 36)
            }
        }
        .onAppear { Task { await recorder.prepare() } }
        .onDisappear { Task { await recorder.stopSession() } }
        .fullScreenCover(isPresented: $showPreview) {
            if let url = recordedURL {
                VideoPreviewView(videoURL: url)
            }
        }
    }
}

// MARK: – Camera recorder
@MainActor
final class CameraRecorder: NSObject, ObservableObject {
    let session = AVCaptureSession()
    
    @Published private(set) var isRecording = false
    @Published private(set) var progress: CGFloat = 0   // 0…1
    
    private let movieOutput = AVCaptureMovieFileOutput()
    private var currentPosition: AVCaptureDevice.Position = .back
    private let maxDuration: Double
    private var timer: Timer?
    
    init(maxDuration: Double) {
        self.maxDuration = maxDuration
    }
    
    // Prepare camera + mic
    func prepare() async {
        guard await requestPermissions() else { return }
        
        session.beginConfiguration()
        session.sessionPreset = .high
        
        // Video input
        if let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video,
                                                position: currentPosition),
           let input = try? AVCaptureDeviceInput(device: camera),
           session.canAddInput(input) {
            session.addInput(input)
        }
        // Audio
        if let mic = AVCaptureDevice.default(for: .audio),
           let micInput = try? AVCaptureDeviceInput(device: mic),
           session.canAddInput(micInput) {
            session.addInput(micInput)
        }
        // Output
        if session.canAddOutput(movieOutput) {
            session.addOutput(movieOutput)
        }
        session.commitConfiguration()
        session.startRunning()
    }
    
    func stopSession() async {
        session.stopRunning()
    }
    
    // Flip front/back
    func flipCamera() async {
        currentPosition = currentPosition == .back ? .front : .back
        session.beginConfiguration()
        session.inputs.forEach { session.removeInput($0) }
        if let cam = AVCaptureDevice.default(.builtInWideAngleCamera,
                                             for: .video,
                                             position: currentPosition),
           let input = try? AVCaptureDeviceInput(device: cam),
           session.canAddInput(input) {
            session.addInput(input)
        }
        // Re-add mic
        if let mic = AVCaptureDevice.default(for: .audio),
           let micInput = try? AVCaptureDeviceInput(device: mic),
           session.canAddInput(micInput) {
            session.addInput(micInput)
        }
        session.commitConfiguration()
    }
    
    // Record helpers
    func startRecording() async -> URL? {
        let url = URL.temporaryDirectory.appendingPathComponent("fc-\(UUID()).mov")
        movieOutput.startRecording(to: url, recordingDelegate: self)
        isRecording = true
        progress = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.progress += 0.05 / self.maxDuration
                if self.progress >= 1 { await self.stopRecording() }
            }
        }
        
        // Await completion
        return await withCheckedContinuation { cont in
            recordingFinished = { url in cont.resume(returning: url) }
        }
    }
    
    func stopRecording() async {
        guard isRecording else { return }
        movieOutput.stopRecording()
        timer?.invalidate()
        timer = nil
        isRecording = false
        progress = 0
    }
    
    // MARK: – AV delegate bridge
    private var recordingFinished: (URL?) -> Void = { _ in }
}

extension CameraRecorder: AVCaptureFileOutputRecordingDelegate {
    nonisolated func fileOutput(_ output: AVCaptureFileOutput,
                                didFinishRecordingTo outputFileURL: URL,
                                from connections: [AVCaptureConnection],
                                error: Error?) {
        // Hop back to MainActor to update UI
        Task { @MainActor in
            self.recordingFinished(error == nil ? outputFileURL : nil)
        }
    }
}

// MARK: – Permission request
@MainActor
private func requestPermissions() async -> Bool {
    let camOK = await AVCaptureDevice.requestAccess(for: .video)
    let micOK = await AVCaptureDevice.requestAccess(for: .audio)
    return camOK && micOK
}

// MARK: – Live preview layer
private struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> PreviewView {
        let v = PreviewView()
        #if targetEnvironment(simulator)
        v.backgroundColor = .black              // fallback placeholder
        #else
        v.videoPreviewLayer.session = session
        v.videoPreviewLayer.videoGravity = .resizeAspectFill
        #endif
        return v
    }
    func updateUIView(_ uiView: PreviewView, context: Context) {}
    
    final class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }
}

// MARK: – Record button w/ progress ring
private struct RecordButton: View {
    let isRecording: Bool
    let progress: CGFloat       // 0…1
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.4), lineWidth: 5)
                    .frame(width: 80, height: 80)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.red, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 80, height: 80)
                Circle()
                    .fill(isRecording ? Color.red : Color.white.opacity(0.2))
                    .frame(width: 70, height: 70)
            }
        }
    }
}

// MARK: – Misc helpers
private struct IconButton: View {
    let system: String
    var size: CGFloat = 22
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.system(size: size))
                .foregroundColor(.white)
                .padding(8)
        }
    }
}

// MARK: – Clip preview
struct VideoPreviewView: View {
    let videoURL: URL
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .aspectRatio(9 / 16, contentMode: .fit)
                    .cornerRadius(12)
                Button("Done") { dismiss() }
                    .foregroundColor(.white)
                    .padding(.top, 24)
            }
            .padding()
        }
    }
}

// MARK: – SwiftUI preview
#Preview { CameraView() }
