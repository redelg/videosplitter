//
//  VideoCapture.swift
//  video splitter
//
//  Created by Renzo Delgado on 3/07/22.
//

import UIKit
import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

struct VideoRecorder: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var picker: PickerType
    
    @Binding var url: URL?
    
    @Binding var alertType: AlertType
    @Binding var showAlert: Bool
    
    var source: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        controller.sourceType = source
        controller.mediaTypes = [UTType.movie.identifier]
        controller.delegate = context.coordinator
        controller.allowsEditing = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    internal class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent : VideoRecorder
        
        init(_ parent: VideoRecorder) {
          self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.url = nil
            parent.isPresented = false
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            guard
                let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
                mediaType == UTType.movie.identifier,
                let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            else {
                parent.url = nil
                parent.isPresented = false
                return
            }
            let asset = AVURLAsset(url: url)
            let durationInSeconds = asset.duration.seconds
            
            if durationInSeconds < StaticValues.MinSeconds {
                parent.url = nil
                parent.isPresented = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
                    self?.parent.alertType = .minSeconds
                    self?.parent.showAlert = true
                })
                return
            }
            
            parent.url = url
            parent.picker = .preview
        }
        
    }
    
}
