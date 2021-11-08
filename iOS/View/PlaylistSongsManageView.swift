//
//  PlaylistSongsManageView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/12/6.
//

import SwiftUI

struct PlaylistSongsManageView: View {
    @Binding var showSheet: Bool
    @ObservedObject var playlist :Playlist
    
    @State private var editMode: EditMode = .active
    @State private var songs = [Song]()
    @State private var  deletedIndex: Int = 0
    @State private var  deletedId: Int64 = 0
    @State private var  deletedIds = [Int64]()
    @State private var  isDeleted: Bool = false
    @State private var  isMoved: Bool = false
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showSheet.toggle()
                        if deletedIds.count > 0 {
                            Store.shared.dispatch(.playlistTracksRequest(pid: Int(playlist.id), ids: deletedIds.map(Int.init), op: false))
                        }
                        if isMoved {
                            Store.shared.dispatch(.songsOrderUpdateRequesting(pid: Int(playlist.id), ids: songs.map{ Int($0.id) }))
                        }
                    }, label: {
                        QinSFView(systemName: "checkmark", size: .medium)
                    })
                    .buttonStyle(NEUSimpleButtonStyle(shape: Circle()))
                }
                .overlay(
                    QinNavigationBarTitleView("管理歌曲")
                )
                .padding()
                List {
                    ForEach(songs) { (item: Song) in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name ?? "")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(.mainTextColor)
                                    .lineLimit(1)
                                if let artists = item.artists?.allObjects as? [Artist] {
                                    HStack {
                                        ForEach(artists) { item in
                                            Text(item.name ?? "")
                                                .foregroundColor(Color.secondTextColor)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                    .onDelete(perform: deleteAction)
                    .onMove(perform: moveAction)
                }
                .onAppear {
                    if let songs = playlist.songs?.allObjects as? [Song] {
                        if let songsId = playlist.songsId {
                            self.songs = songs.sorted(by: { (left, right) -> Bool in
                                let lIndex = songsId.firstIndex(of: left.id)
                                let rIndex = songsId.firstIndex(of: right.id)
                                return lIndex ?? 0 > rIndex ?? 0 ? false : true
                            })
                        }
                    }
                }
                .environment(\.editMode, $editMode)
            }
            .alert(isPresented: $isDeleted) {
                Alert(title: Text("删除歌曲"), message: Text("确定删除歌曲"), primaryButton: Alert.Button.cancel(Text("取消")), secondaryButton: Alert.Button.destructive(Text("删除"),action: {
                    deletedIds.append(deletedId)
                    songs.remove(at: deletedIndex)
                }))
            }
        }
    }
    func deleteAction(from source: IndexSet) {
        isDeleted = true
        if let index = source.first {
            deletedId = songs[index].id
            deletedIndex = index
        }
    }
    func moveAction(from source: IndexSet, to destination: Int) {
        isMoved = true
        songs.move(fromOffsets: source, toOffset: destination)
    }
}

#if DEBUG
struct PlaylistSongsManageView_Previews: PreviewProvider {
    @State static var isShow = false
    static var previews: some View {
        PlaylistSongsManageView(showSheet: $isShow, playlist: Playlist(context: DataManager.shared.context()))
    }
}
#endif
