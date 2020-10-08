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
    private var artist: AppState.Artist {store.appState.artist}
    @State private var selection: Selection = .hotSong
    @State private var showDesc: Bool = false
    
    let id: Int
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                    Text("歌手详情")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.mainTextColor)
                    Spacer()
                    Button(action: {}, label: {
                        NEUSFView(systemName: "ellipsis")
                    })
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                .padding(.horizontal)
                .onAppear {
                    Store.shared.dispatch(.artists(id: id))
                }
                if artist.artistRequesting == true {
                    Text("正在加载")
                    Spacer()
                }else {
                    DescriptionView(viewModel: artist.artistViewModel)
                    Picker(selection: $selection, label: Text("Picker")) /*@START_MENU_TOKEN@*/{
                        Text("热门歌曲").tag(Selection.hotSong)
                        Text("专辑").tag(Selection.album)
                        Text("MV").tag(Selection.mv)
                    }/*@END_MENU_TOKEN@*/
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    switch selection {
                    case .album:
                        ArtistAlbumView(albums: artist.artistViewModel.albums)
                    case .hotSong:
                        SongListView(songs: artist.artistViewModel.hotSongs)
                    case .mv:
                        ArtistMVView(mvs: artist.artistViewModel.mvs)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct ArtistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailView(id: 0)
    }
}
#endif

struct ArtistAlbumView: View {
    let albums: [AlbumViewModel]
    
    private let columns: [GridItem] = [.init(.adaptive(minimum: 130))]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) /*@START_MENU_TOKEN@*/{
                ForEach(albums) { item in
                    NavigationLink(destination: AlbumDetailView(id: item.id)) {
                        AlbumView(viewModel: item)
                    }
                }
            }/*@END_MENU_TOKEN@*/
        }
    }
}

struct AlbumView: View {
    let viewModel: AlbumViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            NEUCoverView(url: viewModel.coverUrl, coverShape: .rectangle, size: .small)
                .padding()
            Group {
                Text(viewModel.name)
                    .foregroundColor(Color.mainTextColor)
                    .lineLimit(1)
                    .frame(width: 110, alignment: .leading)
//                Text("\(viewModel.count) songs")
//                    .foregroundColor(Color.secondTextColor)
            }
            .padding(.leading)
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
