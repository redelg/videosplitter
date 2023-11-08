//
//  SwiftUIView.swift
//  video splitter
//
//  Created by Renzo Delgado on 17/07/22.
//

import SwiftUI
import AVFoundation
import AVKit
import Photos

struct SuccessView: View {
    
    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: 150, maximum: 200), spacing: nil, alignment: nil),
        GridItem(.flexible(minimum: 150, maximum: 200), spacing: nil, alignment: nil),
    ]
    private let urls: [URL] = Store.shared.urls
    @State private var selectedUrl: URL = Store.shared.urls.first!
    private let players: [AVPlayer] = {
        var players: [AVPlayer] = []
        for url in Store.shared.urls {
            players.append(AVPlayer(url: url))
        }
        return players
    }()
    
    @State private var isSharing = false
    @State private var isSharingSingle = false
    @State private var isPremium = false

    @StateObject private var viewModel: SuccessViewModel
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel

    init(loading: Binding<Bool>, loadingText: Binding<LocalizedStringKey>) {
        _viewModel = StateObject(wrappedValue:
                                    SuccessViewModel(loading: loading, loadingText: loadingText))
    }
    
    var body: some View {
        VStack {
            
            ScrollView {
                LazyVGrid(columns: columns,
                          alignment: .center,
                          spacing: nil,
                          pinnedViews: [],
                          content: {
                    ForEach(0..<urls.count) { index in
                        VStack {
                            VideoPlayer(player: players[index])
                                .frame(height: 180)
                                .cornerRadius(10)
                            Button(action: {
                                selectedUrl = urls[index]
                                isSharingSingle.toggle()
                            }, label: {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.white)
                                    Text("SharePart \(index + 1)")
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(colors: [Color.theme.gradientStart, Color.theme.gradientEnd], startPoint: .leading, endPoint: .trailing)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                )
                            })
                        }
                    }
                })
            }
            
            Spacer()
            
            Divider()
            
            Text("SuccessVideoSplitted \(urls.count)")
                .font(.headline)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .padding([.bottom, .top], 15)
            
            //Spacer()
            
            Button(action: {
                if environmentViewModel.isProActive {
                    saveVideos()
                } else {
                    isPremium.toggle()
                }
            }, label: {
                HStack {
                    Image(systemName: "square.and.arrow.down.on.square")
                        .foregroundColor(.white)
                    Text(StaticTexts.SaveAll)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [Color.theme.gradientStart, Color.theme.gradientEnd], startPoint: .leading, endPoint: .trailing)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                )
            })
             
            Button(action: {
                if environmentViewModel.isProActive {
                    isSharing.toggle()
                } else {
                    isPremium.toggle()
                }
            }, label: {
                HStack {
                    Image(systemName: "square.and.arrow.up.on.square")
                        .foregroundColor(.white)
                    Text(StaticTexts.ShareAll)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [Color.theme.gradientStart, Color.theme.gradientEnd], startPoint: .leading, endPoint: .trailing)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                )
            })
            
        }
        .sheet(isPresented: $isSharing, content: {
            ShareSheet(items: urls)
        })
        .sheet(isPresented: $isSharingSingle, content: {
            ShareSheet(items: [selectedUrl])
        })
        .sheet(isPresented: $isPremium, content: {
            PremiumView()
        })
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView(loading: .constant(false), loadingText: .constant("Loading"))
            .environmentObject(EnvironmentViewModel())
    }
}

extension SuccessView {
    
    func saveVideos() {
        viewModel.loadingText = StaticTexts.Splitting
        Task {
            do {
                viewModel.isLoading = true
                for url in Store.shared.urls {
                    try await saveToGallery(url: url)
                }
            } catch {
                environmentViewModel.type = .saveError
            }
            viewModel.isLoading = false
            environmentViewModel.type = .saveSuccess
            environmentViewModel.showAlert = true
        }
    }
    
    private func saveToGallery(url: URL) async throws {
        try await PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        })
    }
    
}
