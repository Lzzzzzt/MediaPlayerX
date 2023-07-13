//
//  ControlPanelView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/13.
//

import SwiftUI

struct ControlPanelView: View {
    @Binding var isPanelOpen: Bool
    @Binding var isPanelShow: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.init(gray: 0.8, alpha: 0.9)))
                .onTapGesture {
                    isPanelOpen.toggle()
                }
            HStack {
                Image(systemName: "music.note")
                    .padding([.leading])
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                Text("Music")
                    .bold()
                    .foregroundColor(.white)

                Spacer()

                PlayButton {}
                NextButton {}
            }
        }.frame(maxWidth: .infinity, maxHeight: 75)
            .padding(.horizontal, 16)
            .shadow(radius: 10, x: 0, y: 3)
            .offset(CGSize(width: 0, height: isPanelShow ? 290 : 500))
            .opacity(isPanelShow ? 1 : 0)
            .animation(
                .spring(
                    response: 0.4,
                    dampingFraction: 0.75,
                    blendDuration: 1
                ), value: isPanelShow
            )
            .sheet(isPresented: $isPanelOpen) {
                OpenedControlPanelView()
            }
    }
}

struct PlayButton: View {
    @State var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "play.fill")
                .padding([.vertical, .leading])
                .font(.system(size: 25))
                .foregroundColor(.white)
        }.cornerRadius(.infinity)
    }
}

struct NextButton: View {
    @State var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .offset(x: 15)
                Image(systemName: "play.fill")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
            }.padding([.vertical, .trailing])
        }.cornerRadius(.infinity)
    }
}
