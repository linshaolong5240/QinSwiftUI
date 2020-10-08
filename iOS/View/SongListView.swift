//
//  SongListView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/9.
//

import SwiftUI

struct SongListView: View {
    @EnvironmentObject var store: Store
    private var playing: AppState.Playing { store.appState.playing }
    
    let songs: [SongViewModel]
    @State var showPlayingNow: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<songs.count, id: \.self) { index in
                        SongRowView(viewModel: songs[index], action: {
                            if  playing.songDetail.id == songs[index].id {
                                store.dispatch(.PlayerPlayOrPause)
                            }else {
                                Store.shared.dispatch(.setPlayinglist(playinglist: songs, index: index))
                                Store.shared.dispatch(.playByIndex(index: index))
                            }
                        })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if  playing.songDetail.id == songs[index].id {
                                showPlayingNow.toggle()
                            }else {
                                Store.shared.dispatch(.setPlayinglist(playinglist: songs, index: index))
                                Store.shared.dispatch(.playByIndex(index: index))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            NavigationLink(destination: PlayingNowView(), isActive: $showPlayingNow) {
                EmptyView()
            }
        }
    }
}

#if DEBUG
struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView(songs: [SongViewModel]())
    }
}
#endif
