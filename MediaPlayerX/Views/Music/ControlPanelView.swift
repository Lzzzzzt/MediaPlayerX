//
//  ControlPanelView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/13.
//

import Combine
import SwiftUI

struct ControlPanelView: View {
    @Binding var isPanelOpen: Bool
    @Binding var isPanelShow: Bool

    var body: some View {
        ControlPanel(isPanelOpen: $isPanelOpen)
            .frame(maxWidth: .infinity, maxHeight: 75)
            .padding(.horizontal, 16)
            .shadow(radius: 10, x: 0, y: 8)
            .position(
                x: UIScreen.main.bounds.width * 0.5,
                y: UIScreen.main.bounds.height - (isPanelShow ? 175 : 0)
            )
            .opacity(isPanelShow ? 1 : 0)
            .animation(
                .spring(
                    response: 0.4,
                    dampingFraction: 0.75,
                    blendDuration: 1
                ),
                value: isPanelShow
            )

            .sheet(isPresented: $isPanelOpen) {
                OpenedControlPanelView()
            }
    }
}

struct ControlPanel: View {
    @EnvironmentObject var musicViewModel: MusicViewModel

    @Binding var isPanelOpen: Bool

    @State var color: Color = .primary
    @State private var timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    @State var isPlaying: Bool = false

    var playing: MusicInfo? {
        musicViewModel.getPlayingMusic()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Material.ultraThinMaterial)
                .onTapGesture {
                    isPanelOpen.toggle()
                }

            HStack {
                Image(systemName: playing?.image ?? "music.note")
                    .padding([.leading])
                    .font(.system(size: 30))

                Text(playing?.name ?? "Select to Play")
                    .bold()

                Spacer()

                PlayButton(isPlaying: $isPlaying) {
                    musicViewModel.togglePlayerStatus()
                }
                NextButton {
                    musicViewModel.nextToPlay()
                }.padding()
            }.foregroundColor(.primary)

        }.onReceive(timer) { _ in
            isPlaying = musicViewModel.player.player?.isPlaying ?? false
        }
    }
}

struct PlayButton: View {
    @Binding var isPlaying: Bool

    @State var size: CGFloat = 25
    @State var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.system(size: size))
        }.cornerRadius(.infinity)
    }
}

struct NextButton: View {
    @State var size: CGFloat = 25
    @State var isBackward: Bool = false
    @State var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isBackward ? "backward.fill" : "forward.fill")
                    .font(.system(size: size))
            }
        }.cornerRadius(.infinity)
    }
}

struct OpenedControlPanelView: View {
    @Environment(\.presentationMode) var isOpen

    @EnvironmentObject var musicViewModel: MusicViewModel

    @State private var timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    @State private var isPlaying: Bool = false
    @State private var isDragging: Bool = false
    @State private var current: Double = 0.0

    var playing: MusicInfo? {
        musicViewModel.getPlayingMusic()
    }

    var duration: Double {
        musicViewModel.getPlayingMusic()?.duration ?? 0.0
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                // Close Button
                HStack {
                    Button(action: {
                        isOpen.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .frame(width: 30, height: 30)
                            .background(.thinMaterial)
                            .cornerRadius(.infinity)
                            .padding([.leading, .top])
                    }
                    Spacer()
                }

                Spacer()

                VStack {
                    // Music Image
                    MusicDynamicBackgroud(appear: $isPlaying)
                        .mask {
                            Image(systemName: "music.note")
                                .font(.system(size: 200))
                                .frame(width: 300, height: 300)
                                .background(.secondary.opacity(0.5))
                                .cornerRadius(10)
                        }
                        .frame(width: 300, height: 300)

                    // Music Name and Singer
                    VStack {
                        Text(playing!.name)
                            .bold()
                            .font(.system(size: 25))
                        Text(playing!.singer)
                            .foregroundColor(.secondary)
                            .font(.system(size: 20))
                    }.padding(.horizontal, 50)

                    // Music Progress Bar

                    ProgressView(value: current, total: duration)
                        .padding([.horizontal, .top], 30)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    musicViewModel.stopToPlay()

                                    let pos = value.location.x / (UIScreen.main.bounds.width - 60) * duration
                                    isPlaying = false
                                    isDragging = true

                                    current = (pos >= duration ? duration : pos) < 0 ? 0 : pos
                                }
                                .onEnded { _ in
                                    isDragging = false
                                    musicViewModel.player.player?.currentTime = current
                                    musicViewModel.continueToPlay()
                                }
                        )

                    HStack {
                        Text(timeString(from: current))
                            .font(.caption)
                            .monospaced()
                        Spacer()
                        Text(timeString(from: musicViewModel.getPlayingMusic()?.duration))
                            .font(.caption)
                            .monospaced()
                    }.padding([.horizontal, .bottom], 30)

                    // Control

                    HStack {
                        // Prev
                        NextButton(size: 40, isBackward: true) {
                            musicViewModel.prevToPlay()
                        }

                        Spacer()

                        PlayButton(isPlaying: $isPlaying, size: 55) {
                            musicViewModel.togglePlayerStatus()
                        }

                        Spacer()

                        NextButton(size: 40, isBackward: false) {
                            musicViewModel.nextToPlay()
                        }
                    }.tint(.primary)
                        .padding()
                        .padding(.horizontal, 50)

                    Spacer()

                }.frame(maxWidth: .infinity)

            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .onReceive(timer) { _ in
                    if !isDragging {
                        isPlaying = musicViewModel.player.player?.isPlaying ?? false
                        current = musicViewModel.player.player?.currentTime ?? 0
                    }
                }
        }
    }
}

// struct OpenedControlPanelViewPreview: PreviewProvider {
//    static var previews: some View {
//        OpenedControlPanelView()
//    }
// }
