//
//  CommonGridItemView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/10/30.
//

import SwiftUI

struct CommonGridItemView: View {
    private let configuration: CommonGridItemConfiguration
    
    init(_ configuration: CommonGridItemConfiguration) {
        self.configuration = configuration
    }
    init(_ item: Album) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    init(_ item: AlbumSub) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    init(_ item: ArtistSub) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    init(_ item: PlaylistResponse) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    init(_ item: MV) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    init(_ item: Playlist) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    init(_ item: PlaylistViewModel) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    init(_ item: RecommendPlaylist) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    init(_ item: UserPlaylist) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    var body: some View {
        VStack(alignment: .leading) {
            NEUCoverView(url: configuration.picUrl, coverShape: .rectangle, size: .small)
                .padding()
            Group {
                Text(configuration.name ?? "")
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


//#if DEBUG
//struct CommonGridItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommonGridItemView()
//    }
//}
//#endif

struct CommonGridItemConfiguration {
    var id: Int64
    var name: String?
    var picUrl: String?
    var subscribed: Bool?
    init(id: Int64, name: String, picUrl: String?, subscribed: Bool) {
        self.id = id
        self.name = name
        self.picUrl = picUrl
        self.subscribed = subscribed
    }
    init(_ item: Album) {
        self.id = item.id
        self.name = item.name
        self.picUrl = item.picUrl
        self.subscribed = nil
    }
    init(_ item: AlbumSub) {
        self.id = item.id
        self.name = item.name
        self.picUrl = item.picUrl
        self.subscribed = nil
    }
    init(_ item: ArtistSub) {
        self.id = item.id
        self.name = item.name
        self.picUrl = item.img1v1Url
        self.subscribed = nil
    }
    init(_ item: PlaylistResponse) {
        self.id = Int64(item.id)
        self.name = item.name
        self.picUrl = item.coverImgUrl
        self.subscribed = item.subscribed
    }
    init(_ item: MV) {
        self.id = item.id
        self.name = item.name
        self.picUrl = item.imgurl
        self.subscribed = item.subed
    }
    init(_ item: Playlist) {
        self.id = item.id
        self.name = item.name
        self.picUrl = item.coverImgUrl
        self.subscribed = item.subscribed
    }
    init(_ item: PlaylistViewModel) {
        self.id = item.id
        self.name = item.name
        self.picUrl = item.coverImgUrl
        self.subscribed = item.subscribed
    }
    init(_ item: RecommendPlaylist) {
        self.id = item.id
        self.name = item.name
        self.picUrl = item.picUrl
        self.subscribed = nil
    }
    init(_ item: UserPlaylist) {
        self.id = item.id
        self.name = item.name
        self.picUrl = item.coverImgUrl
        self.subscribed = nil
    }
}
