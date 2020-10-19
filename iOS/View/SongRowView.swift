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
    let action: () -> Void
    init(viewModel: SongViewModel, action: @escaping () -> Void = {}) {
        self.viewModel = viewModel
        self.action = action
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.system(size: 20))
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
struct SongsListRowView_Previews: PreviewProvider {
    static var previews: some View {
        SongRowView(viewModel: SongViewModel())
    }
}
#endif
