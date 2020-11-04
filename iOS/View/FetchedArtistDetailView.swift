//
//  ArtistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/1.
//

import SwiftUI

struct FetchedArtistDetailView: View {
    @EnvironmentObject private var store: Store
    @State private var show: Bool = false
    
    let id: Int64
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                CommonNavigationBarView(id: id, title: "歌单详情", type: .artist)
                    .padding(.horizontal)
                    .onAppear {
                        DispatchQueue.main.async {
                            show = true
                        }
                    }
                if show && !store.appState.artist.detailRequesting {
                    FetchedResultsView(entity: Artist.entity(), predicate: NSPredicate(format: "%K == \(id)", "id")) { (results: FetchedResults<Artist>) in
                        if let artist = results.first {
                            ArtistDetailView(artist: artist)
                        }else {
                            Text("正在加载")
                                .onAppear {
                                    Store.shared.dispatch(.artist(id: id))
                                }
                            Spacer()
                        }
                    }
                }else {
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
        ZStack {
            NEUBackgroundView()
            FetchedArtistDetailView(id: 0)
                .environmentObject(Store.shared)
        }
    }
}
#endif

struct ArtistDetailView: View {
    enum Selection {
        case album, hotSong, mv
    }
    @State private var selection: Selection = .hotSong
    let artist: Artist
    
    var body: some View {
        VStack {
            DescriptionView(viewModel: artist)
            Picker(selection: $selection, label: Text("Picker")) /*@START_MENU_TOKEN@*/{
                Text("热门歌曲50").tag(Selection.hotSong)
                Text("专辑").tag(Selection.album)
                Text("MV").tag(Selection.mv)
            }/*@END_MENU_TOKEN@*/
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            switch selection {
            case .album:
                if let albums = artist.albums {
                    ArtistAlbumView(albums: Array(albums as! Set<Album>))
                }
            case .hotSong:
                if let songs = artist.songs {
                    if let songsId = artist.songsId {
                        SongListView(songs: Array(songs as! Set<Song>).sorted(by: { (left, right) -> Bool in
                            let lIndex = songsId.firstIndex(of: left.id)
                            let rIndex = songsId.firstIndex(of: right.id)
                            return lIndex ?? 0 > rIndex ?? 0 ? false : true
                        }))
                    }
                }
            case .mv:
                if let mvs = artist.mvs {
                    VGridView(mvs.allObjects as! [MV], gridColumns: 3) { item in
                        CommonGridItemView(item)
                    }
                }
            }
            //                if store.appState.artist.artistRequesting == true {
            //                    Text("正在加载")
            //                    Spacer()
            //                }else {
            ////                    DescriptionView(viewModel: viewModel)
            //                    Picker(selection: $selection, label: Text("Picker")) /*@START_MENU_TOKEN@*/{
            //                        Text("热门歌曲").tag(Selection.hotSong)
            //                        Text("专辑").tag(Selection.album)
            //                        Text("MV").tag(Selection.mv)
            //                    }/*@END_MENU_TOKEN@*/
            //                    .pickerStyle(SegmentedPickerStyle())
            //                    .padding()
            //                    SongListView(songs: [SongViewModel]())
            
            //                    switch selection {
            //                    case .album:
            //                        ArtistAlbumView(albums: viewModel.albums)
            //                    case .hotSong:
            //                        SongListView(songs: viewModel.hotSongs)
            //                    case .mv:
            //                        ArtistMVView(mvs: viewModel.mvs)
            //                    }
            //                }
        }
    }
}

struct ArtistAlbumView: View {
    let albums: [Album]
    
    private let columns: [GridItem] = Array<GridItem>(repeating: .init(.flexible()), count: 3)
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) /*@START_MENU_TOKEN@*/{
                ForEach(albums) { item in
                    NavigationLink(destination: FetchedAlbumDetailView(id: item.id)) {
                        CommonGridItemView(item)
                    }
                }
            }/*@END_MENU_TOKEN@*/
        }
    }
}

struct ArtistMVView: View {
    let mvs: [MV]
    
    private let columns: [GridItem] = Array<GridItem>(repeating: .init(.flexible()), count: 3)
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) /*@START_MENU_TOKEN@*/{
                ForEach(mvs) { item in
                    CommonGridItemView(item)
                }
            }/*@END_MENU_TOKEN@*/
        }
    }
}
