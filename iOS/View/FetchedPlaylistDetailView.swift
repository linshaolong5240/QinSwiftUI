//
//  PlaylistDetailView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/26.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct FetchedPlaylistDetailView: View {
    @State private var show: Bool = false
    
    let id: Int64

    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                if !show {
                    HStack {
                        NEUBackwardButton()
                        Spacer()
                        NEUNavigationBarTitleView("歌单详情")
                        Spacer()
                        Button(action: {}){
                            NEUSFView(systemName: "trash.fill")
                        }
                        .buttonStyle(NEUButtonStyle(shape: Circle()))
                    }
                    .padding(.horizontal)
                    .onAppear(perform: {
                        DispatchQueue.main.async {
                            show.toggle()
                        }
                    })
                    Spacer()
                }
                else{
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
                        
                        //                    HStack {
                        //                        Text("歌曲列表(\(String(viewModel.count)))")
                        //                            .fontWeight(.bold)
                        //                            .foregroundColor(.secondTextColor)
                        //                        Spacer()
                        //                        if type == .created {
                        //                            NEUEditButton(action: {
                        //                                if isMoved {
                        //                                    Store.shared.dispatch(.songsOrderUpdate(pid: viewModel.id, ids: viewModel.songIds))
                        //                                }
                        //                            })
                        //                        }
                        //                    }
                        //                    .padding(.horizontal)
                        //                        if editModeBinding?.wrappedValue.isEditing ?? false {
                        //                            PlaylistDetailEditSongsView(isMoved: $isMoved)
                        //                        }else {
                        //                        if let songsIds = playlist.songsIds {
                        //                            SongListView(songsIds: songsIds)
                        //                        }
                        //                        }
                    }
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
    let playlist :Playlist
    
    var body: some View {
        VStack {
            HStack {
                NEUBackwardButton()
                Spacer()
                NEUNavigationBarTitleView("歌单详情")
                Spacer()
                Button(action: {}){
                    NEUSFView(systemName: "trash.fill")
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
            }
            .padding(.horizontal)
            DescriptionView(viewModel: playlist)
            if let songs = playlist.songs {
                if let songsId = playlist.songsId {
                    SongListView(songs: Array(songs as! Set<Song>).sorted(by: { (left: Song, right) -> Bool in
                        let lIndex = songsId.firstIndex(of: left.id)!
                        let rIndex = songsId.firstIndex(of: right.id)!
                        return lIndex > rIndex ? false : true
                    }))
                }
            }else {
                Spacer()
            }
        }
    }
}

struct SongListView: View {
    @EnvironmentObject private var store: Store
    private var playing: AppState.Playing {store.appState.playing}
    @State private var showFavorite: Bool = false
    @State private var showPlayingNow: Bool = false
    @State private var showAlert: Bool = false
    
    let songs: [Song]
    
    var body: some View {
        VStack {
            NavigationLink(destination: PlayingNowView(), isActive: $showPlayingNow) {
                EmptyView()
            }
            HStack {
                Button(action: {
                    Store.shared.dispatch(.setPlayinglist(playinglist: songs.map{$0.id}, index: 0))
                    Store.shared.dispatch(.PlayerPlayByIndex(index: 0))
                }) {
                    Text("播放全部\(String(songs.count)) 首")
                        .fontWeight(.bold)
                        .foregroundColor(.secondTextColor)
                }
                Spacer()
                Text(showFavorite ? "喜欢" : "全部")
                    .fontWeight(.bold)
                    .foregroundColor(.secondTextColor)
                Toggle("", isOn: $showFavorite)
                    .fixedSize()
            }
            .padding(.horizontal)
            ScrollView {
                LazyVStack {
                    ForEach(songs) { item in
                        Button(action: {
                        }, label: {
                            SongRowView(song: item)
                                .padding(.horizontal)
                        })
                    }
                }
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
                            ForEach(item.artists) { item in
                                Text(item.name)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.secondTextColor)
                                    .lineLimit(1)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .onDelete(perform: deleteAction)
            .onMove(perform: moveAction)
        }
    }
    func deleteAction(from source: IndexSet) {
        if let index = source.first {
            viewModel.songs.remove(at: index)
            Store.shared.dispatch(.playlistTracks(pid: viewModel.id, op: false, ids: [viewModel.songsId[index]]))
        }
    }
    func moveAction(from source: IndexSet, to destination: Int) {
        isMoved = true
        viewModel.songsId.move(fromOffsets: source, toOffset: destination)
        viewModel.songs.move(fromOffsets: source, toOffset: destination)
    }
}
