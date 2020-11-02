//
//  SongListView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/3.
//

import SwiftUI

struct SongListView: View {
    @State private var showLike: Bool = false
    
    let songs: [Song]
    
    var body: some View {
        VStack {
            let likeIds = Store.shared.appState.playlist.likedIds
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
                    Store.shared.dispatch(.PlayerPlayByIndex(index: 0))
                }) {
                    Text("播放全部")
                        .fontWeight(.bold)
                }
                Spacer()
                Text(showLike ? "喜欢" : "全部")
                    .fontWeight(.bold)
                    .foregroundColor(.secondTextColor)
                Toggle("", isOn: $showLike)
                    .fixedSize()
            }
            .padding(.horizontal)
            ScrollView {
                LazyVStack {
                    ForEach(songs) { item in
                        if !showLike || likeIds.contains(item.id) {
                            SongRowView(song: item)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}
