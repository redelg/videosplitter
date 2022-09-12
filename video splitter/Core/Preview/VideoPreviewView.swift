//
//  VideoPreviewView.swift
//  video splitter
//
//  Created by Renzo Delgado on 4/07/22.
//

import SwiftUI
import AVKit

struct VideoPreviewView: View {
    
    @State private var seconds = 10.0
    @StateObject private var viewModel: PreviewViewModel
    @State private var loadingText = StaticTexts.Splitting
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel

    init(url: URL, presented: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue:
                                    PreviewViewModel(url: url,
                                    presented: presented))
    }
    
    var body: some View {
        ZStack {
            VStack {
                SheetHeaderView(title: StaticTexts.Split_Video, isPresented: $viewModel.isPresented)
                if viewModel.step == .preview {
                    splitVideo
                        .transition(.move(edge: .leading))
                } else {
                    SuccessView(loading: $viewModel.loading, loadingText: $loadingText)
                        .transition(.move(edge: .trailing))
                }
            }.animation(.spring(), value: viewModel.step)
            if viewModel.loading {
                LoadingView(text: $loadingText)
            }
        }
    }
}

struct VideoPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPreviewView(
            url: URL(string: "https://bit.ly/swswift")!,
            presented: .constant(true)
        )
    }
}

extension VideoPreviewView {
    
    private var videoPlayer: some View {
        VideoPlayer(player: viewModel.avPlayer, videoOverlay: {})
            .frame(height: 300)
            .cornerRadius(10)
    }
    
    private var slider: some View {
        VStack {
            Text(
                LocalizedStringKey("Amount Parts \(viewModel.splitSeconds)")
            )
            .font(.headline)
            .fontWeight(.bold)
            .padding(.top, 20)
            VStack {
                if #available(iOS 15.0, *) {
                    Slider(value: $viewModel.splitSeconds,
                           in: 3...viewModel.videoLength,
                           step: 1.0)
                    .tint(Color.theme.gradientStart)
                    .onChange(of: viewModel.splitSeconds) { viewModel.calculateClips($0) }
                } else {
                    Slider(value: $viewModel.splitSeconds,
                           in: 3...viewModel.videoLength,
                           step: 1.0)
                    .accentColor(Color.theme.gradientStart)
                    .onChange(of: viewModel.splitSeconds) { viewModel.calculateClips($0) }
                }
                Text(
                    LocalizedStringKey("Amount Clips \(viewModel.splitClips)")
                )
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top, 20)
            }
            .padding()
            .background(
                Color.theme.backgroundSlider
            )
            .cornerRadius(10)
        }
    }
    
    private var splitVideo: some View {
        Group {
            videoPlayer
            
            slider

            Spacer()
            
            Button(action: {
                viewModel.createCropItems(environmentViewModel.isProActive)
            }, label: {
                Text(StaticTexts.Split_Video)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [Color.theme.gradientStart, Color.theme.gradientEnd], startPoint: .leading, endPoint: .trailing)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    )
            })
        }
        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
    }
    
}
