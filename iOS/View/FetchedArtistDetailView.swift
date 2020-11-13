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
                CommonNavigationBarView(id: id, title: "歌手详情", type: .artist)
                    .padding(.horizontal)
                    .onAppear {
                        DispatchQueue.main.async {
                            show = true
                        }
                    }
                if show && !store.appState.artist.detailRequesting {
                    FetchedResultsView(entity: Artist.entity(), predicate: NSPredicate(format: "%K == \(id)", "id")) { (results: FetchedResults<Artist>) in
                        if results.first?.songsId != nil {
                            ArtistDetailView(artist: results.first!)
                        }else {
                            Text("正在加载")
                                .onAppear {
                                    print("artist: \(id)")
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
                if let albums = artist.albums?.allObjects as? [Album] {
                    VGridView(albums.sorted(by: { (left, right) -> Bool in
                        return left.publishTime > right.publishTime ? true : false
                    }), gridColumns: 3) { item in
                        CommonGridItemView(item)
                    }
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
                if let mvs = artist.mvs?.allObjects as? [MV] {
                    VGridView(mvs.sorted(by: { (left, right) -> Bool in
                        return left.publishTime ?? "" > right.publishTime ?? "" ? true : false
                    }), gridColumns: 3) { item in
                        CommonGridItemView(item)
                    }
                }
            }
        }
    }
}
