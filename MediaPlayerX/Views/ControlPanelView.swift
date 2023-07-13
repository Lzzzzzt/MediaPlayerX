//
//  ControlPanelView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/13.
//

import SwiftUI

struct ControlPanelView: View {
    @Binding var isPanelOpen: Bool

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
                Button(action: {}) {
                    Image(systemName: "play.fill")
                        .padding()
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }.cornerRadius(.infinity)
            }
        }
    }
}
