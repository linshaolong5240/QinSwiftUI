//
//  HomeView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/29.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct PlaylistsView: View {
    enum SheetType {
        case create, manage
    }    
    let title: String
    let data: [PlaylistViewModel]
    let type: PlaylistType
    @State var isManaging: Bool = false
    @State var isCreating: Bool = false
    @State var showSheet: Bool = false
    @State var sheetType: SheetType = .manage
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                Spacer()
                Text("\(data.count) \(title)")
                    .foregroundColor(Color.secondTextColor)
//                if type == .created {
//                    Button(action: {
//                        isCreating.toggle()
//                    }, label: {
//                        NEUButtonView(systemName: "rectangle.stack.badge.plus", size: .small)
//                    })
//                    .buttonStyle(NEUButtonStyle(shape: Circle()))
//                    .sheet(isPresented: $isCreating) {
//                        PlaylistCreateView(isCreating: $isCreating)
//                    }
//                }
//                if type == .created || type == .subscribed {
//                    Button(action: {
//                        isManaging.toggle()
//                    }, label: {
//                        NEUButtonView(systemName: "rectangle.stack", size: .small)
//                    })
//                    .buttonStyle(NEUButtonStyle(shape: Circle()))
//                    .sheet(isPresented: $isManaging) {
//                        PlaylistManageView(title: title, data: data, type: type, isManaging: $isManaging)
//                            .environment(\.editMode, Binding.constant(EditMode.active))
//                    }
//                }
                if type == .created {
                    Menu {
                        Button(action: {
                            sheetType = .manage
                            showSheet.toggle()
                        }){
                            HStack {
                                Image(systemName: "rectangle.stack.badge.person.crop")
                                Text("管理歌单")
                                Spacer()
                            }
                        }
                        Button(action: {
                                sheetType = .create
                                showSheet.toggle()
                               }){
                            HStack {
                                Image(systemName: "rectangle.stack.badge.plus")
                                Text("创建歌单")
                                Spacer()
                            }
                        }
                    } label: {
                        NEUSFView(systemName: "ellipsis", size: .small)
                    }
                    .menuStyle(NEUMenuStyle(shape: Circle()))
                }
                if type == .subable {
                    Menu {
                        Button(action: {
                            sheetType = .manage
                            showSheet.toggle()
                        }){
                            HStack {
                                Image(systemName: "heart")
                                Text("管理歌单")
                            }
                        }
                    } label: {
                        NEUSFView(systemName: "ellipsis", size: .small)
                    }
                    .menuStyle(NEUMenuStyle(shape: Circle()))
                }
            }
            .padding(.horizontal)
            ScrollView(Axis.Set.horizontal, showsIndicators: true) {
                let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                    ForEach(data) { item in
                        NavigationLink(destination: PlaylistDetailView(id: item.id, type: type)) {
                            PlaylistColumnView(viewModel: item)
                                .padding(.vertical)
                        }
                    }

                }/*@END_MENU_TOKEN@*/
            }
        }
        .sheet(isPresented: $showSheet) {
            if sheetType == .create {
                PlaylistCreateView(showSheet: $showSheet)
            }
            if sheetType == .manage {
                PlaylistManageView(showSheet: $showSheet, playlists: data, type: type)
                    .environment(\.editMode, Binding.constant(EditMode.active))
            }
        }
    }
}

#if DEBUG
let playlistsData = (1...10).map{_ in
   PlaylistViewModel()
}
struct PlaylistsView_Previews: PreviewProvider {

    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                PlaylistsView(title: "test", data: playlistsData, type: .subable)
                    .environmentObject(Store.shared)
//                PlaylistView(viewModel: PlaylistViewModel())
//                Spacer()
            }
        }
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

struct PlaylistColumnView: View {
    let viewModel: PlaylistViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            NEUCoverView(url: viewModel.coverImgUrl, coverShape: .rectangle, size: .small)
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
            if type == .subable {
                Store.shared.dispatch(.playlistSubscibe(id: id, sub: false))
            }
        }
    }
    func moveAction(from source: IndexSet, offset: Int) {
        isMoved = true
        playlists.move(fromOffsets: source, toOffset: offset)
    }
}
