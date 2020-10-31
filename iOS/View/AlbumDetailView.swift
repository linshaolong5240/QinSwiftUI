//
//  AlbumDetailView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/8.
//

import SwiftUI

struct AlbumDetailView: View {
    @EnvironmentObject var store: Store

    let id: Int64
    
    var body: some View {
        FetchedResultsView(entity: Album.entity(), predicate: NSPredicate(format: "%K == \(id)", "id")) { (results: FetchedResults<Album>) in
            ZStack {
                NEUBackgroundView()
                VStack {
                    HStack {
                        NEUBackwardButton()
                        Spacer()
                        NEUNavigationBarTitleView("专辑详情")
                        Spacer()
                        //                    Button(action: {
                        ////                        viewModel.isSub.toggle()
                        ////                        Store.shared.dispatch(.albumSub(id: viewModel.id, sub: viewModel.isSub))
                        //                    }, label: {
                        //                        NEUSFView(systemName: "heart.fill")
                        //                    })
                        //                    .buttonStyle(NEUButtonToggleStyle(isHighlighted: viewModel.isSub, shape: Circle()))
                    }
                    .padding(.horizontal)
                    .onAppear {
                        if results.first?.songs == nil {
                            Store.shared.dispatch(.album(id: id))
                        }
                    }
                    if !store.appState.album.albumRequesting {
                        if let album = results.first {
                            DescriptionView(viewModel: album)
                            if let songsId = album.songsId {
                                SongListView(songsId: songsId)
                            }else {
                                Spacer()
                            }
                        }
                    }else {
                        Text("正在加载")
                        Spacer()
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}

#if DEBUG
struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailView(id: 0)
    }
}
#endif
