//
//  MusicView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/13.
//

import SwiftUI

struct MusicView: View {
    @State var openFileImporter: Bool = false
    @State var text: String = ""

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                Spacer().frame(minHeight: 80)
                ForEach(0 ..< 50) { idx in
                    HStack {
                        HStack {
                            Image(systemName: "music.note")
                                .padding([.leading])
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                            Text("Music")
                                .bold()
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }.frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(.blue)
                        .cornerRadius(16)
                        .padding(.horizontal, 30)
                        .id(idx)
                }
                Spacer().frame(minHeight: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Material.bar)

            VStack {
                TitleArea(title: "Music") {
                    Button(action: { openFileImporter.toggle() }) {
                        Image(systemName: "plus")
                            .font(.system(size: 25))
                    }.fileImporter(
                        isPresented: $openFileImporter,
                        allowedContentTypes: [.audio]
                    ) { _ in }
                }
                .background(
                    Material.bar
                )

                Spacer()
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
