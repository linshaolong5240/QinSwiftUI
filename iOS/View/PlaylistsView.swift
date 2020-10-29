//
//  HomeView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/29.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import CoreData

enum PlaylistType: Int, Codable {
    case created, recommendPlaylist, subscribed
}

struct PlaylistsView: View {
    enum SheetType {
        case create, manage
    }
    
    private let title: String
    private let type: PlaylistType
    private var sortDescriptors: [NSSortDescriptor] = []
    private var predicate: NSPredicate? = nil
    @State private var playlist = PlaylistViewModel()
    @State private var playlistDetailId: Int = 0
    @State private var showPlaylistDetail: Bool = false
    @State private var isManaging: Bool = false
    @State private var isCreating: Bool = false
    @State private var showSheet: Bool = false
    @State private var sheetType: SheetType = .manage
    
    init(title: String, type: PlaylistType) {
        self.title = title
        self.type = type
        switch self.type {
        case .created:
            let userId = Store.shared.appState.settings.loginUser?.uid ?? 0
            self.predicate = NSPredicate(format: "%K == \(userId)", "userId")
        case .recommendPlaylist:
            break
        case .subscribed:
            self.predicate = NSPredicate(format: "%K == \(true)", "subscribed")
        }
    }
    
    var body: some View {
        if type == .recommendPlaylist {
            FetchedResultsView(entity: RecommendPlaylist.entity(), sortDescriptors: sortDescriptors, predicate: predicate) { (results: FetchedResults<RecommendPlaylist>) in
                VStack(spacing: 0) {
                    NavigationLink(
                        destination: PlaylistDetailView(playlist: playlist, id: playlistDetailId, type: type),
                        isActive: $showPlaylistDetail,
                        label: {EmptyView()})
                    HStack {
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.mainTextColor)
                        Spacer()
                        Text("\(results.count) \(title)")
                            .foregroundColor(Color.secondTextColor)
                    }
                    .padding(.horizontal)
                    ScrollView(Axis.Set.horizontal, showsIndicators: true) {
                        let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
                        LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                            Button(action: {
                                //                            playlist = item
                                //                            playlistDetailId = item.id
                                showPlaylistDetail.toggle()
                            }, label: {
                                CommonGridItemView(Store.shared.appState.playlist.recommendSongsPlaylist)
                                    .padding(.vertical)
                            })
                            ForEach(results) { (item) in
                                Button(action: {
                                    //                            playlist = item
                                    //                            playlistDetailId = item.id
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
        }else {
            FetchedResultsView(entity: Playlist.entity(), sortDescriptors: sortDescriptors, predicate: predicate) { (results: FetchedResults<Playlist>) in
                VStack(spacing: 0) {
                    NavigationLink(
                        destination: PlaylistDetailView(playlist: playlist, id: playlistDetailId, type: type),
                        isActive: $showPlaylistDetail,
                        label: {EmptyView()})
                    HStack {
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.mainTextColor)
                        Spacer()
                        Text("\(results.count) \(title)")
                            .foregroundColor(Color.secondTextColor)
                    }
                    .padding(.horizontal)
                    ScrollView(Axis.Set.horizontal, showsIndicators: true) {
                        let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
                        LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                            ForEach(results) { (item) in
                                Button(action: {
                                    //                            playlist = item
                                    //                            playlistDetailId = item.id
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
    }
}

//#if DEBUG
//let playlistsData = (1...10).map{_ in
//   PlaylistViewModel()
//}
//struct PlaylistsView_Previews: PreviewProvider {
//
//    static var previews: some View {
////        ZStack {
////            NEUBackgroundView()
////            VStack {
////                PlaylistsView(title: "test", data: playlistsData, type: .subable)
////                    .environmentObject(Store.shared)
//////                PlaylistView(viewModel: PlaylistViewModel())
//////                Spacer()
////            }
////        }
//    }
//}
//#endif

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
    let type: PlaylistType
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
                            Store.shared.dispatch(.playlistOrderUpdate(ids: playlists.map{$0.id}, type: type))
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
        if let index = source.first {
            let id = playlists[index].id
            playlists.remove(at: index)
            if type == .created {
                Store.shared.dispatch(.playlistDelete(pid: id))
            }
            if type == .subscribed {
                Store.shared.dispatch(.playlistSubscibe(id: id, sub: false))
            }
        }
    }
    func moveAction(from source: IndexSet, offset: Int) {
        isMoved = true
        playlists.move(fromOffsets: source, toOffset: offset)
    }
}
