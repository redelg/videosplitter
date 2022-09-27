//
//  BannerViewController.swift
//  video splitter
//
//  Created by Renzo Delgado on 30/08/22.
//

import SwiftUI
import GoogleMobileAds

enum AdStatus {
    
    case loading
    case success
    case failure
}

enum AdFormat {
    
    case largeBanner
    case mediumRectangle
    case adaptiveBanner
    
    var adSize: GADAdSize {
        switch self {
        case .largeBanner: return GADAdSizeLargeBanner
        case .mediumRectangle: return GADAdSizeMediumRectangle
        case .adaptiveBanner: return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        }
    }
    
    var size: CGSize {
        adSize.size
    }
    
}


struct BannerViewController: UIViewControllerRepresentable  {
    
    let adUnitID: String
    let adSize: GADAdSize
    @Binding var adStatus: AdStatus
    
    init(adUnitID: String, adSize: GADAdSize, adStatus: Binding<AdStatus>) {
        self.adUnitID = adUnitID
        self.adSize = adSize
        self._adStatus = adStatus
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(bannerViewController: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        let view = GADBannerView(adSize: adSize)
        view.delegate = context.coordinator
        view.adUnitID = adUnitID
        view.rootViewController = viewController
        view.load(GADRequest())
        
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: adSize.size)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        
        var bannerViewController: BannerViewController
        
        init(bannerViewController: BannerViewController) {
            self.bannerViewController = bannerViewController
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            bannerViewController.adStatus = .failure
        }
        
        func adViewDidReceiveAd(_ bannerView: GADBannerView) {
            bannerViewController.adStatus = .success
        }
    }
}
