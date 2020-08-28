//
//  SettingView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/14.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Form {
            Section {
                NavigationLink(destination: ThemeSelectView()) {
                    Text("主题")
                }
            }
        }
    }
}
struct ThemeSelectView: View {
    @EnvironmentObject var store: Store
    private var settings: AppState.Settings {store.appState.settings}
    
    var body: some View {
        VStack {
            Form {
                Section {
                    ForEach(AppState.Settings.Theme.allCases, id: \.self) { item in
                        Button(action: {
                        }) {
                            HStack {
                                Text("\(String(describing: item))")
                                Spacer()
                                if item == settings.theme {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
#if DEBUG
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView().environmentObject(Store())
        }
    }
}
#endif
