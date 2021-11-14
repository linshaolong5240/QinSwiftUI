//
//  ArtistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/1.
//

import SwiftUI
import NeumorphismSwiftUI

struct FetchedArtistDetailView: View {
    @State private var show: Bool = false
    
    let id: Int
    
    var body: some View {
        ZStack {
            QinBackgroundView()
            VStack {
                CommonNavigationBarView(id: id, title: "歌手详情", type: .artist)
                    .padding(.horizontal)
                    .onAppear {
                        DispatchQueue.main.async {
                            show = true
                        }
                    }
                if show {
                    FetchedResultsView(entity: Artist.entity(), predicate: NSPredicate(format: "%K == \(id)", "id")) { (results: FetchedResults<Artist>) in
                        if let artist = results.first {
                            ArtistDetailView(artist: artist)
                                .onAppear {
                                    if results.first?.introduction == nil {
                                        Store.shared.dispatch(.artistDetailRequest(id: id))
                                    }
                                }
                        }else {
                            Text("Loading...")
                                .onAppear {
                                    Store.shared.dispatch(.artistDetailRequest(id: id))
                                }
                            Spacer()
                        }
                    }
                }else {
                    Text("Loading...")
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
//        ZStack {
//            NEUBackgroundView()
//            FetchedArtistDetailView(id: 12787752)
//                .environmentObject(Store.shared)
//        }
        ZStack {
            QinBackgroundView()
            ArtistDetailView(artist: Artist(context: DataManager.shared.context()))
                .environmentObject(Store.shared)
        }
    }
}
#endif

struct ArtistDetailView: View {
    enum Selection {
        case album, hotSong, mv
    }
    @EnvironmentObject private var store: Store
    @State private var selection: Selection = .hotSong
    @ObservedObject var artist: Artist
    
    var body: some View {
        VStack(spacing: 10) {
            DescriptionView(viewModel: artist)
            HStack {
                Text("id:\(String(artist.id))")
                    .foregroundColor(.secondTextColor)
                Spacer()
                Button(action: {
                    let id = artist.id
                    let sub = !Store.shared.appState.artist.subedIds.contains(Int(id))
                    Store.shared.dispatch(.artistSubRequest(id: Int(id), sub: sub))
                }) {
                    QinSFView(systemName: store.appState.artist.subedIds.contains(Int(artist.id)) ? "heart.fill" : "heart",
                              size: .small)
                }
                .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
            }
            .padding(.horizontal)
            Picker(selection: $selection, label: Text("Picker")) /*@START_MENU_TOKEN@*/{
                Text("热门歌曲50").tag(Selection.hotSong)
                Text("专辑").tag(Selection.album)
                Text("MV").tag(Selection.mv)
            }/*@END_MENU_TOKEN@*/
            .pickerStyle(SegmentedPickerStyle())
            .padding([.horizontal])
//            SongListView(songs: [Song]())
            switch selection {
            case .album:
                if let albums = artist.albums?.allObjects as? [Album] {
                    VGridView(albums.sorted(by: { (left, right) -> Bool in
                        return left.publishTime > right.publishTime ? true : false
                    }), gridColumns: 3) { item in
                        NavigationLink(destination: FetchedAlbumDetailView(id: Int(item.id))) {
                            CommonGridItemView(item)
                        }
                    }
                }else {
                    Spacer()
                }
            case .hotSong:
                if let songsId = artist.hotSongsId {
                    if let songs = artist.hotSongs {
                        SongListView(songs: Array(songs as! Set<Song>).sorted(by: { (left, right) -> Bool in
                            let lIndex = songsId.firstIndex(of: left.id)
                            let rIndex = songsId.firstIndex(of: right.id)
                            return lIndex ?? 0 > rIndex ?? 0 ? false : true
                        }))
                    }
                }else {
                    Spacer()
                }
            case .mv:
                if let mvs = artist.mvs?.allObjects as? [MV] {
                    VGridView(mvs.sorted(by: { (left, right) -> Bool in
                        return left.publishTime ?? "" > right.publishTime ?? "" ? true : false
                    }), gridColumns: 3) { item in
                        Button(action: {
                            Store.shared.dispatch(.mvDetailRequest(id: Int(item.id)))
                        }) {
                            NavigationLink(destination: FetchedMVDetailView(id: Int(item.id))) {
                                CommonGridItemView(item)
                            }
                        }

                    }
                }else {
                    Spacer()
                }
            }
        }
        .onChange(of: selection, perform: { value in
            switch value {
            case .album:
                if artist.albums?.count == 0 {
                    Store.shared.dispatch(.artistAlbumsRequest(id: Int(artist.id)))
                }
            case .mv:
                if artist.mvs?.count == 0 {
                    Store.shared.dispatch(.artistMVsRequest(id: Int(artist.id)))
                }
            case .hotSong: break
            }
        })
    }
}
