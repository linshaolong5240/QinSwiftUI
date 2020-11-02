//
//  ArtistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/1.
//

import SwiftUI

struct FetchedArtistDetailView: View {
    enum Selection {
        case album, hotSong, mv
    }
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
                if show {
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
    let artist: Artist
    
    var body: some View {
        VStack {
            DescriptionView(viewModel: artist)
            if let songs = artist.songs {
                if let songsId = artist.songsId {
                    SongListView(songs: Array(songs as! Set<Song>).sorted(by: { (left, right) -> Bool in
                        let lIndex = songsId.firstIndex(of: left.id)
                        let rIndex = songsId.firstIndex(of: right.id)
                        return lIndex ?? 0 > rIndex ?? 0 ? false : true
                    }))
                }
            }else {
                Spacer()
            }
        }
    }
}

struct ArtistAlbumView: View {
    let albums: [AlbumViewModel]
    
    private let columns: [GridItem] = [.init(.adaptive(minimum: 130))]
    var body: some View {
        ScrollView {
//            LazyVGrid(columns: columns) /*@START_MENU_TOKEN@*/{
//                ForEach(albums) { item in
//                    NavigationLink(destination: AlbumDetailView(item)) {
//                        AlbumView(viewModel: item)
//                    }
//                }
//            }/*@END_MENU_TOKEN@*/
        }
    }
}

struct ArtistMVView: View {
    let mvs: [MV]
    
    private let columns: [GridItem] = [.init(.adaptive(minimum: 130))]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) /*@START_MENU_TOKEN@*/{
                ForEach(mvs) { item in
                    MVView(viewModel: item)
                }
            }/*@END_MENU_TOKEN@*/
        }
    }
}

struct MVView: View {
    let viewModel: MV
    
    var body: some View {
        VStack(alignment: .leading) {
            NEUCoverView(url: viewModel.imgurl, coverShape: .rectangle, size: .small)
                .padding()
            Group {
                Text(viewModel.name)
                    .foregroundColor(Color.mainTextColor)
                    .lineLimit(1)
                    .frame(width: 110, alignment: .leading)
                Text("\(viewModel.publishTime)")
                    .foregroundColor(Color.secondTextColor)
            }
            .padding(.leading)
        }
    }
}
