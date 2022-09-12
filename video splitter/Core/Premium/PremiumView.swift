//
//  PremiumView.swift
//  video splitter
//
//  Created by Renzo Delgado on 1/08/22.
//

import SwiftUI
import RevenueCat

struct PremiumView: View {
    
    @StateObject private var viewmodel = PremiumViewModel()
    @EnvironmentObject private var environmentViewModel: EnvironmentViewModel
    
    @State var loading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Rectangle()
                        .foregroundColor(Color.theme.background)
                        .frame(height: 0.5)
                    
                    List(viewmodel.features) { item in
                        HStack {
                            item.icon
                                .foregroundColor(Color.theme.gradientStart)
                                .padding(.trailing, 7)
                            VStack(alignment: .leading){
                                Text(item.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 1)
                                Text(item.caption)
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding([.top, .bottom], 5)
                    }
            
                    purchaseButton
                    
                }
                .preferredColorScheme(.light)
                .navigationTitle(StaticTexts.GetPro)
                
                if loading {
                    LoadingView(text: .constant(StaticTexts.Purchasing))
                }
                
            }
        }
    }
}

struct PremiumView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumView()
            .environmentObject(EnvironmentViewModel())
    }
}

extension PremiumView {
    
    var purchaseButton: some View {
        Group {
            if viewmodel.currentPackage != nil {
                if environmentViewModel.isProActive {
                    Button(action: { }, label: {
                        Text(StaticTexts.Purchased)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                    })
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [Color.theme.gradientStart, Color.theme.gradientEnd], startPoint: .leading, endPoint: .trailing)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    )
                    .padding()
                } else {
                    Button(action: {
                        purchase()
                    }, label: {
                        Text("Buy \(viewmodel.currentPackage?.storeProduct.localizedPriceString ?? "")")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                    })
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [Color.theme.gradientStart, Color.theme.gradientEnd], startPoint: .leading, endPoint: .trailing)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    )
                    .padding([.leading, .trailing], 10)
                    
                    Button(action: { }, label: {
                        Text(StaticTexts.Restore)
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding()
                    })
                    .frame(maxWidth: .infinity)
                }
            } else {
                Button(action: { }, label: {
                    if #available(iOS 15.0, *) {
                        ProgressView()
                            .tint(Color.white)
                            .scaleEffect(1.5)
                            .padding()
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            .scaleEffect(1.5)
                            .padding()
                    }
                })
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [Color.theme.gradientStart, Color.theme.gradientEnd], startPoint: .leading, endPoint: .trailing)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                )
                .padding()
            }
        }
    }
    
}


extension PremiumView {
    
    func purchase() {
        guard let package = viewmodel.currentPackage else {
            return
        }
        loading = true
        Purchases.shared.purchase(package: package) { (transaction, customerInfo, error, userCancelled) in
            loading = false
            if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                environmentViewModel.isProActive = true
            }
        }
    }
    
    func restore() {
        Purchases.shared.restorePurchases { (customerInfo, error) in
            if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                environmentViewModel.isProActive = true
            }
        }
    }
    
}
