//
//  ContentView.swift
//  video splitter
//
//  Created by Renzo Delgado on 25/06/22.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @State private var navSettings = false
    @EnvironmentObject var environmentViewModel: EnvironmentViewModel
    
    var body: some View {
        
        ZStack {
            
            Color.theme.background.ignoresSafeArea()
            
            if viewModel.showPicker {
                picker
                    .transition(.move(edge: .bottom))
            } else {
                NavigationView {
                    ZStack {
                        NavigationLink(destination: SettingsView(), isActive: $navSettings) { }
                        VStack {
                            VStack(spacing: 15) {
                                Text(StaticTexts.App_Title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.top)
                                Text(StaticTexts.Select_Video)
                                HomeSelectButton(option: MainOption(image: .camera, text: StaticTexts.Camera, caption: StaticTexts.Camera_Caption, action: onCameraSelected))
                                HomeSelectButton(option: MainOption(image: .gallery, text: StaticTexts.Gallery, caption: StaticTexts.Gallery_Caption, action: onPhotoSelected))
                                Divider()
                                HomeSelectButton(option: MainOption(image: .settings, text: StaticTexts.Settings, caption: StaticTexts.Settings_Caption, action: {
                                    navSettings.toggle()
                                }))
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            Spacer()
                            if !environmentViewModel.isProActive {
                                BannerAdView(adUnit: Ads.banner_main, adFormat: .adaptiveBanner)
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true)
                }
            }
        }
        .animation(.default, value: viewModel.showPicker)
        .environmentObject(environmentViewModel)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(EnvironmentViewModel())
    }
}

extension HomeView {
    
    private var picker: some View {
        ZStack {
            switch viewModel.picker {
            case .camera:
                VideoRecorder(isPresented: $viewModel.showPicker,
                              picker: $viewModel.picker,
                              url: $viewModel.videoUrl,
                              alertType: $environmentViewModel.type,
                              showAlert: $environmentViewModel.showAlert,
                              source: .camera
                )
            case .gallery:
                VideoRecorder(isPresented: $viewModel.showPicker,
                              picker: $viewModel.picker,
                              url: $viewModel.videoUrl,
                              alertType: $environmentViewModel.type,
                              showAlert: $environmentViewModel.showAlert,
                              source: .photoLibrary
                )
            case .preview:
                VideoPreviewView(url: viewModel.videoUrl!,
                presented: $viewModel.showPicker)
            }
        }
    }
    
}

extension HomeView {
    
    func onCameraSelected() {
        if !validateCameraPermission() {
            return
        }
        guard UIImagePickerController.isSourceTypeAvailable(.camera)
        else { return }
        viewModel.picker = .camera
        viewModel.showPicker = true
    }
    
    func onPhotoSelected() {
        if !validatePhotoLibraryPermission() { return }
        showVideoPicker()
    }
    
    func showVideoPicker() {
        viewModel.picker = .gallery
        viewModel.showPicker = true
    }
    
    func validatePhotoLibraryPermission() -> Bool {
        if viewModel.photoStatus == .denied {
            environmentViewModel.type = .noPhoto
            environmentViewModel.showAlert = true
            return false
        }
        if viewModel.photoStatus == .authorized {
            return true
        }
        viewModel.requestLibraryPermission()
        return false
    }
    
    func validateCameraPermission() -> Bool {
        if viewModel.camStatus == .denied {
            environmentViewModel.type = .noCamera
            environmentViewModel.showAlert = true
            return false
        }
        if viewModel.camStatus == .authorized {
            return true
        }
        viewModel.requestCamPermission()
        return false
    }
    
}
