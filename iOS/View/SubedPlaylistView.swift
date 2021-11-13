//
//  SubedPlaylistView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/27.
//

import SwiftUI

struct SubedPlaylistView: View {
    let playlist: [PlaylistResponse]
    @State private var playlistDetailId: Int = 0
    @State private var showPlaylistDetail: Bool = false
    @State private var showPlaylistManage: Bool = false

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
                    .foregroundColor(Color.mainText)
                Text("(\(Store.shared.appState.playlist.subedPlaylistIds.count))")
                    .foregroundColor(Color.mainText)
                Spacer()
                Button(action: {
                    showPlaylistManage.toggle()
                }) {
                    QinSFView(systemName: "lineweight", size:  .small)
                        .sheet(isPresented: $showPlaylistManage) {
                            PlaylistManageView(showSheet: $showPlaylistManage)
                                .environment(\.managedObjectContext, DataManager.shared.context())//sheet 需要传入父环境
                        }
                }
                .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
            }
            .padding(.horizontal)
            ScrollView(Axis.Set.horizontal, showsIndicators: true) {
                let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                    ForEach(playlist) { (item) in
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

//struct SubedPlaylistView: View {
//    @FetchRequest(entity: UserPlaylist.entity(), sortDescriptors: []) private var results: FetchedResults<UserPlaylist>
//    @State private var playlistDetailId: Int64 = 0
//    @State private var showPlaylistDetail: Bool = false
//    @State private var showPlaylistManage: Bool = false
//
//    var body: some View {
//        VStack(spacing: 0) {
//            NavigationLink(
//                destination: FetchedPlaylistDetailView(id: playlistDetailId),
//                isActive: $showPlaylistDetail,
//                label: {EmptyView()})
//            HStack {
//                Text("收藏的歌单")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(Color.mainTextColor)
//                Text("(\(Store.shared.appState.playlist.subedPlaylistIds.count))")
//                    .foregroundColor(Color.mainTextColor)
//                Spacer()
//                Button(action: {
//                    showPlaylistManage.toggle()
//                }) {
//                    NEUSFView(systemName: "lineweight", size:  .small)
//                        .sheet(isPresented: $showPlaylistManage) {
//                            PlaylistManageView(showSheet: $showPlaylistManage)
//                                .environment(\.managedObjectContext, DataManager.shared.context())//sheet 需要传入父环境
//                        }
//                }
//                .buttonStyle(NEUButtonStyle(shape: Circle()))
//            }
//            .padding(.horizontal)
//            ScrollView(Axis.Set.horizontal, showsIndicators: true) {
//                let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
//                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
//                    ForEach(results) { (item) in
//                        if Store.shared.appState.playlist.subedPlaylistIds.contains(item.id) {
//                            Button(action: {
//                                playlistDetailId = item.id
//                                showPlaylistDetail.toggle()
//                            }, label: {
//                                CommonGridItemView(item )
//                                    .padding(.vertical)
//                            })
//                        }
//                    }
//                }/*@END_MENU_TOKEN@*/
//            }
//        }
//    }
//}

//#if DEBUG
//struct SubedPlaylistView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubedPlaylistView(playlist: <#[PlaylistResponse]#>)
//    }
//}
//#endif
