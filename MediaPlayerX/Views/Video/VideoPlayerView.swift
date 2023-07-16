
import AVKit
import AZVideoPlayer
import SwiftUI

struct VideoPlayerView: View {
    @Environment(\.presentationMode) var isOpen
    @State var willBeginFullScreenPresentation: Bool = false

    @EnvironmentObject var videos: VideoViewModel

    var player: AVPlayer?

    init(url: URL) {
        self.player = AVPlayer(url: url)
    }

    var body: some View {
        ZStack {
            Color.black.frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea()

            VStack {
                HStack {
                    Button(action: {
                        videos.isPlaying.toggle()
                        isOpen.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(.gray)
                            .cornerRadius(.infinity)
                            .padding([.leading, .top])
                    }
                    Spacer()
                }

                Spacer()

                AZVideoPlayer(player: player,
                              willBeginFullScreenPresentationWithAnimationCoordinator: willBeginFullScreen,
                              willEndFullScreenPresentationWithAnimationCoordinator: willEndFullScreen)
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .shadow(radius: 0)
                    .onDisappear {
                        guard !willBeginFullScreenPresentation else {
                            willBeginFullScreenPresentation = false
                            return
                        }
                        player?.pause()
                        player?.seek(to: .zero)
                    }

                Spacer()
            }
        }
    }

    func willBeginFullScreen(_ playerViewController: AVPlayerViewController,
                             _ coordinator: UIViewControllerTransitionCoordinator)
    {
        willBeginFullScreenPresentation = true
    }

    func willEndFullScreen(_ playerViewController: AVPlayerViewController,
                           _ coordinator: UIViewControllerTransitionCoordinator)
    {
        AZVideoPlayer.continuePlayingIfPlaying(player, coordinator)
    }
}
