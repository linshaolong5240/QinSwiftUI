//
//  FetchedPlaylistDetailView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/26.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import Combine

struct FetchedPlaylistDetailView: View {
    @State private var show: Bool = false
    
    let id: Int64
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                CommonNavigationBarView(id: id, title: "歌单详情", type: .playlist)
                    .padding(.horizontal)
                    .onAppear {
                        DispatchQueue.main.async {
                            show = true
                        }
                    }
                if show {
                    FetchedResultsView(entity: Playlist.entity(), predicate: NSPredicate(format: "%K == \(id)", "id")) { (results: FetchedResults<Playlist>) in
                        if let playlist = results.first {
                            PlaylistDetailView(playlist: playlist)
                        }else {
                            Text("正在加载")
                                .onAppear {
                                    Store.shared.dispatch(.playlistDetail(id: id))
                                }
                            Spacer()
                        }
                    }
                }else {
                    Text("正在加载")
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#if DEBUG
struct PlaylistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                FetchedPlaylistDetailView(id: 0)
            }
        }
        .environmentObject(Store.shared)
        .environmentObject(Player.shared)
        .preferredColorScheme(.light)
    }
}
#endif

struct PlaylistDetailView: View {
    @ObservedObject var playlist :Playlist
    @State private var showPlaylistSongsManage: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            DescriptionView(viewModel: playlist)
            HStack {
                Text("id:\(String(playlist.id))")
                    .foregroundColor(.secondTextColor)
                Spacer()
                if !Store.shared.appState.playlist.createdPlaylistIds.contains(playlist.id) {
                    Button(action: {
                        let id = playlist.id
                        let sub = !Store.shared.appState.playlist.subedPlaylistIds.contains(id)
                        Store.shared.dispatch(.playlistSubscibe(id: id, sub: sub))
                    }) {
                        NEUSFView(systemName: Store.shared.appState.playlist.userPlaylistIds.contains(playlist.id) ? "heart.fill" : "heart",
                                  size: .small)
                    }
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }else {
                    Button(action: {
                        showPlaylistSongsManage.toggle()
                    }) {
                        NEUSFView(systemName: "lineweight",
                                  size: .small)
                            .sheet(isPresented: $showPlaylistSongsManage) {
                                PlaylistSongsManageView(showSheet: $showPlaylistSongsManage, playlist: playlist)
                            }
                    }
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
            }
            .padding(.horizontal)
            if let songs = playlist.songs?.allObjects as? [Song] {
                if let songsId = playlist.songsId {
                    SongListView(songs: songs.sorted(by: { (left, right) -> Bool in
                        let lIndex = songsId.firstIndex(of: left.id)
                        let rIndex = songsId.firstIndex(of: right.id)
                        return lIndex ?? 0 > rIndex ?? 0 ? false : true
                    }))
                }else {
                    Spacer()
                }
            }else {
                Spacer()
            }
        }
    }
}

struct CommonNavigationBarView: View {
    enum CommonNavigationBarType {
        case album, artist, mv, playlist
    }
    let id: Int64
    let title: String
    let type: CommonNavigationBarType
    
    var body: some View {
        HStack {
            NEUBackwardButton()
            Spacer()
            Button(action: {
                switch type {
                case .album:
                    Store.shared.dispatch(.albumRequest(id: Int(id)))
                case .artist:
                    Store.shared.dispatch(.artistRequest(id: id))
                case .mv:
                    Store.shared.dispatch(.mvDetailRequest(id: id))
                case .playlist:
                    if id == 0 {
                        Store.shared.dispatch(.recommendSongs)
                    } else {
                        Store.shared.dispatch(.playlistDetail(id: id))
                    }
                }
            }){
                NEUSFView(systemName: "arrow.triangle.2.circlepath",inactiveColor: .accentColor)
            }
            PlayingNowButtonView()
        }
        .overlay(
            HStack {
                NEUNavigationBarTitleView(title)
            }
        )
    }
}
