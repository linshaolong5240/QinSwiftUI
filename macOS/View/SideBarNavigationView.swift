//
//  SideBarNavigationView.swift
//  Qin (macOS)
//
//  Created by 林少龙 on 2021/7/3.
//

import SwiftUI

struct SideBarNavigationView: View {
    @EnvironmentObject private var store: Store
    //    @EnvironmentObject private var player: Player
    //    private var album: AppState.Album { store.appState.album }
    //    private var artist: AppState.Artist { store.appState.artist }
    //    private var playlist: AppState.Playlist { store.appState.playlist }
    private var user: User? { store.appState.settings.loginUser }

    @State private var selection: Int?
    
    var body: some View {
        NavigationView {
            VStack {
                if user != nil {
                    ZStack {
                        NEUBackgroundView()
                        List {
                            VStack(alignment: .center, spacing: 20) {
                                NEUCoverView(url: user?.profile.avatarUrl, coverShape: .rectangle, size: .small)
                                if let name = user?.profile.nickname {
                                    Text(name)
                                }
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        Store.shared.dispatch(.logoutRequest)
                                    }) {
                                        Text("退出登录")
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                    }
                                    .buttonStyle(NEUButtonStyle(shape: Capsule()))
                                    Spacer()
                                }
                            }
                            .padding()
                            NavigationLink("我的云盘", destination: UserCloudView(), tag: 0, selection:  $selection)
                            NavigationLink("上传音乐", destination: CloudUploadView(), tag: 1, selection:  $selection)
                        }
                    }
                }else {
                    LoginView()
                }
            }
            .frame(minWidth: 200, idealWidth: 200, maxWidth: 200)
        }
        .onAppear(perform: {
            selection = 0
        })
    }
}

#if DEBUG
struct SideBarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarNavigationView()
            .environmentObject(Store.shared)
            .environmentObject(Player.shared)
            .environment(\.colorScheme, .light)
    }
}
#endif
