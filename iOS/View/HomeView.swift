//
//  HomeView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/30.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var player: Player

    private var user: User? { store.appState.settings.loginUser }
    
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
                        if store.appState.initRequestingCount == 0 {
                            ScrollView {
                                LazyVStack {
                                    Spacer()
                                        .frame(height: 10)
                                    RecommendPlaylistView()
                                    CreatedPlaylistView()
                                    SubedPlaylistView()
                                    SubedAlbumsView()
                                    SubedArtistsView()
                                }
                            }
                        }else {
                            Spacer()
                        }
                        BottomBarView()
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
        .accentColor(.orange)
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
