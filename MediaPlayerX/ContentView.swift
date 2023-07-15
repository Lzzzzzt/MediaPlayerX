//
//  ContentView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/12.
//

import SwiftUI

struct ContentView: View {
    @State var isPanelOpen: Bool = false
    @State var activeTab = 0
    @State var timer = Timer.TimerPublisher(interval: 0.1, runLoop: .main, mode: .common).autoconnect()

    @StateObject var musicViewModel: MusicViewModel = .init()
    @StateObject var videoViewModel: VideoViewModel = .init()
    @State var colorScheme: ColorScheme = .light

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $activeTab) {
                MusicView(mode: $colorScheme).tag(0).tabItem {
                    Label("音乐", systemImage: "music.note.list")
                }

                VideoView(mode: $colorScheme).tag(1).tabItem {
                    Label("视频", systemImage: "play.tv")
                }

            }.frame(maxWidth: .infinity, maxHeight: .infinity)

            // Control Panel
            ControlPanelView(
                isPanelOpen: $isPanelOpen,
                isPanelShow: Binding(get: { activeTab == 0 && musicViewModel.playable }, set: { _ in })
            )

        }.preferredColorScheme(colorScheme)
            .environmentObject(musicViewModel)
            .environmentObject(videoViewModel)
            .tint(.pink)
            .onReceive(timer) { _ in
                if videoViewModel.isPlaying {
                    musicViewModel.stopToPlay()
                }
            }
    }
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
// }

public func timeString(from time: TimeInterval?) -> String {
    if let time = time {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }

    return ""
}
