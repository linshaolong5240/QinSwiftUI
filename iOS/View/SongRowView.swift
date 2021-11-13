//
//  SongRowView.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/12.
//

import SwiftUI

struct SongRowView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var player: Player
    private var playing: AppState.Playing {  store.appState.playing }
    let song: Song
    
    init(song: Song) {
        self.song = song
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(song.name ?? "")
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                    .lineLimit(1)
                if let artists = song.artists?.allObjects as? [Artist] {
                    HStack {
                        ForEach(artists) { item in
                            Text(item.name ?? "")
                                .foregroundColor(Color.secondTextColor)
                                .lineLimit(1)
                        }
                    }
                }
            }
            Spacer()
            Button(action: {
                let like = !Store.shared.appState.playlist.songlikedIds.contains(Int(song.id))
                Store.shared.dispatch(.songLikeRequest(id: Int(song.id), like: like))
            }, label: {
                Image(systemName: store.appState.playlist.songlikedIds.contains(Int(song.id)) ? "heart.fill" : "heart")
                    .foregroundColor(Color.mainTextColor)
                    .padding(.horizontal)
            })
            Button(action: {
                if playing.song?.id == song.id {
                    Store.shared.dispatch(.playerPlayOrPause)
                }else {
                    Store.shared.dispatch(.playinglistInsert(id: Int(song.id)))
                }
            }) {
                QinSFView(systemName: player.isPlaying && song.id == playing.song?.id ? "pause.fill" : "play.fill",
                          size: .small,
                          active: song.id == playing.song?.id && player.isPlaying ?  true : false,
                          activeColor: song.id == playing.song?.id ? Color.orange : Color.mainTextColor,
                          inactiveColor: song.id == playing.song?.id ? Color.orange : Color.mainTextColor)
            }
            .buttonStyle(NEUConvexBorderButtonStyle(shape: Circle(), toggle: song.id == playing.song?.id && player.isPlaying ?  true : false))
        }
        .padding(10)
        .background(
            NEUListRowBackgroundView(isHighlighted: song.id == playing.song?.id)
        )
    }
}

#if DEBUG
    
//struct SongRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            NEUBackgroundView()
//            SongRowView(viewModel: SongViewModel(id: 0, name: "tewst", artists: [SongViewModel.Artist(id: 0, name: "test")]),
//                        index: 999)
//                .padding(.horizontal)
//                .preferredColorScheme(.dark)
//                .environmentObject(Store.shared)
//                .environmentObject(Player.shared)
//        }
//    }
//}
#endif
