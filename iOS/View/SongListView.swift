//
//  SongListView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/3.
//

import SwiftUI

struct SongListView: View {
    @State private var showFavorite: Bool = false
    
    let songs: [Song]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if showFavorite {
                        let likeIds = Store.shared.appState.playlist.likedIds
                        Store.shared.dispatch(.PlayinglistSet(playinglist: songs.map{$0.id}.filter({ (id) -> Bool in
                            return likeIds.contains(id)
                        }), index: 0))
                    }else {
                        Store.shared.dispatch(.PlayinglistSet(playinglist: songs.map{$0.id}, index: 0))
                    }
                    Store.shared.dispatch(.PlayerPlayByIndex(index: 0))
                }) {
                    Text(showFavorite ? "播放喜欢\(String(songs.count)) 首" : "播放全部\(String(songs.count)) 首")
                        .fontWeight(.bold)
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
