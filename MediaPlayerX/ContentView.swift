//
//  ContentView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/12.
//

import SlideOverCard
import SwiftUI

struct ContentView: View {
    @State var colorScheme: ColorScheme = .light
    @State var isCardOpen: Bool = false

    @State var isPanelOpen: Bool = false

    var body: some View {
        ZStack {
            TabView {
                MusicView().tabItem {
                    Label("音乐", systemImage: "music.note.list")
                }

                VideoView().tabItem {
                    Label("视频", systemImage: "play.tv")
                }

                SettingView(mode: $colorScheme).tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red)

            // Control Panel
            ControlPanelView(isPanelOpen: $isPanelOpen)
                .frame(maxWidth: .infinity, maxHeight: 75)
                .padding(.horizontal, 16)
                .shadow(radius: 10, x: 0, y: 3)
                .offset(CGSize(width: 0, height: 285))
                .slideOverCard(isPresented: $isPanelOpen) {
                    Text("Hello, world!")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

        }.preferredColorScheme(colorScheme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
