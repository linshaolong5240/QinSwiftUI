//
//  HomeView.swift
//  Qin (macOS)
//
//  Created by 林少龙 on 2021/7/3.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: Store
    //    @EnvironmentObject private var player: Player
    //    private var album: AppState.Album { store.appState.album }
    //    private var artist: AppState.Artist { store.appState.artist }
    //    private var playlist: AppState.Playlist { store.appState.playlist }
    private var user: User? { store.appState.settings.loginUser }
    var body: some View {
        VStack {
            if user != nil {
                SideBarView()
            }else {
                LoginView()
            }
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
    }
}

struct SideBarView: View {
    @State private var selection: Int? = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                NEUBackgroundView()
                List {
                    NavigationLink("test", destination: Text("Destination0"), tag: 0, selection:  $selection)
                    NavigationLink("test", destination: Text("Destination1"), tag: 1, selection:  $selection)
                    NavigationLink("test", destination: Text("Destination2"), tag: 2, selection:  $selection)
                }
            }
        }
    }
}
