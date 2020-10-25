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
    
    let viewModel: SongViewModel
    let index: Int
    let action: () -> Void
    init(viewModel: SongViewModel, index: Int, action: @escaping () -> Void = {}) {
        self.viewModel = viewModel
        self.index = index
        self.action = action
    }
    var body: some View {
        HStack {
            Text("\(String(index))")
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: 20 , height: 20)
                .foregroundColor(Color.mainTextColor)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                    .lineLimit(1)
                HStack {
                    ForEach(viewModel.artists) { item in
                        Text(item.name)
                            .foregroundColor(Color.secondTextColor)
                            .lineLimit(1)
                    }
                }
            }
            Spacer()
            if viewModel.url == nil {
//                NEUSFView(systemName: "icloud.slash", size: .medium)
                Image(systemName: "icloud.slash")
                    .foregroundColor(Color.mainTextColor)
                    .frame(width: 30, height: 30, alignment: .center)
            }
            Button(action: {
                Store.shared.dispatch(.like(song: viewModel))
            }, label: {
                Image(systemName: viewModel.liked ? "heart.fill" : "heart")
                    .foregroundColor(Color.mainTextColor)
                    .frame(width: 30, height: 30, alignment: .center)
//                NEUSFView(systemName: viewModel.liked ? "heart.fill" : "heart", size: .medium)
            })
            Button(action: {
                action()
            }) {
                NEUSFView(systemName: player.isPlaying && viewModel.id == playing.songDetail.id ? "pause.fill" : "play.fill",
                          size: .small,
                          active: viewModel.id == playing.songDetail.id && player.isPlaying ?  true : false,
                          activeColor: viewModel.id == playing.songDetail.id ? Color.orange : Color.mainTextColor,
                          inactiveColor: viewModel.id == playing.songDetail.id ? Color.orange : Color.mainTextColor)
            }
            .buttonStyle((NEUBorderButtonToggleStyle(isHighlighted: viewModel.id == playing.songDetail.id && player.isPlaying ?  true : false, shadow: true, shape: Circle())))
        }
        .padding(10)
        .background(
            NEUListRowBackgroundView(isHighlighted: viewModel.id == playing.songDetail.id)
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
