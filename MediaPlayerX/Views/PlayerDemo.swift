import AVFoundation
import SwiftUI

struct AontentView: View {
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0
    @State private var totalTime: TimeInterval = 100

    var body: some View {
        VStack {
            Text("Music Player")
                .font(.title)
                .padding()

            // 播放时间
            Text("\(timeString(from: currentTime)) / \(timeString(from: totalTime))")
                .font(.subheadline)

//            // 进度条
            Slider(value: $currentTime, in: 0 ... totalTime, step: 1)
                .padding(.horizontal)



            HStack {
                // 播放/暂停按钮
                Button(action: {
                    if isPlaying {
                        pause()
                    } else {
                        play()
                    }
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                }

                // 停止按钮
                Button(action: stop) {
                    Image(systemName: "stop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .onAppear {
            setupAudioPlayer()
        }
        .onDisappear {
            stop()
        }
    }

    func setupAudioPlayer() {
        guard let audioPath = Bundle.main.path(forResource: "sample", ofType: "mp3") else {
            return
        }

        let audioURL = URL(fileURLWithPath: audioPath)
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            totalTime = audioPlayer.duration
        } catch {
            print("Failed to create audio player: \(error)")
        }
    }

    func play() {
        // TODO: 实现播放逻辑
    }

    func pause() {
        // TODO: 实现暂停逻辑
    }

    func stop() {
        // TODO: 实现停止逻辑
    }

    func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct AontentView_Previews: PreviewProvider {
    static var previews: some View {
        AontentView()
    }
}
