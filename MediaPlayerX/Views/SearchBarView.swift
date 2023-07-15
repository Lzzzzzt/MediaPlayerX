//
//  SearchBarView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/15.
//

import SwiftUI

struct SearchBar: View {
    @Binding var show: Bool
    @Binding var search: String

    var body: some View {
        ZStack {
            TextField("Enter text", text: $search)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .padding([.horizontal], 10)
                .padding([.top], 5)
            HStack {
                Spacer()
                Button {
                    show.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .frame(width: 20, height: 20)
                        .cornerRadius(.infinity)
                        .padding()
                        .padding(.trailing, 10)
                }
            }
        }.shadow(color: .secondary.opacity(0.5), radius: 10)
            .position(x: UIScreen.main.bounds.width * 0.5, y: show ? 30 : -200)
            .animation(
                .spring(
                    response: 0.4,
                    dampingFraction: 0.75,
                    blendDuration: 1
                ),
                value: show
            )
            .gesture(
                DragGesture().onEnded { gesture in
                    if gesture.translation.height < 0 {
                        show.toggle()
                    }
                }
            )
    }
}
