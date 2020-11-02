//
//  SongListView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/3.
//

import SwiftUI

struct SongListView: View {
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
                    Store.shared.dispatch(.PlayinglistSet(playinglist: songs.map{$0.id}, index: 0))
                    Store.shared.dispatch(.PlayerPlayByIndex(index: 0))
                }) {
                    Text("播放全部\(String(songs.count)) 首")
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
