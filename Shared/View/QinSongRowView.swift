//
//  QinSongRowView.swift
//  Qin
//
//  Created by 林少龙 on 2021/12/21.
//

import SwiftUI
import NeumorphismSwiftUI
import Combine

class QinSongRowViewModel: ObservableObject {
    var artists: [String] = []
    var id: Int = 0
    @Published var like: Bool = false
    var name: String = ""
    @Published var playing: Bool = false
    
    init(id: Int, name: String, artists: [String]) {
        self.id = id
        self.name = name
        self.artists = artists
    }
    
    init(_ song: NCMSearchSongResponse.Result.Song) {
        name = song.name
        artists = song.artists.map(\.name)
        config()
    }
    
    private func config() {
        let songId = id
        Store.shared.appState.playlist.$songlikedIds.map { $0.contains(songId) }.assign(to: &$like)
        Publishers.CombineLatest(Player.shared.$isPlaying, Store.shared.appState.playing.$index).map { playing, index in
            playing && Store.shared.appState.playing.song?.id ?? 0 == songId
        }.assign(to: &$playing)
    }
    
    func toogleLike() {
        like = !like
    }
    
    func togglePlay() {
        playing = !playing
    }
}

struct QinSongRowView: View {
    @ObservedObject var viewModel: QinSongRowViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainText)
                    .lineLimit(1)
                HStack {
                    ForEach(viewModel.artists, id: \.self) { item in
                        Text(item)
                            .lineLimit(1)
                            .foregroundColor(Color.secondTextColor)
                    }
                }
            }
            Spacer()
            Button(action: {
                viewModel.toogleLike()
            }, label: {
                Image(systemName: viewModel.like ? "heart.fill" : "heart")
                    .foregroundColor(Color.mainText)
                    .padding(.horizontal)
            })
            Button(action: {
                viewModel.togglePlay()
            }) {
                QinSFView(systemName: viewModel.playing ? "pause.fill" : "play.fill",
                          size: .small,
                          active: viewModel.playing,
                          activeColor: viewModel.playing ? Color.orange : Color.mainText,
                          inactiveColor: viewModel.playing ? Color.orange : Color.mainText)
            }
            .buttonStyle(NEUConvexBorderButtonStyle(shape: Circle(), toggle: viewModel.playing ?  true : false))
        }
        .padding(10)
        .background(
            NEUListRowBackgroundView(isHighlighted: true)
        )
    }
}

#if DEBUG
struct QinSongRowView_Previews: PreviewProvider {
    static var previews: some View {
        QinSongRowView(viewModel: .init(id: 0, name: "name", artists: ["artist", "artist"]))
            .padding(.horizontal)
    }
}
#endif
