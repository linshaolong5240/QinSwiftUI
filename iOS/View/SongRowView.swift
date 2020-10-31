//
//  SongRowView.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/12.
//

import SwiftUI

struct SongRowView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    private var playing: AppState.Playing {
        store.appState.playing
    }
    
    let song: Song
    let action: () -> Void
    
    init(song: Song, action: @escaping () -> Void = {}) {
        self.song = song
        self.action = action
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(song.name ?? "")
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                    .lineLimit(1)
                HStack {
                    ForEach(Array(song.ar as! Set<Artist>)) { item in
                        Text(item.name ?? "")
                            .foregroundColor(Color.secondTextColor)
                            .lineLimit(1)
                    }
                }
            }
            Spacer()
//            Button(action: {
//                Store.shared.dispatch(.like(song: viewModel))
//            }, label: {
//                Image(systemName: viewModel.liked ? "heart.fill" : "heart")
//                    .foregroundColor(Color.mainTextColor)
//                    .frame(width: 30, height: 30, alignment: .center)
////                NEUSFView(systemName: viewModel.liked ? "heart.fill" : "heart", size: .medium)
//            })
            Button(action: {
                action()
            }) {
                NEUSFView(systemName: player.isPlaying && song.id == playing.songDetail.id ? "pause.fill" : "play.fill",
                          size: .small,
                          active: song.id == playing.songDetail.id && player.isPlaying ?  true : false,
                          activeColor: song.id == playing.songDetail.id ? Color.orange : Color.mainTextColor,
                          inactiveColor: song.id == playing.songDetail.id ? Color.orange : Color.mainTextColor)
            }
            .buttonStyle((NEUBorderButtonToggleStyle(isHighlighted: song.id == playing.songDetail.id && player.isPlaying ?  true : false, shadow: true, shape: Circle())))
        }
        .padding(10)
        .background(
            NEUListRowBackgroundView(isHighlighted: song.id == playing.songDetail.id)
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
