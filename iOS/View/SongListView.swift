//
//  SongListView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/3.
//

import SwiftUI

struct SongListView: View {
    @EnvironmentObject private var store: Store
    @State private var showPlayingNow: Bool = false
    @State private var showLike: Bool = false
    
    let songs: [Song]
    
    var body: some View {
        VStack {
            NavigationLink(destination: PlayingNowView(), isActive: $showPlayingNow, label: {EmptyView()})
                .navigationViewStyle(StackNavigationViewStyle())
            HStack {
                Button(action: {
                    if showLike {
                        let likeIds = Store.shared.appState.playlist.likedIds
                        Store.shared.dispatch(.PlayinglistSet(playinglist: songs.map{$0.id}.filter({ (id) -> Bool in
                            return likeIds.contains(id)
                        }), index: 0))
                    }else {
                        Store.shared.dispatch(.PlayinglistSet(playinglist: songs.map{$0.id}, index: 0))
                    }
                    Store.shared.dispatch(.playerPlayBy(index: 0))
                }) {
                    Text(showLike ? "播放喜欢" : "播放全部")
                        .fontWeight(.bold)
                }
                Spacer()
                Text("喜欢")
                    .fontWeight(.bold)
                    .foregroundColor(.secondTextColor)
                Toggle("", isOn: $showLike)
                    .fixedSize()
            }
            .padding(.horizontal)
            ScrollView {
                LazyVStack {
                    ForEach(songs) { item in
                        if !showLike || store.appState.playlist.likedIds.contains(item.id) {
                            SongRowView(song: item)
                                .padding(.horizontal)
                                .onTapGesture {
                                    if item.id == Store.shared.appState.playing.song?.id {
                                        showPlayingNow.toggle()
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
}
