//
//  CreatedPlaylistView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/27.
//

import SwiftUI

struct CreatedPlaylistView: View {
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
                Text("创建的歌单")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                Spacer()
                Text("\(results.filter{$0.userId == Store.shared.appState.settings.loginUser?.uid}.count) 创建的歌单")
                    .foregroundColor(Color.secondTextColor)
            }
            .padding(.horizontal)
            ScrollView(Axis.Set.horizontal, showsIndicators: true) {
                let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                    ForEach(results) { (item) in
                        if item.userId == Store.shared.appState.settings.loginUser?.uid {
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

#if DEBUG
struct CreatedPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        CreatedPlaylistView()
    }
}
#endif

struct PlaylistRowView: View {
    let viewModel: PlaylistViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            NEUCoverView(url: viewModel.coverImgUrl, coverShape: .rectangle, size: .little)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                    .lineLimit(2)
                Text("\(viewModel.count) songs")
                    .foregroundColor(Color.secondTextColor)
            }
        }
    }
}

struct PlaylistCreateView: View {
    @EnvironmentObject var store: Store
    @Binding var showSheet: Bool
    @State var name: String = ""
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        NEUSFView(systemName: "checkmark", size:  .medium)
                    })
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                .padding()
                .overlay(
                    Text("创建歌单")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.mainTextColor)
                )
                TextField("歌单名", text: $name)
                    .textFieldStyle(NEUTextFieldStyle(label: Text("name:").padding()))
                    .padding()
                Button(action: {
                    showSheet.toggle()
                    Store.shared.dispatch(.playlistCreate(name: name))
                }){
                    HStack(spacing: 0.0) {
                        NEUSFView(systemName: "rectangle.stack.badge.plus", size: .medium)
                            .padding(.horizontal)
                    }
                }
                .buttonStyle(NEUButtonStyle(shape: Capsule()))
                Spacer()
            }
        }
    }
}

struct PlaylistManageView: View {
    @Binding var showSheet: Bool
    @State var playlists: [PlaylistViewModel]
    @State var isDeleted: Bool = false
    @State var isMoved: Bool = false
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showSheet.toggle()
                        if isMoved {
//                            Store.shared.dispatch(.playlistOrderUpdate(ids: playlists.map{$0.id}, type: type))
                        }
                        if isDeleted || isMoved {
                            Store.shared.dispatch(.userPlaylist())
                        }
                    }, label: {
                        NEUSFView(systemName: "checkmark", size: .medium)
                    })
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                .padding()
                .overlay(
                    Text("管理歌单")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.mainTextColor)
                )
                List {
                    ForEach(playlists) { item in
                        PlaylistRowView(viewModel: item)
                    }
                    .onDelete(perform: deleteAction)
                    .onMove(perform: moveAction)
                }
                Spacer()
            }
        }
    }
    func deleteAction(from source: IndexSet) {
        isDeleted = true
//        if let index = source.first {
//            let id = playlists[index].id
//            playlists.remove(at: index)
//            if type == .created {
//                Store.shared.dispatch(.playlistDelete(pid: id))
//            }
//            if type == .subscribed {
//                Store.shared.dispatch(.playlistSubscibe(id: id, sub: false))
//            }
//        }
    }
    func moveAction(from source: IndexSet, offset: Int) {
        isMoved = true
        playlists.move(fromOffsets: source, toOffset: offset)
    }
}
