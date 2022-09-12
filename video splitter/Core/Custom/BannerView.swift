//
//  BannerView.swift
//  video splitter
//
//  Created by Renzo Delgado on 30/08/22.
//

import SwiftUI

struct BannerAdView: View {
    
    let adUnit: String
    let adFormat: AdFormat
    @State var adStatus: AdStatus = .loading
    
    var body: some View {
        HStack {
            if adStatus != .failure {
                BannerViewController(adUnitID: adUnit, adSize: adFormat.adSize, adStatus: $adStatus)
                    .frame(width: adFormat.size.width, height: adFormat.size.height)
            }
        }.frame(maxWidth: .infinity)
    }
}
