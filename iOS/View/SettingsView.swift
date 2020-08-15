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
        NavigationView {
            Form {
                Section {
                    if store.appState.settings.loginUser != nil {
                        Text(store.appState.settings.loginUser!.profile.nickname)
                        Button(action: {self.store.dispatch(.logout)}) {
                            Text("退出登录")
                        }
                    }else {
                        NavigationLink(destination: UserView()) {
                            Text("登录")
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }.navigationBarTitle("Setting")
        }
    }
}
#if DEBUG
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(Store())
    }
}
#endif
