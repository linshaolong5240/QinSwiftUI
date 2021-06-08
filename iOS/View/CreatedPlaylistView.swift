//
//  CreatedPlaylistView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/27.
//

import SwiftUI

struct CreatedPlaylistView: View {
    let playlist: [PlaylistResponse]
    @State private var playlistDetailId: Int = 0
    @State private var showPlaylistDetail: Bool = false
    @State private var showPlaylistCreate: Bool = false
    @State private var showPlaylistManage: Bool = false

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
                Text("(\(playlist.count))")
                    .foregroundColor(Color.mainTextColor)
                Spacer()
                Button(action: {
                    showPlaylistManage.toggle()
                }) {
                    NEUSFView(systemName: "lineweight", size:  .small)
                        .sheet(isPresented: $showPlaylistManage) {
                            PlaylistManageView(showSheet: $showPlaylistManage)
                                .environment(\.managedObjectContext, DataManager.shared.context())//sheet 需要传入父环境
                        }
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
                Button(action: {
                    showPlaylistCreate.toggle()
                }) {
                    NEUSFView(systemName: "folder.badge.plus", size:  .small)
                        .sheet(isPresented: $showPlaylistCreate) {
                            PlaylistCreateView(showSheet: $showPlaylistCreate)
                        }
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
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
                            CommonGridItemView(item)
                                .padding(.vertical)
                        })
                    }
                }/*@END_MENU_TOKEN@*/
            }
        }
    }
}

#if false//DEBUG
struct CreatedPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        CreatedPlaylistView()
    }
}
#endif

struct PlaylistCreateView: View {
    @EnvironmentObject private var store: Store
    @Binding var showSheet: Bool
    @State private var name: String = ""
    
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
                    .textFieldStyle(NEUTextFieldStyle(label: Image(systemName: "folder.badge.plus").padding()))
                    .padding()
                Button(action: {
                    showSheet.toggle()
                    Store.shared.dispatch(.playlistCreateRequest(name: name))
                }){
                    HStack(spacing: 0.0) {
                        NEUSFView(systemName: "folder.badge.plus", size: .medium)
                            .padding(.horizontal)
                    }
                }
                .buttonStyle(NEUButtonStyle(shape: Capsule()))
                Spacer()
            }
        }
    }
}
