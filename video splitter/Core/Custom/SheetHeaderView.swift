//
//  SheetHeaderView.swift
//  video splitter
//
//  Created by Renzo Delgado on 9/07/22.
//

import SwiftUI

struct SheetHeaderView: View {
    
    let title: LocalizedStringKey
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            
            HStack {
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.black)
                })
                Spacer()
            }
            

            Text(title)
                .font(.system(size: 18, weight: .medium))
            
        }
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
    }
}

struct SheetHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SheetHeaderView(title: "Split Video", isPresented: .constant(true))
            //.previewLayout(.sizeThatFits)
    }
}
