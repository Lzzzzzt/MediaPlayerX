
import AVKit
import SwiftUI

struct VideoView: View {
    @State var openFileImporter: Bool = false
    @State private var text: String = ""
    @State private var showSearchBar: Bool = false
    @State private var isPlaying: Bool = false
    
    @Binding var mode: ColorScheme
    @EnvironmentObject var videoViewModel: VideoViewModel
    
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
                List {
                    VideoList(searchText: $text, isPlaying: $isPlaying)
                        .listRowSeparator(.hidden)
                }.listStyle(GroupedListStyle())
                
                SearchBar(show: $showSearchBar, search: $text)
            }
            .navigationBarTitle("Video")
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
                        allowedContentTypes: [.mpeg4Movie, .movie],
                        onCompletion: onFileImported
                    )
                }
            }.fullScreenCover(isPresented: $isPlaying) {
                VideoPlayerView(url: videoViewModel.selected!.url)
            }
        }
    }
    
    func onFileImported(file: Result<URL, Error>) {
        switch file {
            case .success(let fileURL):
                // Save The File
                if let url = copyFileToDocument(url: fileURL) {
//                    musicViewModel.addMusic(url: url)
                    videoViewModel.addVideo(url: url)
                }
                
            case .failure(let err):
                // Alert the user
                print(err)
        }
        
        openFileImporter = false
    }
    
    func copyFileToDocument(url: URL) -> URL? {
        do {
            let destinationURL = FileManager
                .default.urls(
                    for: .documentDirectory,
                    in: .userDomainMask
                ).first!
                .appending(path: "video/")
                .appendingPathComponent(url.lastPathComponent)
            
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

struct VideoList: View {
    @EnvironmentObject var videoViewModel: VideoViewModel
    @Binding var searchText: String
    @Binding var isPlaying: Bool
    
    var body: some View {
        ForEach(videoViewModel.getFiltered(text: searchText)) { video in
            VideoListItem(info: video)
                .contextMenu {
                    Button("删除") {
                        videoViewModel.deleteVideo(video: video)
                    }.tint(.red)
                }.swipeActions {
                    Button("删除") {
                        videoViewModel.deleteVideo(video: video)
                    }.tint(.red)
                }.onTapGesture {
                    videoViewModel.selected = video
                    isPlaying.toggle()
                    videoViewModel.isPlaying.toggle()
                }.padding([.horizontal])
        }
    }
}

struct VideoListItem: View {
    @ObservedObject var info: VideoInfo
    
    var body: some View {
        LinearGradient(colors: [.pink, .blue], startPoint: .bottomLeading, endPoint: .topTrailing)
            .frame(height: 50)
            .mask {
                HStack {
                    HStack {
                        // Video Type
                        Text(info.type).fontWeight(.black)
                        // Video Name
                        VStack(alignment: .leading) {
                            Text(info.name)
                            HStack {
                                Text(info.number).monospaced()
                                Text(info.section)
                            }.font(.caption)
                        }
                    }
                    Spacer(minLength: 40)
                    
                    // Video Duration
                    Text(timeString(from: info.duration)).font(.caption).monospaced()
                }
            }
    }
}

// struct VideoView_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var colorScheme: ColorScheme = .light
//        VideoView(mode: $colorScheme)
//    }
// }
