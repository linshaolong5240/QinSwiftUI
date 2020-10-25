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
    @State private var showFavorite: Bool = false
    @State private var showPlayingNow: Bool = false
    @State private var showAlert: Bool = false
    
    let songs: [SongViewModel]

    
    var body: some View {
        VStack {
            NavigationLink(destination: PlayingNowView(), isActive: $showPlayingNow) {
                EmptyView()
            }
            HStack {
                Text("\(String(showFavorite ? songs.filter{$0.liked}.count : songs.count)) songs")
                    .fontWeight(.bold)
                    .foregroundColor(.secondTextColor)
                Spacer()
                Text("显示喜欢")
                    .fontWeight(.bold)
                    .foregroundColor(.secondTextColor)
                Toggle("", isOn: $showFavorite)
                    .fixedSize()
            }
            .padding(.horizontal)
            ScrollView {
                Spacer()
                    .frame(height: 10)
                LazyVStack {
                    let data = showFavorite ? songs.filter{$0.liked} : songs
                    let filterData = data.filter{$0.url != nil}
                    ForEach(0..<data.count, id: \.self) { index in
                        if !showFavorite || data[index].liked {
                            Button(action: {
                                if  playing.songDetail.id == data[index].id {
                                    showPlayingNow.toggle()
                                }else if data[index].url != nil {
                                    let i = filterData.firstIndex(of: data[index]) ?? 0
                                    Store.shared.dispatch(.setPlayinglist(playinglist: filterData, index: i))
                                    Store.shared.dispatch(.playByIndex(index: i))
                                }
                            }, label: {
                                SongRowView(viewModel: data[index],index: index + 1, action: {
                                    if  playing.songDetail.id == data[index].id {
                                        store.dispatch(.playOrPause)
                                    }else if data[index].url != nil {
                                        let i = filterData.firstIndex(of: data[index]) ?? 0
                                        Store.shared.dispatch(.setPlayinglist(playinglist: filterData, index: i))
                                        Store.shared.dispatch(.playByIndex(index: i))
                                    }
                                })
                            })
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            SongListView(songs: [SongViewModel(id: 0, name: "tewst", artists: [SongViewModel.Artist(id: 0, name: "test")]),
                                 SongViewModel(id: 0, name: "tewst", artists: [SongViewModel.Artist(id: 0, name: "test")])])
                .preferredColorScheme(.dark)
                .environmentObject(Store.shared)
                .environmentObject(Player.shared)
        }
    }
}
#endif
