//
//  CommonGridItemView.swift
//  Qin (iOS)
//
//  Created by teenloong on 2020/10/30.
//

import SwiftUI
import Combine
import NeteaseCloudMusicAPI

struct CommonGridItemView: View {
    @ObservedObject var configuration: CommonGridItemConfiguration
    
    init(_ configuration: CommonGridItemConfiguration) {
        self.configuration = configuration
    }
    init(_ item: Album) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    init(_ model: NCMAlbumSublistResponse.Album) {
        self.configuration = CommonGridItemConfiguration(model)
    }
    init(_ item: NCMArtistSublistResponse.Artist) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    init(_ item: NCMPlaylistResponse) {
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
    init(_ item: NCMRecommendPlaylistResponse.RecommendPlaylist) {
        self.configuration = CommonGridItemConfiguration(item)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            QinCoverView(configuration.picUrl, style: QinCoverStyle(size: .small, shape: .rectangle))
                .padding()
            Group {
                Text(configuration.name ?? "")
                    .foregroundColor(Color.mainText)
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

class CommonGridItemConfiguration: ObservableObject {
    var id: Int
    var name: String?
    var picUrl: String?
    var subscribed: Bool?
    init(id: Int, name: String, picUrl: String?, subscribed: Bool) {
        self.id = id
        self.name = name
        self.picUrl = picUrl
        self.subscribed = subscribed
    }
    init(_ item: Album) {
        self.id = Int(item.id)
        self.name = item.name
        self.picUrl = item.picUrl
        self.subscribed = nil
    }
    init(_ model: NCMAlbumSublistResponse.Album) {
        self.id = model.id
        self.name = model.name
        self.picUrl = model.picUrl
        self.subscribed = true
    }
    init(_ model: NCMArtistSublistResponse.Artist) {
        self.id = model.id
        self.name = model.name
        self.picUrl = model.img1v1Url
        self.subscribed = nil
    }
    init(_ item: NCMPlaylistResponse) {
        self.id = item.id
        self.name = item.name
        self.picUrl = item.coverImgUrl
        self.subscribed = item.subscribed
    }
    init(_ item: MV) {
        self.id = Int(item.id)
        self.name = item.name
        self.picUrl = item.imgurl
        self.subscribed = item.subed
    }
    init(_ item: Playlist) {
        self.id = Int(item.id)
        self.name = item.name
        self.picUrl = item.coverImgUrl
        self.subscribed = item.subscribed
    }
    init(_ item: PlaylistViewModel) {
        self.id = Int(item.id)
        self.name = item.name
        self.picUrl = item.coverImgUrl
        self.subscribed = item.subscribed
    }
    init(_ item: NCMRecommendPlaylistResponse.RecommendPlaylist) {
        self.id = item.id
        self.name = item.name
        self.picUrl = item.picUrl
        self.subscribed = nil
    }
}
