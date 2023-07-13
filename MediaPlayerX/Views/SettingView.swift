//
//  SettingView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/13.
//

import SwiftUI

struct SettingView: View {
    @Binding var mode: Bool
    
    var modeString: String {
        switch mode {
            case false:
                return "sun.min"
            case true:
                return "moon"
        }
    }
    
    var body: some View {
        VStack {
            // Title Area
            HStack {
                // Title
                Text("Settings")
                    .fontWeight(.heavy)
                    .font(.system(size: 40))
                    .padding(.leading)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    mode.toggle()
                }) {
                    Image(systemName: modeString)
                        .font(.system(size: 25))
                        .padding()
                }
                
            }.frame(maxWidth: .infinity)
            
            // Content
            ScrollView {}.frame(maxWidth: .infinity, maxHeight: .infinity)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}
