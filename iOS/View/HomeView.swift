//
//  HomeView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/30.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    
    private var recommendPlaylists: [PlaylistViewModel] {store.appState.playlists.recommendPlaylists}
    private var playlists: AppState.Playlists {store.appState.playlists}
    
    private var user: User? {store.appState.settings.loginUser}
    private var showPlaylistDetail: Bool {store.appState.playlists.showPlaylistDetail}
    @State var showUser: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                if user != nil {
                    VStack {
                        HStack(spacing: 20.0) {
                            Button(action: {}) {
                                NavigationLink(destination: UserView()) {
                                    NEUButtonView(systemName: "person", size: .medium)
                                }
                            }
                            .buttonStyle(NEUButtonStyle(shape: Circle()))
                            SearchBarView()
                        }
                        .padding(.horizontal)
                        ScrollView {
                            VStack {
                                PlaylistsView(title: "推荐的歌单",
                                              data: recommendPlaylists)
                                PlaylistsView(title: "创建的歌单",
                                              data: playlists.userPlaylists.filter{$0.userId == user!.uid})
                                PlaylistsView(title: "收藏的歌单",
                                              data: playlists.userPlaylists.filter{$0.userId != user!.uid})
                                Spacer()
                                    .frame(height: screen.height / 5)
                            }
                        }
                    }
                    VStack {
                        Spacer()
                        BottomBarView()
                    }
                }else {
                    UserView()
                }
            }
            .navigationBarHidden(true)
        }
        .accentColor(.orange)
        .alert(item: $store.appState.error) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Store.shared)
            .environmentObject(Player.shared)
            .environment(\.colorScheme, .light)
    }
}
