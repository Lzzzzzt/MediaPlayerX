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
            TitleAreaView(title: "Video") {
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.system(size: 25))
                }
            }
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
