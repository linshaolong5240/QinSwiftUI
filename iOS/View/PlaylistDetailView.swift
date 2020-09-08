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
    
    private var playlists: AppState.Playlists { store.appState.playlists }
    private var viewModelBinding: Binding<PlaylistViewModel> {$store.appState.playlists.playlistDetail}
    private var user: User? {store.appState.settings.loginUser}
    private var viewModel: PlaylistViewModel {
        store.appState.playlists.playlistDetail
    }
    @State var isMoved: Bool = false
    @State var showAction: Bool = false
    
    let id: Int
    
    init(_ id: Int) {
        self.id = id
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    NEUBackwardButton()
                        .buttonStyle(NEUButtonStyle(shape: Circle()))
                    Spacer()
                    Text("PLAYLIST DETAIL")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.mainTextColor)
                    Spacer()
                    Button(action: {
                        showAction.toggle()
                    }) {
                        NEUButtonView(systemName: "ellipsis", size: .medium)
                    }
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                .padding(.horizontal)
                if id != playlists.playlistDetail.id {
                    Text("正在加载...")
                        .foregroundColor(.secondTextColor)
                        .onAppear(perform: {
                            Store.shared.dispatch(.playlistDetail(id: self.id))
                        })
                }else if !playlists.playlistDetailRequesting {
                    PlaylistDescription(viewModel: viewModel)
                    HStack {
                        Group {
                            Text("歌曲列表")
                                .fontWeight(.bold)
                            Text("\(String(viewModel.count)) songs")
                        }
                        .foregroundColor(.secondTextColor)
                        Spacer()
                        if viewModel.userId == user?.uid {
                            NEUButtonView(systemName: "square.and.pencil", size: .small, active: editModeBinding?.wrappedValue.isEditing ?? false)
                                .background(NEUToggleBackground(isHighlighted: editModeBinding?.wrappedValue.isEditing ?? false, shape: Circle()))
                                .onTapGesture {
                                    if editModeBinding?.wrappedValue.isEditing ?? false {
                                        editModeBinding?.wrappedValue = .inactive
                                        if isMoved {
                                            Store.shared.dispatch(.songsOrderUpdate(pid: viewModel.id, ids: viewModel.trackIds))
                                        }
                                    }else {
                                        editModeBinding?.wrappedValue = .active
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                    if editModeBinding?.wrappedValue.isEditing ?? false {
                        PlaylistDetailEditSongsView(isMoved: $isMoved)
                    }else {
                        PlaylistDetailSongsView()
                    }
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .actionSheet(isPresented: $showAction, content: makeActionSheet)
    }
    func makeActionSheet() -> ActionSheet {
        let buttons: [ActionSheet.Button]
        if viewModel.subscribed {
            buttons = [
                .default(Text("取消收藏")) { Store.shared.dispatch(.playlistSubscibe(id: self.viewModel.id, subscibe: false)) },
                .cancel(Text("取消")) {self.showAction.toggle()},
            ]
        }
        else if viewModel.userId == user?.uid {
            if viewModel.id == playlists.likedPlaylistId {
                buttons = [
                    .default(Text("歌单信息")) {},
                    .cancel(Text("取消")) {self.showAction.toggle()},
                ]
            }else {
                buttons = [
                    .default(Text("编辑歌单")) {},
                    .default(Text("删除歌单")) { Store.shared.dispatch(.playlistDelete(pid: self.viewModel.id)) },
                    .cancel(Text("取消")) {self.showAction.toggle()},
                ]
            }
        }
        else {
            buttons = [
                .default(Text("收藏歌单")) { Store.shared.dispatch(.playlistSubscibe(id: self.viewModel.id, subscibe: true)) },
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
            BackgroundView()
            VStack {
                PlaylistDetailView(1)
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
        store.appState.playlists.playlistDetail
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
    private var viewModel: PlaylistViewModel {
        store.appState.playlists.playlistDetail
    }
    private var playing: AppState.Playing { store.appState.playing }
    @State var showPlayingNow: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<viewModel.tracks.count, id: \.self) { index in
                        Button(action: {
                            if  playing.songDetail.id == viewModel.tracks[index].id {
                                showPlayingNow.toggle()
                            }else {
                                Store.shared.dispatch(.setPlayinglist(playinglist: self.viewModel.tracks, index: index))
                                Store.shared.dispatch(.playByIndex(index: index))
                            }
                        }) {
                            PlaylistDetailSongsRowView(viewModel: self.viewModel.tracks[index])
                                .padding(.horizontal)
                        }
                    }
                }
            }
            NavigationLink(destination: PlayingNowView(), isActive: $showPlayingNow) {
                EmptyView()
            }
        }
    }
}

struct PlaylistDetailSongsRowView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    private var playing: AppState.Playing {
        store.appState.playing
    }
    
    let viewModel: SongViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.mainTextColor )
                        .lineLimit(1)
//                    HStack {
//                        Text(viewModel.artists)
//                            .fontWeight(.bold)
//                            .lineLimit(1)
//                        Spacer()
//                        Text(String(format: "%02d:%02d", Int(viewModel.durationTime/60),Int(viewModel.durationTime)%60))
//                    }
//                    .foregroundColor(Color.secondTextColor)
                    Text(viewModel.artists)
                        .fontWeight(.bold)
                        .foregroundColor(Color.secondTextColor)
                        .lineLimit(1)
                }
                .foregroundColor(player.isPlaying && viewModel.id == playing.songDetail.id ? .white : Color.secondTextColor)
                Spacer()
                Button(action: {
                    if viewModel.id == playing.songDetail.id {
                        Store.shared.dispatch(.togglePlay)
                    }else {
                        Store.shared.dispatch(.playRequest(id: self.viewModel.id))
                    }
                }) {
                    NEUButtonView(systemName: player.isPlaying && viewModel.id == playing.songDetail.id ? "pause.fill" : "play.fill", size: .small, active: viewModel.id == playing.songDetail.id ?  true : false)
                        .background(
                            NEUToggleBackground(isHighlighted: viewModel.id == playing.songDetail.id ?  true : false, shadow: false, shape: Circle())
                        )
                }
            }
            .padding(10)
            .background(
                VStack {
                    if viewModel.id == playing.songDetail.id {
                        if colorScheme == .light {
                            ZStack {
                                Color.white
                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9194737077, green: 0.2849465311, blue: 0.1981146634, alpha: 1)),Color(#colorLiteral(red: 0.9983269572, green: 0.3682751656, blue: 0.2816230953, alpha: 1)),Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .padding(5)
                                    .shadow(color: Color.black.opacity(0.25), radius: 5, x: -5, y: -5)
                                    .shadow(color: Color.white, radius: 5, x: 5, y: 5)
                                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        }else {
                            ZStack {
                                Color("backgroundColor")
                                LinearGradient(gradient: Gradient(colors: [Color("LbackgroundColor"),Color("LBGC2"),Color("LBGC3")]), startPoint: .top, endPoint: .bottom)
                                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                    .padding(1)
                                    .blur(radius: 1)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        }
                    }else {
                        Color(.clear)
                    }
                }
            )
        }
    }
}

struct PlaylistDescription: View {
    let viewModel: PlaylistViewModel
    @State var showMoreDescription: Bool = false

    var body: some View {
        HStack(alignment: .top) {
            NEUImageView(url: viewModel.coverImgUrl, size: .medium, innerShape: RoundedRectangle(cornerRadius: 25, style: .continuous), outerShape: RoundedRectangle(cornerRadius: 33, style: .continuous))
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
                        Text("\(viewModel.playCount)")
                        Image(systemName: "headphones")
                    }
                    Text("Id: \(String(viewModel.id))")
                }
                .foregroundColor(.secondTextColor)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}
