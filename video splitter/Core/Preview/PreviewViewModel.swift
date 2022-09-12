//
//  PreviewViewModel.swift
//  video splitter
//
//  Created by Renzo Delgado on 5/07/22.
//

import SwiftUI
import AVFoundation
import Photos

enum PreviewStep {
    case preview
    case success
}

@MainActor
class PreviewViewModel: ObservableObject {
    
    @Binding var isPresented: Bool
    @Published var splitSeconds = 1.0
    @Published var splitClips = 0
    @Published var loading = false
    @Published var step: PreviewStep = .preview
    @Published var exportCount = 0

    var url: URL
    var avPlayer: AVPlayer
    var videoLength = 0.0
    var videoDuration = 0.0

    private let interstitial = Interstitial()
    
    init(url: URL, presented: Binding<Bool>) {
        self._isPresented = presented
        self.url = url
        self.avPlayer = AVPlayer(url: url)
        if let duration = avPlayer.currentItem?.asset.duration {
            let seconds = CMTimeGetSeconds(duration)
            videoDuration = seconds
            if seconds > 60 {
                videoLength = 60
            }
            else {
                videoLength = seconds
            }
            splitSeconds = ((videoLength + 3) / 2).rounded(.down)
        }
        calculateClips(splitSeconds)
    }
    
    func calculateClips(_ seconds: Double) {
        splitClips = Int((videoDuration / seconds).rounded(.up))
    }
    
    func createCropItems(_ isPro: Bool) {
        if !isPro {
            DispatchQueue.main.async {
                self.interstitial.showAd()
            }
        }
        clearAllFile()
        Store.shared.urls = []
        var clips: [CropVideoItem] = []
        let videoAsset = AVURLAsset(url: url)
        var startTime = 0.0
        let endTime = CMTimeGetSeconds(videoAsset.duration)
        
        if videoDuration <= splitSeconds {
            clips.append(
                CropVideoItem(
                    startTime: startTime,
                    endTime: endTime,
                    fileName: "clip-1"
                ))
            loading = true
            createSessions(clips)
            //cropVideo(clips, index: 0)
            return
        }
        
        for index in 1..<splitClips {
            clips.append(
                CropVideoItem(
                    startTime: startTime,
                    endTime: startTime + splitSeconds,
                    fileName: "clip-\(index)"
                ))
            startTime += splitSeconds
        }
        clips.append(
            CropVideoItem(
                startTime: startTime,
                endTime: endTime,
                fileName: "clip-\(splitClips)"
            ))
        loading = true
        createSessions(clips)
    }
    
    private func createSessions(_ clips: [CropVideoItem]) {
        let asset = AVURLAsset(url: url)
        var sessions: [AVAssetExportSession] = []
        for clip in clips {
            let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)!
            let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                .appendingPathComponent("\(clip.fileName)")
                .appendingPathExtension("mp4")
            Store.shared.urls.append(outputURL)
            exportSession.outputURL = outputURL
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.outputFileType = .mp4
            let start = CMTimeMakeWithSeconds(clip.startTime, preferredTimescale: 1)
            let duration = CMTimeMakeWithSeconds((clip.endTime-clip.startTime).rounded(.down), preferredTimescale: 1)
            let range = CMTimeRangeMake(start: start, duration: duration)
            exportSession.timeRange = range
            sessions.append(exportSession)
        }
        Task {
            await exportAsync(sessions)
        }
    }
    
    private func exportAsync(_ sessions: [AVAssetExportSession]) async {
        var failed = false
        for session in sessions {
            await session.export()
            switch session.status {
            case .completed:
                exportCount += 1
            case .failed:
                failed = true
            case .cancelled:
                failed = true
            default: break
            }
        }
        if failed {
            clearAllFile()
            loading = false
        } else {
            loading = false
            step = .success
        }
    }
    
    private func clearAllFile() {
        let fileManager = FileManager.default
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do
        {
            let fileName = try fileManager.contentsOfDirectory(atPath: paths)

            for file in fileName {
                let filePath = URL(fileURLWithPath: paths).appendingPathComponent(file).absoluteURL
                try fileManager.removeItem(at: filePath)
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func export(_ sessions: [AVAssetExportSession]) {
        for session in sessions {
            session.exportAsynchronously { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch session.status {
                    case .completed:
                        self.successExport(session: session, sessions: sessions.count)
                    case .failed:
                        self.loading = false
                    case .cancelled:
                        self.loading = false
                    default: break
                    }
                }
            }
        }
    }
    
    private func successExport(session: AVAssetExportSession, sessions: Int) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: session.outputURL!)
        }) { [weak self] success, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.exportCount += 1
                if sessions == self.exportCount {
                    self.loading = false
                    self.step = .success
                }
            }
        }
    }
    
    @available(*, deprecated, message: "")
    private func cropVideo(_ clips: [CropVideoItem], index: Int) {
        let clip = clips[index]
        let asset = AVURLAsset(url: url)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)!
        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("\(clip.fileName)")
            .appendingPathExtension("mp4")
        Store.shared.urls.append(outputURL)
//        Remove existing file
//        if FileManager.default.fileExists(atPath: outputURL.path) {
//            do {
//                try FileManager.default.removeItem(at: outputURL)
//            } catch {
//                print(error)
//            }
//        }
        exportSession.outputURL = outputURL
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputFileType = .mp4
        let start = CMTimeMakeWithSeconds(clip.startTime, preferredTimescale: 1)
        let duration = CMTimeMakeWithSeconds((clip.endTime-clip.startTime).rounded(.down), preferredTimescale: 1)
        let range = CMTimeRangeMake(start: start, duration: duration)
        exportSession.timeRange = range
        exportSession.exportAsynchronously { [weak self] in
            guard let self = self else { return }
            switch exportSession.status {
            case .completed:
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
                }) { [weak self] success, error in
                    if !success, let _ = error {
                        self?.loading = false
                        return
                    }
                    DispatchQueue.main.async {
                        if index == clips.count-1 {
                            self?.loading = false
                            self?.step = .success
                            // finished
                        } else {
                            // next video
                            self?.cropVideo(clips, index: index + 1)
                        }
                    }
                }
            case .failed:
                DispatchQueue.main.async {
                    self.loading = false
                }
                break
            case .cancelled:
                DispatchQueue.main.async {
                    self.loading = false
                }
                break
            default: break
            }
        }
    }
    
}

struct CropVideoItem {
    
    let startTime: Double
    let endTime: Double
    let fileName: String
    let folderName: String = "cropped_videos"
    
}
