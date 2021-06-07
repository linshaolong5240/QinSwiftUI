//
//  PlaylistManageView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/12/6.
//

import SwiftUI

struct PlaylistManageView: View {
    @State private var editMode: EditMode = .active
    @FetchRequest(entity: UserPlaylist.entity(), sortDescriptors: []) private var results: FetchedResults<UserPlaylist>
    @Binding var showSheet: Bool
    @State private var ids = [Int64]()
    @State private var deleteId: Int64 = 0
    @State private var isDeleted: Bool = false
    @State private var isMoved: Bool = false
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showSheet.toggle()
                        if isMoved {
                            Store.shared.dispatch(.playlistOrderUpdate(ids: ids))
                        }
                    }, label: {
                        NEUSFView(systemName: "checkmark", size: .medium)
                    })
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                .overlay(
                    NEUNavigationBarTitleView("管理歌单")
                )
                .padding()
                List {
                    ForEach(results) { (item: UserPlaylist) in
                        UserPlaylistRowView(playlist: item)
                    }
                    .onDelete(perform: deleteAction)
                    .onMove(perform: moveAction)
                }
                .environment(\.editMode, $editMode)
                .onAppear {
                    ids = results.map{ $0.id }
                }
            }
        }
        .alert(isPresented: $isDeleted) {
            Alert(title: Text("删除歌单"), message: Text("确定删除歌单"), primaryButton: Alert.Button.cancel(Text("取消")), secondaryButton: Alert.Button.destructive(Text("删除"),action: {
                Store.shared.dispatch(.playlistDelete(pid: Int(deleteId)))
            }))
        }
    }
    func deleteAction(from source: IndexSet) {
        isDeleted = true
        if let index = source.first {
            deleteId = results[index].id
        }
    }
    func moveAction(from source: IndexSet, offset: Int) {
        isMoved = true
        ids.move(fromOffsets: source, toOffset: offset)
    }
}

#if DEBUG
struct PlaylistManageView_Previews: PreviewProvider {
    @State static var isShow = false
    static var previews: some View {
        PlaylistManageView(showSheet: $isShow)
    }
}
#endif


struct UserPlaylistRowView: View {
    @ObservedObject var playlist: UserPlaylist
    
    var body: some View {
        HStack {
            NEUCoverView(url: playlist.coverImgUrl, coverShape: .rectangle, size: .little)
            VStack(alignment: .leading) {
                Text(playlist.name ?? "")
                    .foregroundColor(.mainTextColor)
                Text("\(playlist.trackCount) songs")
                    .foregroundColor(.secondTextColor)
            }
            Spacer()
        }
    }
}
