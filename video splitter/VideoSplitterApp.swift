//
//  video_splitterApp.swift
//  video splitter
//
//  Created by Renzo Delgado on 25/06/22.
//

import SwiftUI
import GoogleMobileAds
import RevenueCat

@main
struct VideoSplitterApp: App {
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
        //GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "cfa13d7fc57942041b4caa9782730fb0" ]
        //Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_LATcfZOVEtPdtmeyjpkEKvHZZRU")
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // configure
        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.white] // fix text color
        appearance.backButtonAppearance = backItemAppearance
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.black, renderingMode: .alwaysOriginal) // fix indicator color
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        //UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        
        UITableView.appearance().backgroundColor = UIColor.theme.background
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, .light)
        }
    }
}

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
