//
//  PremiumViewModel.swift
//  video splitter
//
//  Created by Renzo Delgado on 2/08/22.
//

import RevenueCat
import SwiftUI

class PremiumViewModel: ObservableObject {
    
    @Published var currentPackage: Package? = nil
    
    init() {
        Purchases.shared.getOfferings { [weak self] offerings, error in
            if let offer = offerings?.current, error == nil {
                self?.currentPackage = offer.availablePackages.first
            }
        }
    }
    
    let features: [PremiumFeature] = [
        PremiumFeature(id: 0, icon: .adsRectangle, title: StaticTexts.RemoveAdsTitle, caption: StaticTexts.RemoveAdsCaption),
        PremiumFeature(id: 1, icon: .creditCard, title: StaticTexts.SinglePaymentTitle, caption: StaticTexts.SinglePaymentCaption),
        PremiumFeature(id: 2, icon: .share, title: StaticTexts.ShareAtOnceTitle, caption: StaticTexts.ShareAtOnceCaption),
        PremiumFeature(id: 3, icon: .save, title: StaticTexts.SaveAtOnceTitle, caption: StaticTexts.SaveAtOnceCaption)
    ]
    
}
