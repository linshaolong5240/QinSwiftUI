//
//  RecommendPlaylistView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/27.
//

import SwiftUI

struct RecommendPlaylistView: View {
    @FetchRequest(entity: RecommendPlaylist.entity(), sortDescriptors: []) var results: FetchedResults<RecommendPlaylist>
    @State private var playlistDetailId: Int64 = 0
    @State private var showPlaylistDetail: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(
                destination: FetchedPlaylistDetailView(id: playlistDetailId),
                isActive: $showPlaylistDetail,
                label: {EmptyView()})
            HStack {
                Text("推荐的歌单")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                Spacer()
                Text("\(results.count) 推荐的歌单")
                    .foregroundColor(Color.secondTextColor)
            }
            .padding(.horizontal)
            ScrollView(Axis.Set.horizontal, showsIndicators: true) {
                let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                    Button(action: {
                        playlistDetailId = 0
                        showPlaylistDetail.toggle()
                    }, label: {
                        CommonGridItemView(CommonGridItemConfiguration(id: 0, name: "每日推荐", picUrl: nil, subscribed: false))
                            .padding(.vertical)
                    })
                    ForEach(results) { (item) in
                        Button(action: {
                            playlistDetailId = item.id
                            showPlaylistDetail.toggle()
                        }, label: {
                            CommonGridItemView(item )
                                .padding(.vertical)
                        })
                    }
                }/*@END_MENU_TOKEN@*/
            }
        }
    }
}

#if DEBUG
struct RecommendPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendPlaylistView()
    }
}
#endif
