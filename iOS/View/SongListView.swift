//
//  SongListView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/9.
//

import SwiftUI

struct SongListView: View {
    @EnvironmentObject private var store: Store
    @Environment(\.managedObjectContext) private var moc
    private var playing: AppState.Playing { store.appState.playing }

    @State private var showFavorite: Bool = false
    @State private var showPlayingNow: Bool = false
    @State private var showAlert: Bool = false
    
    let songsIds: [Int64]
    
    var body: some View {
        FetchedResultsView(entity: Song.entity(), predicate: NSPredicate(format: "%K in %@", "id", songsIds)) { (results: FetchedResults<Song>) in
            VStack {
                NavigationLink(destination: PlayingNowView(), isActive: $showPlayingNow) {
                    EmptyView()
                }
                HStack {
                    Text("\(String(results.count)) 首")
                        .fontWeight(.bold)
                        .foregroundColor(.secondTextColor)
                    Spacer()
                    Text(showFavorite ? "喜欢" : "全部")
                        .fontWeight(.bold)
                        .foregroundColor(.secondTextColor)
                    Toggle("", isOn: $showFavorite)
                        .fixedSize()
                }
                .padding(.horizontal)
                .onAppear {
                    if songsIds.count != results.count && songsIds.count > 0{
                        Store.shared.dispatch(.songsDetail(ids: songsIds))
                    }
                }
                if store.appState.playlist.songsRequesting {
                    Text("Loading")
                    Spacer()
                }else {
                    ScrollView {
                        ForEach(results, id:\.id) { item in
                            Button(action: {
                            }, label: {
                                songrowtest(song: item)
                            })
                        }
                    }
                }
                //            ScrollView {
                //                Spacer()
                //                    .frame(height: 10)
                //                LazyVStack {
                //                    let data = showFavorite ? songs.filter{$0.liked} : songs
                //                    let filterData = data.filter{$0.url != nil}
                //                    ForEach(0..<data.count, id: \.self) { index in
                //                        if !showFavorite || data[index].liked {
                //                            Button(action: {
                //                                if  playing.songDetail.id == data[index].id {
                //                                    showPlayingNow.toggle()
                //                                }else if data[index].url != nil {
                //                                    let i = filterData.firstIndex(of: data[index]) ?? 0
                //                                    Store.shared.dispatch(.setPlayinglist(playinglist: filterData, index: i))
                //                                    Store.shared.dispatch(.playByIndex(index: i))
                //                                }
                //                            }, label: {
                //                                SongRowView(viewModel: data[index],index: index + 1, action: {
                //                                    if  playing.songDetail.id == data[index].id {
                //                                        store.dispatch(.playOrPause)
                //                                    }else if data[index].url != nil {
                //                                        let i = filterData.firstIndex(of: data[index]) ?? 0
                //                                        Store.shared.dispatch(.setPlayinglist(playinglist: filterData, index: i))
                //                                        Store.shared.dispatch(.playByIndex(index: i))
                //                                    }
                //                                })
                //                            })
                //                            .padding(.horizontal)
                //                        }
                //                    }
                //                }
                //            }
            }
        }
    }
}

#if DEBUG
//struct SongListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            NEUBackgroundView()
//            SongListView(songs: [SongViewModel(id: 0, name: "tewst", artists: [SongViewModel.Artist(id: 0, name: "test")]),
//                                 SongViewModel(id: 0, name: "tewst", artists: [SongViewModel.Artist(id: 0, name: "test")])])
//                .preferredColorScheme(.dark)
//                .environmentObject(Store.shared)
//                .environmentObject(Player.shared)
//        }
//    }
//}
#endif

struct songrowtest: View {
    var song: Song
    
    var body: some View {
        HStack {
            VStack {
                Text(song.name ?? "None")
                Text(song.al?.name ?? "None")
                ForEach(Array(song.ar as! Set<Artist>), id:\.id) { item in
                    Text(item.name ?? "None")
                }
            }
        }
    }
}
