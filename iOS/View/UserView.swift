//
//  UserView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/14.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var store: Store
    private var user: User? { store.appState.settings.loginUser }
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack(spacing: 20.0) {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                    NEUNavigationBarTitleView("用户")
                    Spacer()
                    Button(action: {
                    }) {
                        NavigationLink(destination: SettingsView()) {
                            NEUSFView(systemName: "gear", size: .medium)
                        }
                    }
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                NEUCoverView(url: user?.profile.avatarUrl ?? "", coverShape: .rectangle, size: .medium)
                Text("uid: \(String(user?.uid ?? 0))")
                Text("csrf: \(user?.csrf ?? "")")
                Button(action: {
                    Store.shared.dispatch(.logout)
                }) {
                    Text("退出登录")
                        .padding()
                }
                .buttonStyle(NEUButtonStyle(shape: Capsule()))
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .environmentObject(Store.shared)
            .environment(\.colorScheme, .light)
    }
}
#endif
