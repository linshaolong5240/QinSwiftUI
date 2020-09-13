//
//  SongRowView.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/12.
//

import SwiftUI

struct SongRowView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    private var playing: AppState.Playing {
        store.appState.playing
    }
    
    let viewModel: SongViewModel
    let index: Int
    let action: () -> Void
    init(viewModel: SongViewModel, index: Int = 0, action: @escaping () -> Void = {}) {
        self.viewModel = viewModel
        self.index = index
        self.action = action
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.mainTextColor )
                    .lineLimit(1)
//                    HStack {
//                        Text(viewModel.artists)
//                            .fontWeight(.bold)
//                            .lineLimit(1)
//                        Spacer()
//                        Text(String(format: "%02d:%02d", Int(viewModel.durationTime/60),Int(viewModel.durationTime)%60))
//                    }
//                    .foregroundColor(Color.secondTextColor)
                Text(viewModel.artists)
                    .fontWeight(.bold)
                    .foregroundColor(Color.secondTextColor)
                    .lineLimit(1)
            }
            .foregroundColor(player.isPlaying && viewModel.id == playing.songDetail.id ? .white : Color.secondTextColor)
            Spacer()
            Button(action: {
                action()
            }) {
                NEUButtonView(systemName: player.isPlaying && viewModel.id == playing.songDetail.id ? "pause.fill" : "play.fill",
                              size: .small,
                              active: viewModel.id == playing.songDetail.id && player.isPlaying ?  true : false,
                              activeColor: .white,
                              inactiveColor: Color(colorScheme == .light ? #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) ))
            }
            .buttonStyle((NEUButtonToggleStyle(isHighlighted: viewModel.id == playing.songDetail.id && player.isPlaying ?  true : false, shadow: true, shape: Circle())))
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
