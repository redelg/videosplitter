//
//  HomeSelectButton.swift
//  video splitter
//
//  Created by Renzo Delgado on 27/06/22.
//

import SwiftUI

struct MainOption {
    let image: Image
    let text: LocalizedStringKey
    let caption: LocalizedStringKey
    var action: (() -> Void)? = nil
}

struct HomeSelectButton: View {
    
    let option: MainOption
    
    var body: some View {
        
        Button(action: {
            option.action?()
        }, label: {
            HStack {
                option.image
                    .frame(width: 50, height: 50)
                    .scaledToFit()
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                VStack(alignment: .leading, spacing: 4) {
                    Text(option.text)
                        .font(.title3)
                        .fontWeight(.medium)
                    Text(option.caption)
                        .fontWeight(.light)
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                Spacer()
            }
        })
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.theme.itemBackground)
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

struct HomeSelectButton_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            HomeSelectButton(
                option: MainOption(image: .camera, text: StaticTexts.Camera, caption: StaticTexts.Camera_Caption, action: {})
            )
            //.previewLayout(.sizeThatFits)
            
            HomeSelectButton(
                option: MainOption(image: .video, text: StaticTexts.Camera, caption: StaticTexts.Camera_Caption, action: {})
            )
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
        
    }
}
