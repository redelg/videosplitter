//
//  HomeViewModel.swift
//  video splitter
//
//  Created by Renzo Delgado on 28/06/22.
//

import Foundation
import PermissionsKit
import CameraPermission
import MicrophonePermission
import PhotoLibraryPermission
import SwiftUI


class HomeViewModel: ObservableObject {
    
    @Published var picker: PickerType = .gallery
    @Published var showPicker = false
    
    @Published var videoUrl: URL? = nil
    
    func requestCamPermission() {
        if camStatus == .denied {
            return
        }
        Permission.camera.request { [weak self] in
            let authorized = Permission.camera.authorized
            if authorized {
                self?.picker = .camera
                self?.showPicker = true
                self?.requestMicPermission()
            }
        }
    }
    
    func requestMicPermission() {
        if micStatus == .denied {
            return
        }
        Permission.microphone.request { } 
    }
    
    func requestLibraryPermission() {
        if photoStatus == .denied {
            return
        }
        Permission.photoLibrary.request { }
    }
    
}

extension HomeViewModel {
    
    var micStatus: Permission.Status {
        Permission.microphone.status
    }
    var camStatus: Permission.Status {
        Permission.camera.status
    }
    var photoStatus: Permission.Status {
        Permission.photoLibrary.status
    }
    
}
