//
//  LoadingView.swift
//  video splitter
//
//  Created by Renzo Delgado on 17/07/22.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var text: LocalizedStringKey
    
    var body: some View {
        ZStack {
            Color.theme.loadingBackgroundColor
                .opacity(0.7)
                .ignoresSafeArea()
            HStack {
                if #available(iOS 15.0, *) {
                    ProgressView()
                        .tint(Color.theme.gradientStart)
                        .scaleEffect(1.5)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.theme.gradientStart))
                        .scaleEffect(1.5)
                }
                Text(text)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.leading, 20)
            }
            .frame(width: 250, height: 80)
            .background(
                Color.white
            )
            .cornerRadius(5)
            .shadow(radius: 3)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(text: .constant("Splitting Video"))
    }
}
