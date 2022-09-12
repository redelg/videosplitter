//
//  ContentView.swift
//  video splitter
//
//  Created by Renzo Delgado on 1/08/22.
//

import SwiftUI
import RevenueCat

class EnvironmentViewModel: ObservableObject {
    
    @Published var type: AlertType = .noCamera
    @Published var showAlert: Bool = false
    @Published var isProActive: Bool = false
    
    init() {
        checkSubscription()
    }
    
    func checkSubscription() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            self.isProActive = customerInfo?.entitlements.all["Pro"]?.isActive == true
        }
    }
    
}

struct ContentView: View {
    
    @State private var isNavBarHidden = true
    @StateObject var alertShowing = EnvironmentViewModel()

    var body: some View {
            HomeView()
                .environmentObject(alertShowing)
                .navigationBarHidden(isNavBarHidden)
                .alert(isPresented: $alertShowing.showAlert) {
                    switch alertShowing.type {
                    case .noCamera:
                        return Alert(
                            title: Text(StaticTexts.Camera_Permission_Title),
                            message: Text(StaticTexts.Camera_Permission_Content),
                            dismissButton: .default(Text("OK"), action: {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            })
                        )
                    case .noPhoto:
                        return Alert(
                            title: Text(StaticTexts.Photo_Permission_Title),
                            message: Text(StaticTexts.Photo_Permission_Content),
                            dismissButton: .default(Text("OK"), action: {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            })
                        )
                    case .minSeconds:
                        return Alert(
                            title: Text(StaticTexts.Video_Too_Short),
                            message: Text(StaticTexts.Video_Min_Length),
                            dismissButton: .default(Text("OK"), action: { } )
                        )
                    case .saveError:
                        return Alert(
                            title: Text(""),
                            message: Text(StaticTexts.SaveAllError),
                            dismissButton: .default(Text("OK"), action: { } )
                        )
                    case .saveSuccess:
                        return Alert(
                            title: Text(""),
                            message: Text(StaticTexts.SaveAllSuccess),
                            dismissButton: .default(Text("OK"), action: { } )
                        )
                    }
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
