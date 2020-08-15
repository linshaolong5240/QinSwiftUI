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
                ScrollView {
                    if user != nil {
                        VStack {
                            HStack(spacing: 20.0) {
                                NavigationLink(destination: UserView()) {
                                    NEUCircleButtonView(systemName: "person", size: .medium, active: false)
                                }
                                SearchBarView()
                                NEUCircleButtonView(systemName: "square.grid.3x3.fill", size: .medium, active: false).onTapGesture{
                                    self.showUser.toggle()
                                }
                            }
                            .padding()
                            PlaylistsView(title: "推荐的歌单",
                                          data: recommendPlaylists)
                            PlaylistsView(title: "创建的歌单",
                                          data: playlists.userPlaylists.filter{$0.userId == user!.uid})
                            PlaylistsView(title: "收藏的歌单",
                                          data: playlists.userPlaylists.filter{$0.userId != user!.uid})
                            Spacer()
                                .frame(height: screen.height / 4)
                        }
                        //                            .navigationTitle("网抑云")
                    }else {
                        UserView()
                    }
                }
                VStack {
                    Spacer()
                    BottomBarView()
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
