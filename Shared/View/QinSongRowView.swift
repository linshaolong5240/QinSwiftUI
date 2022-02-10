//
//  QinSongRowView.swift
//  Qin
//
//  Created by teenloong on 2021/12/21.
//

import SwiftUI
import NeumorphismSwiftUI
import Combine

class QinSongRowViewModel: ObservableObject {
    var song: QinSong

    @Published var like: Bool = false
    @Published var playing: Bool = false
    @Published var isPlaying: Bool = false

    init<Song>(_ song: Song) where Song: QinSongable {
        self.song = song.asQinSong()
        config()
    }
    
    private func config() {
        let songId = song.id
        Store.shared.appState.playlist.$songlikedIds.map { $0.contains(songId) }.assign(to: &$like)
        Store.shared.appState.playing.$song.map { $0?.id == songId }.assign(to: &$playing)
        Publishers.CombineLatest(Player.shared.$isPlaying, Store.shared.appState.playing.$song).map { playing, song in
            playing && song?.id == songId
        }.assign(to: &$isPlaying)
    }
    
    func toogleLike() {
        like = !like
    }
    
    func togglePlay() {
        Store.shared.dispatch(.playerTogglePlay(song: song))
    }
}

struct QinSongRowView: View {
    @ObservedObject var viewModel: QinSongRowViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.song.name ?? "Unknown")
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainText)
                    .lineLimit(1)
                HStack {
                    ForEach(viewModel.song.artists.compactMap(\.name), id: \.self) { item in
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
                QinSFView(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill",
                          size: .small,
                          active: viewModel.isPlaying,
                          activeColor: viewModel.isPlaying ? Color.orange : Color.mainText,
                          inactiveColor: viewModel.isPlaying ? Color.orange : Color.mainText)
            }
            .buttonStyle(NEUConvexBorderButtonStyle(shape: Circle(), toggle: viewModel.isPlaying ?  true : false))
        }
        .padding(10)
        .background(
            NEUListRowBackgroundView(isHighlighted: viewModel.playing)
        )
    }
}

#if DEBUG
struct QinSongRowView_Previews: PreviewProvider {
    static var previews: some View {
        QinSongRowView(viewModel: .init(QinSong(artists: [.init(id: 0, name: "artist")], id: 0, name: "name")))
            .padding(.horizontal)
    }
}
#endif
