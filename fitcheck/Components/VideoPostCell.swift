import SwiftUI
import AVKit

struct VideoPostCell: View {
    let post: Post
    
    @StateObject private var vm = PlayerVM()
    @State private var paused  = false
    
    var body: some View {
        if post.url.absoluteString == "blue" {
            Color.blue
                .ignoresSafeArea(.container, edges: [.top, .horizontal])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if post.url.absoluteString == "red" {
            Color.red
                .ignoresSafeArea(.container, edges: [.top, .horizontal])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            LoopingPlayer(player: vm.player)
                .onAppear   { vm.load(url: post.url) }
                .onDisappear{ vm.cleanup() }              // free AVAssets
                .onChange(of: post.url) { vm.load(url: post.url) }
                .contentShape(Rectangle())
                .onTapGesture {
                    paused.toggle()
                    paused ? vm.pause() : vm.play()
                }
                .ignoresSafeArea(.container, edges: [.top, .horizontal])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private final class PlayerVM: ObservableObject {
    let player = AVQueuePlayer()
    private var looper: AVPlayerLooper?
    
    func load(url: URL) {
        // Dispose previous loop before creating a new one
        player.removeAllItems()
        looper = AVPlayerLooper(player: player,
                                templateItem: AVPlayerItem(url: url))
        player.isMuted = true
        player.play()
    }
    
    func pause() { player.pause() }
    func play()  { player.play()  }
    
    func cleanup() {
        player.pause()
        player.removeAllItems()
        looper = nil
    }
    
    deinit { cleanup() }
}