//
//  VideoView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/13.
//

import SwiftUI

struct VideoView: View {
    var body: some View {
        VStack {
            // Title Area
            HStack {
                // Title
                Text("Video")
                    .fontWeight(.heavy)
                    .font(.system(size: 40))
                    .padding(.leading)
                    .padding()

                Spacer()

                // Actions
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.system(size: 25))
                        .padding(.trailing, 6)
                        .padding()
                }
            }.frame(maxWidth: .infinity)
            // Content
            ScrollView {}.frame(maxWidth: .infinity, maxHeight: .infinity)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView()
    }
}
