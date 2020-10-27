//
//  AlbumDetailView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/8.
//

import SwiftUI

struct AlbumDetailView: View {
    @EnvironmentObject var store: Store
    private var viewModel: AlbumViewModel {store.appState.album.albumViewModel}

    let album: Album
    
    init(_ album: Album) {
        self.album = album
    }
    
    var body: some View {
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
                .onAppear(perform: {
                    Store.shared.dispatch(.album(id: Int(album.id)))
                })
                if store.appState.album.albumRequesting {
                    DescriptionView(viewModel: album)
                    Text("正在加载")
                    Spacer()
                }else {
                    DescriptionView(viewModel: album)
                    SongListView(songs: [SongViewModel]())
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailView(Album())
    }
}
#endif
