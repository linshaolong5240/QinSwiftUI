//
//  PlaylistDetailView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/26.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct PlaylistDetailView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    @Environment(\.editMode) var editModeBinding:  Binding<EditMode>?
    
    private var playlistDetail: AppState.PlaylistDetail { store.appState.playlistDetail }
    private var viewModel: PlaylistViewModel { store.appState.playlistDetail.viewModel }
    @State var isMoved: Bool = false
    
    let id: Int
    let type: PlaylistType
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                    NEUNavigationBarTitleView("歌单详情")
                    Spacer()
                    if type == .created {
                        Button(action: {
                            Store.shared.dispatch(.playlistDelete(pid: viewModel.id))
                        }, label: {
                            NEUSFView(systemName: "trash.fill")
                        })
                        .buttonStyle(NEUButtonStyle(shape: Circle()))
                    }
                    if type == .subable && viewModel.id != 0 {
                        Button(action: {
                            Store.shared.dispatch(.playlistSubscibe(id: viewModel.id, sub: viewModel.subscribed ? false : true))
                        }, label: {
                            NEUSFView(systemName: "heart.fill",
                                      active: viewModel.subscribed)
                        })
                        .buttonStyle(NEUButtonToggleStyle(isHighlighted: viewModel.subscribed, shape: Circle()))
                    }
                }
                .padding(.horizontal)
                .onAppear(perform: {
                    Store.shared.dispatch(.playlistDetail(id: self.id))
                })
                if playlistDetail.requesting {
                    Text("正在加载...")
                        .foregroundColor(.secondTextColor)
                    Spacer()
                }else {
                    DescriptionView(viewModel: viewModel)
                    HStack {
                        Text("歌曲列表(\(String(viewModel.count)))")
                            .fontWeight(.bold)
                            .foregroundColor(.secondTextColor)
                        Spacer()
                        if type == .created {
                            NEUEditButton(action: {
                                if isMoved {
                                    Store.shared.dispatch(.songsOrderUpdate(pid: viewModel.id, ids: viewModel.songIds))
                                }
                            })
                        }
                    }
                    .padding(.horizontal)
                    if editModeBinding?.wrappedValue.isEditing ?? false {
                        PlaylistDetailEditSongsView(isMoved: $isMoved)
                    }else {
                        SongListView(songs: viewModel.songs)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct PlaylistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                PlaylistDetailView(id: 1, type: .subable)
                //                List {
                //                    SongRowView(viewModel: SongViewModel(id: 0, name: "test", artists: "test"), active: false)
                //                        .environment(\.colorScheme, .light)
                //                    SongRowView(viewModel: SongViewModel(id: 0, name: "test", artists: "test"), active: true)
                //                        .environment(\.colorScheme, .light)
                //                    SongRowView(viewModel: SongViewModel(id: 0, name: "test", artists: "test"), active: false)
                //                        .environment(\.colorScheme, .light)
                //                }
            }
        }
        .environmentObject(Store.shared)
        .environmentObject(Player.shared)
    }
}
#endif

struct PlaylistDetailEditSongsView: View {
    @EnvironmentObject var store: Store
    private var viewModel: PlaylistViewModel {
        store.appState.playlistDetail.viewModel
    }
    @Binding var isMoved: Bool
    
    var body: some View {
        List {
            ForEach(viewModel.songs) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.mainTextColor )
                            .lineLimit(1)
                        HStack {
                            ForEach(item.artists) { item in
                                Text(item.name)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.secondTextColor)
                                    .lineLimit(1)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .onDelete(perform: deleteAction)
            .onMove(perform: moveAction)
        }
    }
    func deleteAction(from source: IndexSet) {
        if let index = source.first {
            viewModel.songs.remove(at: index)
            Store.shared.dispatch(.playlistTracks(pid: viewModel.id, op: false, ids: [viewModel.songIds[index]]))
        }
    }
    func moveAction(from source: IndexSet, to destination: Int) {
        isMoved = true
        viewModel.songIds.move(fromOffsets: source, toOffset: destination)
        viewModel.songs.move(fromOffsets: source, toOffset: destination)
    }
}
