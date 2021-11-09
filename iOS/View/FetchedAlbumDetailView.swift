//
//  FetchedAlbumDetailView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/8.
//

import SwiftUI

struct  FetchedAlbumDetailView: View {
    @State private var show: Bool = false

    let id: Int
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                CommonNavigationBarView(id: id, title: "专辑详情", type: .album)
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
                                .onAppear {
                                    if album.songsId == nil {
                                        Store.shared.dispatch(.albumDetailRequest(id: Int(id)))
                                    }
                                }
                        }else {
                            Text("正在加载")
                                .onAppear {
                                    Store.shared.dispatch(.albumDetailRequest(id: Int(id)))
                                }
                            Spacer()
                        }
                    }
                }else {
                    Text("正在加载")
                    Spacer()
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
    @EnvironmentObject private var store: Store
    @ObservedObject var album: Album
    
    var body: some View {
        VStack(spacing: 10) {
            DescriptionView(viewModel: album)
            HStack {
                Text("id:\(String(album.id))")
                    .foregroundColor(.secondTextColor)
                Spacer()
                Button(action: {
                    let id = album.id
                    let sub = !Store.shared.appState.album.subedIds.contains(Int(id))
                    Store.shared.dispatch(.albumSubRequest(id: Int(id), sub: sub))
                }) {
                    QinSFView(systemName: store.appState.album.subedIds.contains(Int(album.id)) ? "heart.fill" : "heart",
                              size: .small)
                }
                .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
            }
            .padding(.horizontal)
            if let songs = album.songs {
                if let songsId = album.songsId {
                    SongListView(songs: Array(songs as! Set<Song>).sorted(by: { (left, right) -> Bool in
                        let lIndex = songsId.firstIndex(of: left.id)
                        let rIndex = songsId.firstIndex(of: right.id)
                        return lIndex ?? 0 > rIndex ?? 0 ? false : true
                    }))
                }else {
                    Spacer()
                }
            }else {
                Spacer()
            }
        }
    }
}
