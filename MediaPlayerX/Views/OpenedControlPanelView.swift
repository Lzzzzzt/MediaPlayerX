//
//  OpenedControlPanelView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/13.
//

import SwiftUI

struct OpenedControlPanelView: View {
    @Environment(\.presentationMode) var isOpen

    @State var deviceRadius = {
        min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.1
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isOpen.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                        .background(Color(.init(gray: 0.8, alpha: 0.8)))
                        .cornerRadius(.infinity)
                        .padding([.leading, .top])
                }

                Spacer()
            }

            RoundedRectangle(cornerRadius: 30)
                .fill(.blue)
                .padding()

        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(30)
            .background(Color(.init(gray: 0.9, alpha: 0.7)))
    }
}

struct OpenedControlPanelView_Previews: PreviewProvider {
    static var previews: some View {
        OpenedControlPanelView()
    }
}
