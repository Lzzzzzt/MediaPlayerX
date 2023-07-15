//
//  VideoViewModel.swift
//  MediaPlayerX
//
//  Created by Lzzzt on 2023/7/15.
//

import AVFoundation
import SwiftUI

class VideoViewModel: ObservableObject {
    @Published var videoList: [VideoInfo] = []
    @Published var selected: VideoInfo? = nil

    var isPlaying: Bool = false

    init() {
        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let videos = document.appendingPathComponent("video/")

        if !FileManager.default.fileExists(atPath: videos.absoluteString) {
            try! FileManager.default.createDirectory(at: videos, withIntermediateDirectories: true)
        }

        scanFiles()
    }

    func scanFiles() {
        let videos = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("video/")

        scanDirectory(url: videos)

        print(videoList)
    }

    func addVideo(url: URL) {
        let video = URL2VideoInfo(url: url)

        if !videoList.contains(where: { $0.url == url }) {
            videoList.append(video)
            videoList.sort(by: { $0.number < $1.number || $0.name < $1.name })
        }
    }

    func deleteVideo(video: VideoInfo) {
        if videoList.contains(where: { $0.url == video.url }) {
            do {
                try FileManager.default.removeItem(at: video.url)
                videoList.removeAll(where: { $0.url == video.url })
            } catch (let err) {
                print("[ERROR]: MusicViewModel: \(err)")
            }
        }
    }

    func getFiltered(text: String) -> [VideoInfo] {
        videoList.filter {
            text.isEmpty ||
                $0.name.localizedCaseInsensitiveContains(text) ||
                $0.type.localizedCaseInsensitiveContains(text) ||
                $0.number.localizedCaseInsensitiveContains(text) ||
                $0.section.localizedCaseInsensitiveContains(text)
        }
    }

    private func scanDirectory(url: URL) {
        do {
            try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil).forEach { URL in
                if URL.pathExtension.lowercased() == "mp4" {
                    addVideo(url: URL)
                } else if !URL.isFileURL {
                    scanDirectory(url: URL)
                }
            }
        } catch (let err) {
            print("Scan Data Error: \(err)")
        }
    }

    private func URL2VideoInfo(url: URL) -> VideoInfo {
        let type = url.pathExtension
        let name: String

        switch url.lastPathComponent.split(separator: ".").first {
            case .some(let n):
                name = String(n)
            case .none:
                name = url.lastPathComponent
        }

        return evaluateFileName(name: name, type: type, url: url)
    }

    private func evaluateFileName(name: String, type: String, url: URL) -> VideoInfo {
        let splited = name.split(separator: " - ")

        var vName: String? = nil
        var number: String? = nil
        var section: String? = nil

        switch splited.count {
            case 2:
                vName = String(splited[0])
                number = String(splited[1])
                section = ""
            case 3:
                vName = String(splited[0])
                number = String(splited[1])
                section = String(splited[2])
            default:
                vName = name
                number = ""
                section = ""
        }

        return VideoInfo(name: vName!, number: number!, section: section!, type: type, url: url)
    }
}

class VideoInfo: ObservableObject, Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let number: String
    let section: String
    let type: String
    let url: URL

    @Published var duration: TimeInterval? = nil

    init(name: String, number: String, section: String, type: String, url: URL) {
        self.name = name
        self.number = number
        self.section = section
        self.type = type
        self.url = url

        getVideoDuration()
    }

    func getVideoDuration() {
        Task {
            do {
                let time = try await AVURLAsset(url: url).load(.duration)
                DispatchQueue.main.async {
                    self.duration = CMTimeGetSeconds(time)
                }

            } catch let err {
                print("[ERROR]: \(err)")
            }
        }
    }
}
