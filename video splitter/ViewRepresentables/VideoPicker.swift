//
//  VideoPicker.swift
//  video splitter
//
//  Created by Renzo Delgado on 3/07/22.
//

import UIKit
import SwiftUI
import PhotosUI

struct VideoPicker: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var picker: PickerType
    @Binding var url: URL?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .videos
        configuration.preferredAssetRepresentationMode = .current
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Coordinator
    internal class Coordinator: PHPickerViewControllerDelegate {
        
        private let parent: VideoPicker
        
        init(_ parent: VideoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard
                !results.isEmpty,
                let provider = results.first?.itemProvider else {
                parent.url = nil
                parent.isPresented = false
                return
            }
            provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] (videoURL, error) in
                DispatchQueue.main.async {
                    if let url = videoURL {
                        self?.parent.url = url
                        self?.parent.picker = .preview
                    }
                }
            }
        }
        
    }
    
    //file:///private/var/mobile/Containers/Data/Application/09027325-E695-4745-A3C4-3684C07711AB/tmp/67868414240__501AD4D7-BEE2-43BC-8262-86DD96C576D5.MOV
    //file:///private/var/mobile/Containers/Data/Application/82D65E7D-95C7-4819-9A26-CB1FE331232C/tmp/.com.apple.Foundation.NSItemProvider.9Xt48c/IMG_0393.mov
}
