//
//  AppModel.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/14.
//

import AVFoundation
import SwiftUI

class MusicViewModel: ObservableObject {
    @Published var musicList: [MusicInfo] = []
    @Published var player: MusicPlayer = .init()
    @Published var playable: Bool = false
    @Published var deleteWhenPlaying: Bool = false

    private var nowPlaying: Int = -1

    init() {
        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let musicDir = document.appendingPathComponent("music/")
        
        if !FileManager.default.fileExists(atPath: musicDir.absoluteString) {
            try! FileManager.default.createDirectory(at: musicDir, withIntermediateDirectories: true)
        }
        
        scanFiles()
    }
    
    func scanFiles() {
        let musics = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("music/")
        
        scanDirectory(url: musics)
        
        resetMusicIndex(nil)
    }
    
    func deleteMusic(music: MusicInfo) {
        if musicList.contains(where: { $0.URL == music.URL }) {
            if nowPlaying != music.index {
                do {
                    let current = getPlayingMusic()
                    try FileManager.default.removeItem(at: music.URL)
                    musicList.remove(at: music.index!)
                    resetMusicIndex(current)
                } catch (let err) {
                    print("[ERROR]: MusicViewModel: \(err)")
                }
            } else {
                deleteWhenPlaying = true
            }
        }
    }
    
    func getFiltered(text: String) -> [MusicInfo] {
        musicList.filter {
            text.isEmpty || $0.name.localizedCaseInsensitiveContains(text) || $0.singer.localizedCaseInsensitiveContains(text)
        }
    }
    
    func addMusic(url: URL) {
        let music = URL2MusicInfo(url: url)
        if !musicList.contains(where: { $0.URL == url }) {
            let current = getPlayingMusic()
            musicList.append(music)
            musicList.sort(by: { $0.name < $1.name })
            resetMusicIndex(current)
        }
    }
    
    func getPlayingMusic() -> MusicInfo? {
        if nowPlaying >= 0 && nowPlaying < musicList.count {
            return musicList[nowPlaying]
        }
        return nil
    }
    
    func setPlayingMusic(music: MusicInfo) {
        playable = true
        player.pause()
        nowPlaying = music.index!
        player.play(url: music.URL)
    }
    
    func togglePlayerStatus() {
        if player.player?.isPlaying ?? false {
            player.pause()
        } else {
            player.player?.play()
        }
    }
    
    func continueToPlay() {
        if !(player.player?.isPlaying ?? false) {
            player.player?.play()
        }
    }
    
    func stopToPlay() {
        if player.player?.isPlaying ?? false {
            player.pause()
        }
    }
    
    func nextToPlay() {
        if nowPlaying >= 0 {
            let cur: MusicInfo = musicList[nowPlaying]
            setPlayingMusic(music: musicList[musicList.index(after: cur.index!) % musicList.count])
        }
    }
    
    func prevToPlay() {
        if nowPlaying >= 0 {
            let cur: MusicInfo = musicList[nowPlaying]
            let next = cur.index! - 1 < 0 ? musicList.count - 1 : cur.index! - 1
            
            setPlayingMusic(music: musicList[next])
        }
    }

    private func resetMusicIndex(_ current: MusicInfo?) {
        musicList = musicList.enumerated().map { index, music in
            if current?.name ?? "" == music.name {
                nowPlaying = index
            }
            music.index = index
            return music
        }
    }
    
    private func scanDirectory(url: URL) {
        do {
            try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil).forEach { URL in
                if URL.pathExtension.lowercased() == "mp3" {

                    addMusic(url: URL)
                } else if !URL.isFileURL {
                    scanDirectory(url: URL)
                }
            }
        } catch (let err) {
            print("Scan Data Error: \(err)")
        }
    }
    
    private func URL2MusicInfo(url: URL) -> MusicInfo {
        let musicName: String
        let singer: String
        
        switch url.lastPathComponent.split(separator: ".").first {
            case .some(let name):
                let temp = getSinger(file: String(name))
                musicName = temp.1.trimmingCharacters(in: [" "])
                singer = temp.0.trimmingCharacters(in: [" "])
            case .none:
                musicName = url.lastPathComponent
                singer = ""
        }
    
        return MusicInfo(name: musicName, singer: singer, URL: url)
    }
    
    private func getSinger(file: String) -> (String, String) {
        let res: (String, String)
        let splited = file.split(separator: " - ")
        
        switch splited.first {
            case .some(let music): res.0 = String(music); res.1 = String(splited.last ?? "")
            case .none: res.0 = file; res.1 = ""
        }
        
        return res
    }
}

class MusicInfo: ObservableObject, Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let singer: String
    let URL: URL
    let image: String = "music.note"
    
    @Published var index: Int? = nil
    @Published var duration: TimeInterval? = nil
    
    init(name: String, singer: String, URL: URL) {
        self.name = name
        self.singer = singer
        self.URL = URL
        
        getMusicDuration()
    }
    
    func getMusicDuration() {
        Task {
            do {
                let time = try await AVURLAsset(url: URL).load(.duration)
                DispatchQueue.main.async {
                    self.duration = CMTimeGetSeconds(time)
                }
                
            } catch (let err) {
                print("[ERROR]: \(err)")
            }
        }
    }
}
