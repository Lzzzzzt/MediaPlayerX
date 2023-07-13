//
//  SettingView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/13.
//

import SwiftUI

struct SettingView: View {
    @Binding var mode: ColorScheme

    var modeString: String {
        switch mode {
            case .light:
                return "sun.min"
            case .dark:
                return "moon"
            @unknown default:
                return "sun.min"
        }
    }

    var body: some View {
        VStack {
            // Title Area
            TitleAreaView(title: "Settings") {
                Button(action: {
                    toggleColorSchme()
                }) {
                    Image(systemName: modeString)
                        .font(.system(size: 25))
                        .foregroundColor(.primary)
                }
            }

            // Content
            ScrollView {}.frame(maxWidth: .infinity, maxHeight: .infinity)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func toggleColorSchme() {
        withAnimation {
            switch mode {
                case .dark:
                    mode = .light
                case .light:
                    mode = .dark
                @unknown default:
                    mode = .light
            }
        }
    }
}
