//
//  HomeView.swift
//  Qin
//
//  Created by teenloong on 2020/6/30.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import NeumorphismSwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var player: Player
    private var album: AppState.Album { store.appState.album }
    private var artist: AppState.Artist { store.appState.artist }
    private var playlist: AppState.Playlist { store.appState.playlist }
    private var user: User? { store.appState.settings.loginUser }
        
    var body: some View {
        NavigationView {
            ZStack {
                QinBackgroundView()
                if user != nil {
                    VStack(spacing: 0) {
                        HStack(spacing: 20.0) {
                            Button(action: {}) {
                                NavigationLink(destination: UserView()) {
                                    QinSFView(systemName: "person", size:  .small)
                                }
                            }
                            .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
                            QinSearchBarView()
                            Button(action: {}) {
                                NavigationLink(destination: DiscoverPlaylistView(viewModel: .init(catalogue: store.appState.discoverPlaylist.catalogue))) {
                                    QinSFView(systemName: "square.grid.2x2", size:  .small)
                                }
                            }
                            .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
                        }
                        .padding([.leading, .bottom, .trailing])
                        Divider()
                        if store.appState.initRequestingCount == 0 {
                            ScrollView {
                                VStack {
                                    RecommendPlaylistView(playlist: playlist.recommendPlaylist)
                                        .padding(.top, 10)
                                    CreatedPlaylistView(playlist: playlist.userPlaylist.filter({ $0.userId == user?.userId }))
                                    SubedPlaylistView(playlist: playlist.userPlaylist.filter({ $0.userId != user?.userId }))
                                    SubedAlbumsView(albums: album.albumSublist)
                                    ArtistSublistView(artists: artist.artistSublist)
                                }
                            }
                            PlayerControlBarView()
                        }else {
                            Spacer()
                        }
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }else {
                    LoginView()
                }
            }
            .onTapGesture {
                self.hideKeyboard()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(item: $store.appState.error) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Store.shared)
            .environmentObject(Player.shared)
            .environment(\.colorScheme, .light)
    }
}
#endif
