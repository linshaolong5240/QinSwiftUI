//
//  FetchedAlbumDetailView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/8.
//

import SwiftUI

struct  FetchedAlbumDetailView: View {
    @State private var show: Bool = false

    let id: Int64
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                CommonNavigationBarView(title: "专辑详情")
                    .padding(.horizontal)
                    .onAppear {
                        DispatchQueue.main.async {
                            show = true
                        }
                    }
                if show {
                    FetchedResultsView(entity: Album.entity(), predicate: NSPredicate(format: "%K == \(id)", "id")) { (results: FetchedResults<Album>) in
                        if let album = results.first {
                            AlbumDetailView(album: album)
                        }else {
                            Text("正在加载")
                                .onAppear {
                                    Store.shared.dispatch(.album(id: id))
                                }
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FetchedAlbumDetailView(id: 0)
    }
}
#endif

struct AlbumDetailView: View {
    let album: Album
    
    var body: some View {
        DescriptionView(viewModel: album)
        if let songs = album.songs {
            if let songsId = album.songsId {
                SongListView(songs: Array(songs as! Set<Song>).sorted(by: { (left: Song, right) -> Bool in
                    let lIndex = songsId.firstIndex(of: left.id)!
                    let rIndex = songsId.firstIndex(of: right.id)!
                    return lIndex > rIndex ? false : true
                }))
            }
        }
    }
}
