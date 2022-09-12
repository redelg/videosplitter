//
//  Color.swift
//  video splitter
//
//  Created by Renzo Delgado on 17/07/22.
//

import SwiftUI
import UIKit

extension Color {
 
    static let theme = ColorTheme()
    
}

struct ColorTheme {
    
    //let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let backgroundSlider = Color("BackgroundSlider")
    let loadingBackgroundColor = Color("LoadingBackgroundColor")
    let itemBackground = Color("ItemBackgroundColor")
    let gradientStart = Color("GradientStart")
    let gradientEnd = Color("GradientEnd")

}

extension UIColor {
    
    static let theme = UIColorTheme()
    
}

struct UIColorTheme {
    
    let background = UIColor(named: "BackgroundColor")
    
}
