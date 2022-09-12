//
//  SettingsView.swift
//  video splitter
//
//  Created by Renzo Delgado on 1/08/22.
//

import SwiftUI

enum SettingEvent {
    case premium
    case privacy
    case ourApps
    case none
}

struct Setting: Identifiable {
    
    let id: SettingEvent
    let icon: String
    let title: LocalizedStringKey
    
}

struct SettingsView: View {
    
    @State private var showPremium = false
    private var items = [
        Setting(id: .premium, icon: "suitcase", title: StaticTexts.PremiumVersion),
        Setting(id: .ourApps, icon: "square.grid.2x2", title: StaticTexts.MoreApps),
        Setting(id: .privacy, icon: "exclamationmark.shield", title: StaticTexts.PrivacyPolicy)
    ]
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .foregroundColor(Color.theme.background)
                    .frame(height: 20)
                ForEach(items) { item in
                    Button(action: {
                        self.handleEvent(item.id)
                    }, label: {
                        HStack {
                            Image(systemName: item.icon)
                                .foregroundColor(.blue)
                            Text(item.title)
                                .fontWeight(.semibold)
                                .font(.subheadline)
                                .padding(.leading, 10)
                            Spacer()
                        }
                    })
                    .padding(.leading, 20)
                    .frame(height: 35)
                    Divider()
                }
                .buttonStyle(.plain)
                HStack {
                    Image(systemName: "exclamationmark.circle")
                        .foregroundColor(.blue)
                    Text("Version \(StaticTexts.appVersion ?? "")")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(.leading, 20)
                .frame(height: 35)
                Spacer()
            }
        }
        .sheet(isPresented: $showPremium) {
            PremiumView()
        }
        .navigationBarHidden(false)
        .navigationTitle("Opciones")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    
    func handleEvent(_ type: SettingEvent) {
        switch type {
        case .premium:
            showPremium.toggle()
        case .privacy:
            handlePrivacy()
        case .ourApps:
            handleMoreApps()
        case .none:
            break
        }
    }
    
    func handleMoreApps() {
        guard let url = URL(string: "https://apps.apple.com/pe/developer/renzo-delgado/id1506040089")
                else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(url)
    }
    
    func handlePrivacy() {
        guard let url = URL(string: "https://codergangteam.com/?page_id=3")
                else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(url)
    }
    
}
