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
        VStack {
            TitleAreaView(title: "Music") {
                Button(action: { openFileImporter.toggle() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 25))
                }.fileImporter(
                    isPresented: $openFileImporter,
                    allowedContentTypes: [.audio])
                { file in
                    print(file)
                }
            }

            // Content
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 30)

            ScrollView {
                ForEach(0 ..< 50) { _ in
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

                    }.frame(width: .infinity, height: 60)
                        .background(.blue)
                        .cornerRadius(16)
                        .padding(.horizontal, 30)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
