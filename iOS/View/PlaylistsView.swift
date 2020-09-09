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
    @EnvironmentObject var store: Store
    
    let title: String
    let data: [PlaylistViewModel]
    let type: PlaylistType
    @State var isManaging: Bool = false
    @State var isCreating: Bool = false
    @State var showSheet: Bool = false
    @State var sheetType: SheetType = .manage
    
    var body: some View {
        VStack(spacing: 0.0) {
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
                if type != .other {
                    Menu {
                        Button("管理歌单",
                               action: {
                                sheetType = .manage
                                showSheet.toggle()
                               })
                        if type == .created {
                            Button("创建歌单",
                                   action: {
                                    sheetType = .create
                                    showSheet.toggle()
                                   })
                        }
                    } label: {
                        NEUButtonView(systemName: "ellipsis", size: .small)
                    }
                    .menuStyle(NEUMenuStyle(shape: Circle()))
                }
            }
            .padding(.horizontal)
            ScrollView(Axis.Set.horizontal, showsIndicators: true) {
                HStack(alignment: .top, spacing: 10.0) {
                    ForEach(data) { item in
                        NavigationLink(destination: PlaylistDetailView(id: item.id, type: type)) {
                            PlaylistColumnView(viewModel: item)
                        }
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showSheet) {
            if sheetType == .create {
                PlaylistCreateView(showSheet: $showSheet)
            }else if sheetType == .manage {
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
            BackgroundView()
            VStack {
                PlaylistsView(title: "test", data: playlistsData, type: .subscribed)
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
            NEUImageView(url: viewModel.coverImgUrl, size: .small, innerShape: RoundedRectangle(cornerRadius: 15, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/), outerShape: RoundedRectangle(cornerRadius: 18, style: .continuous))
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
        VStack(alignment: .leading, spacing: 10.0) {
            NEUImageView(url: viewModel.coverImgUrl, size: .medium, innerShape: RoundedRectangle(cornerRadius: 25, style: .continuous), outerShape: RoundedRectangle(cornerRadius: 33, style: .continuous))
            Text(viewModel.name)
                .foregroundColor(Color.mainTextColor)
                .lineLimit(2)
                .frame(width: screen.width * 0.3 + 20, alignment: .leading)
            Text("\(viewModel.count) songs")
                .foregroundColor(Color.secondTextColor)
        }
    }
}

struct PlaylistCreateView: View {
    @EnvironmentObject var store: Store
    @Binding var showSheet: Bool
    @State var name: String = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        NEUButtonView(systemName: "checkmark")
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
                        NEUButtonView(systemName: "rectangle.stack.badge.plus")
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
            BackgroundView()
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
                        NEUButtonView(systemName: "checkmark")
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
                Store.shared.dispatch(.playlistSubscibe(id: id, subscibe: false))
            }
        }
    }
    func moveAction(from source: IndexSet, offset: Int) {
        isMoved = true
        playlists.move(fromOffsets: source, toOffset: offset)
    }
}
