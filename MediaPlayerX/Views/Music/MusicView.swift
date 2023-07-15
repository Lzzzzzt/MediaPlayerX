//
//  MusicView.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/13.
//

import AVFoundation
import SwiftUI

struct MusicView: View {
    @State private var openFileImporter: Bool = false
    @State private var text: String = ""
    @State private var showSearchBar: Bool = false
    @State private var deleteWhenPlaying: Bool = false

    @Binding var mode: ColorScheme
    @EnvironmentObject var musicViewModel: MusicViewModel

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
        NavigationView {
            ZStack {
                VStack {
                    List {
                        MusicList(searchText: $text)
                            .listRowSeparator(.hidden)

                        Rectangle().frame(height: 50).opacity(0)
                    }
                    .listStyle(GroupedListStyle())
                }

                SearchBar(show: $showSearchBar, search: $text)
            }
            .navigationBarTitle("Music")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSearchBar.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        switch mode {
                            case .dark:
                                mode = .light
                            case .light:
                                mode = .dark
                            @unknown default:
                                mode = .light
                        }
                    }) {
                        Image(systemName: modeString)
                            .font(.system(size: 18))
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { openFileImporter.toggle() }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .fontWeight(.light)
                    }.fileImporter(
                        isPresented: $openFileImporter,
                        allowedContentTypes: [.audio],
                        onCompletion: onFileImported
                    )
                }
            }
        }.alert(
            "无法删除正在播放的音乐",
            isPresented: Binding(
                get: { musicViewModel.deleteWhenPlaying },
                set: { musicViewModel.deleteWhenPlaying = $0 }
            )
        ) {}
    }

    func onFileImported(file: Result<URL, Error>) {
        switch file {
            case .success(let fileURL):
                // Save The File
                if let url = copyFileToDocument(url: fileURL) {
                    musicViewModel.addMusic(url: url)
                }

            case .failure(let err):
                // Alert the user
                print(err)
        }

        openFileImporter = false
    }

    func copyFileToDocument(url: URL) -> URL? {
        do {
            let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(path: "music/").appendingPathComponent(url.lastPathComponent)

            if !FileManager.default.fileExists(atPath: destinationURL.absoluteString) {
                try FileManager.default.copyItem(at: url, to: destinationURL)
                return destinationURL
            }

        } catch (let err) {
            print("\(err)")
        }

        return nil
    }
}

struct MusicList: View {
    @EnvironmentObject var musicViewModel: MusicViewModel
    @Binding var searchText: String

    var body: some View {
        ForEach(musicViewModel.getFiltered(text: searchText)) { music in
            MusicListItem(info: music)
                .contextMenu {
                    Button("删除") {
                        musicViewModel.deleteMusic(music: music)
                    }.tint(.red)
                }.swipeActions {
                    Button("删除") {
                        musicViewModel.deleteMusic(music: music)
                    }.tint(.red)
                }.onTapGesture {
                    musicViewModel.setPlayingMusic(music: music)
                }.padding([.horizontal])
        }
    }
}

struct MusicListItem: View {
    @ObservedObject var info: MusicInfo

    var body: some View {
        LinearGradient(colors: [.pink, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(height: 50)
            .mask {
                HStack {
                    Image(systemName: info.image)
                        .font(.system(size: 30))

                    VStack(alignment: .leading) {
                        Text(info.name)
                            .bold()
                        Text(info.singer)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    Spacer()
                    Text(timeString(from: info.duration))
                        .monospaced()
                        .font(.caption)
                }
            }
    }
}

// struct MusicViewPreview: PreviewProvider {
//    static var previews: some View {
//        MusicView()
//    }
// }
