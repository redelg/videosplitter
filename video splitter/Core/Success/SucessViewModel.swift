//
//  SucessViewModel.swift
//  video splitter
//
//  Created by Renzo Delgado on 25/08/22.
//

import SwiftUI
import AVFoundation

@MainActor
class SuccessViewModel: ObservableObject {
    
    @Binding var isLoading: Bool
    @Binding var loadingText: LocalizedStringKey
    
    init(loading: Binding<Bool>, loadingText: Binding<LocalizedStringKey>) {
        _isLoading = loading
        _loadingText = loadingText
    }
    
}
