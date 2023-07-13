//
//  ContentView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/12.
//

import SwiftUI

struct ContentView: View {
    @State var colorScheme: ColorScheme = .light
    @State var isPanelOpen: Bool = false
    @State var activeTab = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $activeTab) {
                MusicView().tabItem {
                    Label("音乐", systemImage: "music.note.list")
                }.tag(0)

                VideoView().tabItem {
                    Label("视频", systemImage: "play.tv")
                }.tag(1)

                SettingView(mode: $colorScheme).tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }.tag(2)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)

            // Control Panel
            ControlPanelView(
                isPanelOpen: $isPanelOpen,
                isPanelShow: Binding(get: { activeTab != 2 }, set: { _ in })
            )

        }.preferredColorScheme(colorScheme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
