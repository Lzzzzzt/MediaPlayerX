//
//  HeaderView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/13.
//

import SwiftUI

struct TitleArea<Content: View>: View {
    private let actionArea: Content?
    private let title: String

    private let paddingSize: CGFloat = 16

    init(title: String, @ViewBuilder actionArea: () -> Content?) {
        self.actionArea = actionArea()
        self.title = title
    }

    var body: some View {
        HStack {
            // Title
            Text(title)
                .fontWeight(.heavy)
                .font(.system(size: 40))
                .padding(.leading)
                .padding(paddingSize)
                .offset(CGSize(width: 0, height: paddingSize))

            Spacer()

            // Actions
            HStack {
                if let content = actionArea {
                    content
                }
            }.padding(.trailing)
                .padding(paddingSize)
                .offset(CGSize(width: 0, height: paddingSize))
        }.frame(maxWidth: .infinity)
    }
}

struct Previewr: PreviewProvider {
    static var previews: some View {
        TitleArea(title: "111", actionArea: {})
    }
}
