import SwiftUI
import AVKit

struct LoopingPlayer: UIViewControllerRepresentable {
    /// Injected queue player (created in VideoPostCell’s view-model)
    var player: AVQueuePlayer

    // MARK: – UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc               = AVPlayerViewController()
        vc.player            = player
        vc.showsPlaybackControls = false
        vc.videoGravity      = .resizeAspectFill
        
        // Disable PiP + external playback for a true TikTok feel
        vc.requiresLinearPlayback = true
        vc.canStartPictureInPictureAutomaticallyFromInline = false
        vc.allowsPictureInPicturePlayback = false
        vc.player?.allowsExternalPlayback = false
        
        vc.view.backgroundColor = .black
        vc.view.isOpaque        = true
        return vc
    }

    func updateUIViewController(_ vc: AVPlayerViewController, context: Context) {
        // If the caller passes in a *different* AVQueuePlayer, swap it
        if vc.player !== player {
            vc.player = player
        }
    }
}