//
//  ShareSheet.swift
//  video splitter
//
//  Created by Renzo Delgado on 31/07/22.
//

import Foundation
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    
    var items: [URL]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
}
