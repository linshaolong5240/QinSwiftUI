//
//  AlbumDetailView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/8.
//

import SwiftUI

struct AlbumDetailView: View {
    @EnvironmentObject var store: Store
    private var album: AppState.Album {store.appState.album}

    let id: Int
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                    Text("专辑详情")
//                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.mainTextColor)
                    Spacer()
                    Button(action: {}) {
                        NEUSFView(systemName: "ellipsis", size: .medium)
                    }
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                .padding(.horizontal)
                .onAppear(perform: {
                    Store.shared.dispatch(.album(id: id))
                })
                if album.albumRequesting {
                    Text("正在加载")
                    Spacer()
                }else {
                    DescriptionView(viewModel: album.albumViewModel)
                    SongListView(songs: album.albumViewModel.songs)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailView(id: 0)
    }
}
#endif
