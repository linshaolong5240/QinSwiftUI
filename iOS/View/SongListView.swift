//
//  SongListView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/3.
//

import SwiftUI
import NeumorphismSwiftUI

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
                        let likeIds = Store.shared.appState.playlist.songlikedIds
                        Store.shared.dispatch(.PlayerPlaySongs(songs: songs.map(QinSong.init)
                                                                .filter({ likeIds.contains($0.id) })))
                    }else {
                        Store.shared.dispatch(.PlayerPlaySongs(songs: songs.map(QinSong.init)))
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
                    .toggleStyle(NEUDefaultToggleStyle())
                    .fixedSize()
                    .accentColor(.orange)
            }
            .padding(.horizontal)
            ScrollView {
                LazyVStack {
                    ForEach(songs) { item in
                        if !showLike || store.appState.playlist.songlikedIds.contains(Int(item.id)) {
                            QinSongRowView(viewModel: .init(item.asQinSong()))
                                .padding(.horizontal)
                                .onTapGesture {
                                    if Int(item.id) == Store.shared.appState.playing.song?.id {
                                        showPlayingNow.toggle()
                                    }
                                }
                        }
                    }
                }
                .padding(.vertical)
            }
        }
    }
}
