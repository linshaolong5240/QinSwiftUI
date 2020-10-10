//
//  DiscoverView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/10/10.
//

import SwiftUI

struct DiscoverView: View {
    enum DiscoverType: String, CaseIterable {
        case album = "专辑", artist = "歌手", playlist = "歌单"
    }
    @State private var discoverType: DiscoverType = .playlist
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                    Text("发现")
//                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.mainTextColor)
                    Spacer()
                    Button(action: {}, label: {
                        NEUSFView(systemName: "ellipsis")
                    })
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                .padding(.horizontal)
                .onAppear(perform: {
                    Store.shared.dispatch(.playlistCatlist)
                })
                Picker(selection: $discoverType, label: Text("")) /*@START_MENU_TOKEN@*/{
                    ForEach(DiscoverType.allCases, id: \.self) { item in
                        Text("\(item.rawValue)").tag(item)
                    }
                }/*@END_MENU_TOKEN@*/
                .pickerStyle(SegmentedPickerStyle())
                ScrollView {
                    Text("data")
                }
//                .onAppear {
//                    Store.shared.dispatch(.artists(id: id))
//                }
//                if artist.artistRequesting == true {
//                    Text("正在加载")
//                    Spacer()
//                }else {
//                    DescriptionView(viewModel: artist.viewModel)
//                    Picker(selection: $selection, label: Text("Picker")) /*@START_MENU_TOKEN@*/{
//                        Text("热门歌曲").tag(Selection.hotSong)
//                        Text("专辑").tag(Selection.album)
//                        Text("MV").tag(Selection.mv)
//                    }/*@END_MENU_TOKEN@*/
//                    .pickerStyle(SegmentedPickerStyle())
//                    .padding(.horizontal)
//                    switch selection {
//                    case .album:
//                        ArtistAlbumView(albums: artist.viewModel.albums)
//                    case .hotSong:
//                        SongListView(songs: artist.viewModel.hotSongs)
//                    case .mv:
//                        ArtistMVView(mvs: artist.viewModel.mvs)
//                    }
//                }
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
#endif
