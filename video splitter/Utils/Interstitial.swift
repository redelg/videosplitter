//
//  Interstitial.swift
//  video splitter
//
//  Created by Renzo Delgado on 22/07/22.
//

import GoogleMobileAds

class Interstitial: NSObject, GADFullScreenContentDelegate {
    
    // Ads
    private var interstitial: GADInterstitialAd?
    var presentHandler: (() -> Void)? = nil
    var dismissHandler: (() -> Void)? = nil
    
    override init() {
        super.init()
        self.loadInterstitial()
    }
    
    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: Ads.close_done, request: request) { ad, error in
            if let error = error {
              return print("Failed to load interstitial ad with error: \(error.localizedDescription)")
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    func showAd() {
        if self.interstitial != nil {
            let root = UIApplication.shared.windows.first?.rootViewController
            self.interstitial?.present(fromRootViewController: root!)
        } else {
            presentHandler?()
            dismissHandler?()
        }
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       presentHandler?()
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       dismissHandler?()
    }
    
}
