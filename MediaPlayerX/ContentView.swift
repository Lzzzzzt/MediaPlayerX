//
//  ContentView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/12.
//

import SwiftUI

struct ContentView: View {
    @State var isDark: Bool = false

    var body: some View {
        ZStack {
            Color(.init(gray: 0.7, alpha: 0.3)).ignoresSafeArea()

            TabView {
                MusicView().tabItem {
                    Image(systemName: "music.note.list")
                    Text("音乐")
                }
                VideoView().tabItem {
                    Image(systemName: "play.tv")
                    Text("视频")
                }
                SettingView(mode: $isDark).tabItem {
                    Image(systemName: "gear")
                    Text("设置")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
