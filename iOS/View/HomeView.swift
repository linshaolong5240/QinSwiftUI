//
//  HomeView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/30.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
#if os(iOS)
let screen = UIScreen.main.bounds
#endif
struct HomeView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    
    private var playlists: AppState.Playlists {store.appState.playlist}
    private var album: AppState.Album {store.appState.album}
    private var artist: AppState.Artist {store.appState.artist}

    private var user: User? {store.appState.settings.loginUser}
    
    var body: some View {
        NavigationView {
            ZStack {
                NEUBackgroundView()
                if user != nil {
                    VStack(spacing: 0) {
                        HStack(spacing: 20.0) {
                            Button(action: {}) {
                                NavigationLink(destination: UserView()) {
                                    NEUSFView(systemName: "person", size:  .small)
                                }
                            }
                            .buttonStyle(NEUButtonStyle(shape: Circle()))
                            SearchBarView()
                            Button(action: {}) {
                                NavigationLink(destination: DiscoverPlaylistView()) {
                                    NEUSFView(systemName: "square.grid.2x2", size:  .small)
                                }
                            }
                            .buttonStyle(NEUButtonStyle(shape: Circle()))
                        }
                        .padding([.leading, .bottom, .trailing])
                        Divider()
                        ScrollView {
                            Spacer()
                                .frame(height: 10)
                            PlaylistsView(title: "推荐的歌单", type: .recommendPlaylist)
                            PlaylistsView(title: "创建的歌单", type: .created)
                            PlaylistsView(title: "收藏的歌单", type: .subscribed)
                            AlbumSublistView()
                            ArtistSublistView()
                        }
                        BottomBarView()
                    }
                }else {
                    LoginView()
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
