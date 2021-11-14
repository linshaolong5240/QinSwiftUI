//
//  UserView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/14.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import NeumorphismSwiftUI

struct UserView: View {
    @EnvironmentObject var store: Store
    private var user: User? { store.appState.settings.loginUser }
    
    var body: some View {
        ZStack {
            QinBackgroundView()
            VStack(spacing: 20.0) {
                HStack {
                    QinBackwardButton()
                    Spacer()
                    QinNavigationBarTitleView("用户")
                    Spacer()
                    Button(action: {
                    }) {
                        NavigationLink(destination: SettingsView()) {
                            QinSFView(systemName: "gear", size: .medium)
                        }
                    }
                    .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
                }
                QinCoverView(user?.profile.avatarUrl, style: QinCoverStyle(size: .medium, shape: .rectangle))
                if let uid = user?.profile.userId {
                    Text("uid: \(uid)")
                }
                Button(action: {
                    Store.shared.dispatch(.logoutRequest)
                }) {
                    Text("退出登录")
                        .padding()
                }
                .buttonStyle(NEUDefaultButtonStyle(shape: Capsule()))
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
