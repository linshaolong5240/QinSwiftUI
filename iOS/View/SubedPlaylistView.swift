//
//  SubedPlaylistView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/27.
//

import SwiftUI

struct SubedPlaylistView: View {
    @EnvironmentObject private var store: Store
    @FetchRequest(entity: UserPlaylist.entity(), sortDescriptors: []) private var results: FetchedResults<UserPlaylist>
    @State private var playlistDetailId: Int64 = 0
    @State private var showPlaylistDetail: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(
                destination: FetchedPlaylistDetailView(id: playlistDetailId),
                isActive: $showPlaylistDetail,
                label: {EmptyView()})
            HStack {
                Text("收藏的歌单")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                Spacer()
                Text("\(results.filter{$0.userId != Store.shared.appState.settings.loginUser?.uid}.count) 收藏的歌单")
                    .foregroundColor(Color.secondTextColor)
            }
            .padding(.horizontal)
            ScrollView(Axis.Set.horizontal, showsIndicators: true) {
                let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                    ForEach(results) { (item) in
                        if item.userId != Store.shared.appState.settings.loginUser?.uid {
                            Button(action: {
                                playlistDetailId = item.id
                                showPlaylistDetail.toggle()
                            }, label: {
                                CommonGridItemView(item )
                                    .padding(.vertical)
                            })
                        }
                    }
                }/*@END_MENU_TOKEN@*/
            }
        }
    }
}

struct SubedPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        SubedPlaylistView()
    }
}
