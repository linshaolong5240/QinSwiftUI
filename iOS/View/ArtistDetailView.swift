//
//  ArtistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/1.
//

import SwiftUI

struct ArtistDetailView: View {
    enum Selection {
        case album, hotSong, mv
    }
    @EnvironmentObject var store: Store
    private var viewModel: ArtistViewModel {store.appState.artist.detail}
    @State private var selection: Selection = .hotSong
    @State private var showDesc: Bool = false
    
    private let id: Int64
    
    init(id: Int64) {
        self.id = id
    }
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                    NEUNavigationBarTitleView("歌手详情")
                    Spacer()
//                    Button(action: {
//                        viewModel.followed.toggle()
//                        Store.shared.dispatch(.artistSub(id: viewModel.id, sub: viewModel.followed))
//                    }, label: {
//                        NEUSFView(systemName: "heart.fill",
//                                  active: viewModel.followed)
//                    })
//                    .buttonStyle(NEUButtonToggleStyle(isHighlighted: viewModel.followed, shape: Circle()))
                }
                .padding(.horizontal)
                .onAppear {
                    Store.shared.dispatch(.artist(id: id))
                }
                if store.appState.artist.artistRequesting == true {
                    Text("正在加载")
                    Spacer()
                }else {
//                    DescriptionView(viewModel: viewModel)
                    Picker(selection: $selection, label: Text("Picker")) /*@START_MENU_TOKEN@*/{
                        Text("热门歌曲").tag(Selection.hotSong)
                        Text("专辑").tag(Selection.album)
                        Text("MV").tag(Selection.mv)
                    }/*@END_MENU_TOKEN@*/
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
//                    SongListView(songs: [SongViewModel]())

//                    switch selection {
//                    case .album:
//                        ArtistAlbumView(albums: viewModel.albums)
//                    case .hotSong:
//                        SongListView(songs: viewModel.hotSongs)
//                    case .mv:
//                        ArtistMVView(mvs: viewModel.mvs)
//                    }
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
            ArtistDetailView(id: 0)
                .environmentObject(Store.shared)
        }
    }
}
#endif

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
