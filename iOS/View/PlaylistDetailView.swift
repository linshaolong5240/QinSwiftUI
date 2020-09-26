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
    private var viewModel: PlaylistViewModel { store.appState.playlistDetail.detail }
    @State var isMoved: Bool = false
    @State var showAction: Bool = false
    
    let id: Int
    let type: PlaylistType
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                    Text("PLAYLIST DETAIL")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.mainTextColor)
                    Spacer()
                    Button(action: {
                        showAction.toggle()
                    }) {
                        NEUSFView(systemName: "ellipsis", size: .medium)
                    }
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                .padding(.horizontal)
                if id != playlistDetail.detail.id {
                    Text("正在加载...")
                        .foregroundColor(.secondTextColor)
                        .onAppear(perform: {
                            Store.shared.dispatch(.playlistDetail(id: self.id))
                        })
                }else if !playlistDetail.playlistDetailRequesting {
                    PlaylistDetailDescriptionView(viewModel: viewModel)
                    HStack {
                        Group {
                            Text("歌曲列表")
                                .fontWeight(.bold)
                            Text("\(String(viewModel.count)) songs")
                        }
                        .foregroundColor(.secondTextColor)
                        Spacer()
                        if type == .created {
                            NEUEditButton(action: {
                                if isMoved {
                                    Store.shared.dispatch(.songsOrderUpdate(pid: viewModel.id, ids: viewModel.trackIds))
                                }
                            })
//                            Button(action: {
//                                if editModeBinding?.wrappedValue.isEditing ?? false {
//                                    editModeBinding?.wrappedValue = .inactive
//                                    if isMoved {
//                                        Store.shared.dispatch(.songsOrderUpdate(pid: viewModel.id, ids: viewModel.trackIds))
//                                    }
//                                }else {
//                                    editModeBinding?.wrappedValue = .active
//                                }
//                            }) {
//                                NEUButtonView(systemName: "square.and.pencil", size: .small, active: editModeBinding?.wrappedValue.isEditing ?? false)
//                            }
//                            .buttonStyle(NEUButtonToggleStyle(isHighlighted: editModeBinding?.wrappedValue.isEditing ?? false, shape: Circle()))
                        }
                    }
                    .padding(.horizontal)
                    if editModeBinding?.wrappedValue.isEditing ?? false {
                        PlaylistDetailEditSongsView(isMoved: $isMoved)
                    }else {
                        PlaylistDetailSongsView()
                    }
                }
                if playlistDetail.playlistDetailRequesting {
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .actionSheet(isPresented: $showAction, content: makeActionSheet)
    }
    
    func makeActionSheet() -> ActionSheet {
        var buttons = [ActionSheet.Button]()
        switch type {
        case .created:
            buttons = [
                .default(Text("编辑歌单")) {},
                .default(Text("删除歌单")) { Store.shared.dispatch(.playlistDelete(pid: self.viewModel.id)) },
                .cancel(Text("取消")) {self.showAction.toggle()},
            ]
        case .recommend:
            buttons = [
                .default(Text("收藏歌单")) { Store.shared.dispatch(.playlistSubscibe(id: self.viewModel.id, subscibe: true)) },
                .cancel(Text("取消")) {self.showAction.toggle()},
            ]
        case .recommendSongs:
            break
        case .subscribed:
            buttons = [
                .default(Text("取消收藏")) { Store.shared.dispatch(.playlistSubscibe(id: self.viewModel.id, subscibe: false)) },
                .cancel(Text("取消")) {self.showAction.toggle()},
            ]
        }

        return ActionSheet(title: Text("选项"), buttons: buttons)
    }
}

#if DEBUG
struct PlaylistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                PlaylistDetailView(id: 1, type: .recommend)
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
        store.appState.playlistDetail.detail
    }
    @Binding var isMoved: Bool
    
    var body: some View {
        List {
            ForEach(viewModel.tracks) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.mainTextColor )
                            .lineLimit(1)
                        Text(item.artists)
                            .fontWeight(.bold)
                            .foregroundColor(Color.secondTextColor)
                            .lineLimit(1)
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
            viewModel.tracks.remove(at: index)
            Store.shared.dispatch(.playlistTracks(pid: viewModel.id, op: false, ids: [viewModel.trackIds[index]]))
        }
    }
    func moveAction(from source: IndexSet, to destination: Int) {
        isMoved = true
        viewModel.trackIds.move(fromOffsets: source, toOffset: destination)
        viewModel.tracks.move(fromOffsets: source, toOffset: destination)
    }
}

struct PlaylistDetailSongsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    private var viewModel: PlaylistViewModel {
        store.appState.playlistDetail.detail
    }
    private var playing: AppState.Playing { store.appState.playing }
    @State var showPlayingNow: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<viewModel.tracks.count, id: \.self) { index in
                        SongRowView(viewModel: viewModel.tracks[index], index: index, action: {
                            if  playing.songDetail.id == viewModel.tracks[index].id {
                                store.dispatch(.PlayerPlayOrPause)
                            }else {
                                Store.shared.dispatch(.setPlayinglist(playinglist: viewModel.tracks, index: index))
                                Store.shared.dispatch(.playByIndex(index: index))
                            }
                        })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if  playing.songDetail.id == viewModel.tracks[index].id {
                                showPlayingNow.toggle()
                            }else {
                                Store.shared.dispatch(.setPlayinglist(playinglist: viewModel.tracks, index: index))
                                Store.shared.dispatch(.playByIndex(index: index))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            NavigationLink(destination: PlayingNowView(), isActive: $showPlayingNow) {
                EmptyView()
            }
        }
    }
}

struct PlaylistDetailDescriptionView: View {
    let viewModel: PlaylistViewModel
    @State var showMoreDescription: Bool = false

    var body: some View {
        HStack(alignment: .top) {
            NEUCoverView(url: viewModel.coverImgUrl, coverShape: .rectangle, size: .medium)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .fontWeight(.bold)
                    .foregroundColor(.mainTextColor)
                Text(viewModel.description ?? "")
                    .foregroundColor(.secondTextColor)
                    .lineLimit(showMoreDescription ? nil : 3)
                    .onTapGesture{
                        showMoreDescription.toggle()
                    }
                Group {
                    HStack {
                        Image(systemName: "headphones")
                        Text(":")
                        Text("\(viewModel.playCount)")
                    }
                    HStack {
                        Text("Id")
                        Text(":")
                        Text("\(String(viewModel.id))")
                    }
                }
                .foregroundColor(.secondTextColor)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}
