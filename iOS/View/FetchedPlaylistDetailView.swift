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
    }
}
#endif

struct PlaylistDetailView: View {
    @ObservedObject var playlist :Playlist
    
    var body: some View {
        VStack {
            DescriptionView(viewModel: playlist)
            if let songs = playlist.songs {
                if let songsId = playlist.songsId {
                    SongListView(songs: Array(songs as! Set<Song>).sorted(by: { (left, right) -> Bool in
                        let lIndex = songsId.firstIndex(of: left.id)
                        let rIndex = songsId.firstIndex(of: right.id)
                        return lIndex ?? 0 > rIndex ?? 0 ? false : true
                    }))
                }
            }else {
                Spacer()
            }
        }
    }
}

struct PlaylistDetailEditSongsView: View {
    @EnvironmentObject var store: Store
    private var viewModel = PlaylistViewModel()
    @Binding var isMoved: Bool
    
    var body: some View {
        List {
            ForEach(viewModel.songs) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.mainTextColor )
                            .lineLimit(1)
                        HStack {
//                            ForEach(item.artists) { item in
//                                Text(item.name)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(Color.secondTextColor)
//                                    .lineLimit(1)
//                            }
                        }
                    }
                    Spacer()
                }
            }
//            .onDelete(perform: deleteAction)
//            .onMove(perform: moveAction)
        }
    }
//    func deleteAction(from source: IndexSet) {
//        if let index = source.first {
//            viewModel.songs.remove(at: index)
//            Store.shared.dispatch(.playlistTracks(pid: viewModel.id, op: false, ids: [viewModel.songsId[index]]))
//        }
//    }
//    func moveAction(from source: IndexSet, to destination: Int) {
//        isMoved = true
//        viewModel.songsId.move(fromOffsets: source, toOffset: destination)
//        viewModel.songs.move(fromOffsets: source, toOffset: destination)
//    }
}

struct CommonNavigationBarView: View {
    enum CommonNavigationBarType {
        case album, artist, playlist
    }
    @State private var showPlayingNow: Bool = false
    let id: Int64
    let title: String
    let type: CommonNavigationBarType
    
    var body: some View {
        HStack {
            NavigationLink(destination: PlayingNowView(), isActive: $showPlayingNow, label: {EmptyView()})
            NEUBackwardButton()
            Spacer()
            Button(action: {
                switch type {
                case .album:
                    Store.shared.dispatch(.album(id: id))
                case .artist:
                    Store.shared.dispatch(.artist(id: id))
                case .playlist:
                    if id == 0 {
                        Store.shared.dispatch(.recommendSongs)
                    } else {
                        Store.shared.dispatch(.playlistDetail(id: id))
                    }
                }
            }){
                Image(systemName: "arrow.triangle.2.circlepath")
            }
            Button(action: {
                showPlayingNow.toggle()
            }){
                NEUSFView(systemName: "music.quarternote.3")
            }
            .buttonStyle(NEUButtonStyle(shape: Circle()))
        }
        .overlay(
            HStack {
                NEUNavigationBarTitleView(title)
            }
        )
    }
}
