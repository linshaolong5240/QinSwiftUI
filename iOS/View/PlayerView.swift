//
//  PlayerView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import NeumorphismSwiftUI
import Combine

enum PlayingNowBottomType {
    case createdPlaylist
    case playinglist
    case playingStatus
}

class PlayerViewModel: ObservableObject {
    enum DisplayMode {
        case stand
        case playlist
        case addToMyPlaylist
    }
    @Published var displayMode: DisplayMode = .stand
    @Published var isShowArtist: Bool = false
    
    func setDisplayMode(_ mode: DisplayMode) {
        displayMode = mode
    }
    
    func tapCover() {
        if displayMode != .stand {
            displayMode = .stand
        }else if displayMode == .stand {
            displayMode = .playlist
        }
    }
    
    func showMyPlaylist() {
        
    }
}

struct PlayerView: View {
    @EnvironmentObject var store: Store
    @StateObject var viewModel: PlayerViewModel = .init()
    
    private var playing: AppState.Playing { store.appState.playing }
    private var playlist: AppState.Playlist { store.appState.playlist }
    
    @State private var showMore: Bool = false
    @State private var bottomType: PlayingNowBottomType = .playingStatus
    @State private var showComment: Bool = false
    @State private var showArtist: Bool = false
    @State private var artistId: Int = 0
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            QinBackgroundView()
            NavigationLink(destination: FetchedArtistDetailView(id: artistId), isActive: $showArtist) {
                EmptyView()
            }
            VStack(spacing: 20) {
                if viewModel.displayMode == .stand {
                    PlayerNavgationBarView(namespace: namespace, viewModel: viewModel)
                }
                ZStack {
                    if viewModel.displayMode != .stand {
                        HStack {
                            Button {
                                let id = Int(playing.song?.id ?? 0)
                                let like = !playlist.songlikedIds.contains(id)
                                Store.shared.dispatch(.songLikeRequest(id: id, like: like))
                            } label: {
                                let imageName = playlist.songlikedIds.contains(Int(playing.song?.id ?? 0)) ? "heart.fill" : "heart"
                                QinSFView(systemName: imageName, size: .medium)
                            }
                            .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
                            .matchedGeometryEffect(id: 0, in: namespace)
                            Spacer()
                            Button(action: {}) {
                                QinSFView(systemName: "ellipsis")
                            }
                            .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
                            .matchedGeometryEffect(id: 1, in: namespace)
                        }
                        .padding(.horizontal)
                    }
                    PlayerCoverView(viewModel: viewModel)
                    if viewModel.displayMode == .stand {
                        HStack {
                            Spacer()
                            PlayingExtensionControllView()
                        }
                    }
                }
                Group {
                    if viewModel.displayMode == .stand {
                        PlayerControllView(showMore: $showMore, showArtist: $showArtist, artistId: $artistId)
                            .transition(.move(edge: .bottom))
                    }
                    if viewModel.displayMode == .playlist {
                        PlayingNowListView()
                            .transition(.move(edge: .bottom))
                    }
                    if viewModel.displayMode == .addToMyPlaylist {
                        PlaylistTracksView(playlist: store.appState.playlist.createdPlaylist, showList: $showMore, bottomType: $bottomType)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct PlayingView_Previews: PreviewProvider {
    static var previews: some View {
        //        PlayerView()
        //            .preferredColorScheme(.light)
        //            .environmentObject(Store.shared)
        //            .environmentObject(Player.shared)
        //            .environment(\.managedObjectContext, DataManager.shared.context())
        PlayerView()
            .preferredColorScheme(.dark)
            .environmentObject(Store.shared)
            .environmentObject(Player.shared)
            .environment(\.managedObjectContext, DataManager.shared.context())
        
    }
}
#endif

struct PlayerNavgationBarView: View {
    let namespace: Namespace.ID
    @ObservedObject var viewModel: PlayerViewModel
    
    var body: some View {
        HStack {
            QinBackwardButton()
                .matchedGeometryEffect(id: 0, in: namespace)
            Spacer()
            QinNavigationBarTitleView("PLAYING NOW")
            Spacer()
            Button(action: {
                withAnimation(.default) {
                    viewModel.setDisplayMode(.addToMyPlaylist)
                }
            }) {
                QinSFView(systemName: "plus" , size:  .medium)
            }
            .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
            .matchedGeometryEffect(id: 1, in: namespace)
        }
        .padding(.horizontal)
    }
}

struct PlayerControllView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var player: Player
    
    private var playing: AppState.Playing { store.appState.playing }
    
    @State private var showLyric: Bool = false
    @Binding var showMore: Bool
    @Binding var showArtist: Bool
    @Binding var artistId: Int
    
    var body: some View {
        VStack {
            VStack {
                Text(playing.song?.name ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundColor(Color.mainText)
                HStack {
                    ForEach(playing.song?.artists ?? []) { item in
                        Button(action: {
                            if item.id != 0 {
                                artistId = Int(item.id)
                                showArtist.toggle()
                            }
                        }, label: {
                            Text(item.name ?? "")
                        })
                    }
                }
            }
            .padding()
            ZStack {
                if showLyric {
                    if let lyric = store.appState.lyric.lyric {
                        LyricView(lyric)
                            .onTapGesture {
                                withAnimation(.default) {
                                    showMore.toggle()
                                }
                            }
                    }else {
                        Text("无歌词")
                            .foregroundColor(.secondTextColor)
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showLyric.toggle()
                            withAnimation(.default) {
                                showMore = showLyric
                            }
                        }) {
                            QinSFView(systemName: "text.justify", size: .small, inactiveColor: Color.secondTextColor)
                        }
                    }
                }
            }
            HStack {
                Text(String(format: "%02d:%02d", Int(player.loadTime/60),Int(player.loadTime)%60))
                    .frame(width: 50, alignment: Alignment.leading)
                Slider(value: $player.loadTime, in: 0...(player.totalTime > 0 ? player.totalTime : 1.0), onEditingChanged: { (isEdit) in
                    Store.shared.dispatch(.playerSeek(isSeeking: isEdit, time: player.loadTime)
                    )
                })
                    .modifier(NEUShadow())
                Text(String(format: "%02d:%02d", Int(player.totalTime/60),Int(player.totalTime)%60))
                    .frame(width: 50, alignment: Alignment.trailing)
            }
            .font(.system(size: 13))
            .foregroundColor(Color.secondTextColor)
            HStack(spacing: 40) {
                Button(action: {
                    Store.shared.dispatch(.playerPlayBackward)
                }) {
                    QinSFView(systemName: "backward.fill", size: .big
                    )
                }
                .buttonStyle(NEUConvexBorderButtonStyle(shape: Circle()))
                QinSFView(systemName: player.isPlaying ? "pause.fill" : "play.fill", size: .large, active: true)
                    .background(
                        NEUPlayButtonBackgroundView(shape: Circle())
                    )
                    .onTapGesture {
                        if let song = store.appState.playing.song {
                            Store.shared.dispatch(.playerTogglePlay(song: song))
                        }
                    }
                Button(action: {
                    Store.shared.dispatch(.playerPlayForward)
                }) {
                    QinSFView(systemName: "forward.fill", size: .big)
                }
                .buttonStyle(NEUConvexBorderButtonStyle(shape: Circle()))
            }
            .padding(.vertical)
        }
    }
}

struct PlayinglistView: View {
    let songsId: [Int]
    
    @State private var show: Bool = false
    
    var body: some View {
        FetchedResultsView(entity: Song.entity(), predicate: NSPredicate(format: "%K IN %@", "id", songsId)) { (results: FetchedResults<Song>) in
            ScrollView {
                if let songs = results {
                    LazyVStack {
                        ForEach(songs.sorted(by: { (left, right) -> Bool in
                            let lIndex = songsId.firstIndex(of: Int(left.id))!
                            let rIndex = songsId.firstIndex(of: Int(right.id))!
                            return lIndex > rIndex ? false : true
                        })) { item in
                            QinSongRowView(viewModel: .init(item))
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}

struct PlaylistTracksView: View {
    let playlist: [PlaylistResponse]
    @Binding var showList: Bool
    @Binding  var bottomType: PlayingNowBottomType
    
    @State private var showCreate: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("收藏到歌单")
                    .font(.title)
                    .foregroundColor(.secondary)
                Spacer()
                Button(action: {
                    self.showCreate.toggle()
                }) {
                    QinSFView(systemName: "rectangle.stack.badge.plus", size: .small)
                }
                .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
                .sheet(isPresented: $showCreate) {
                    PlaylistCreateView(showSheet: $showCreate)
                }
            }
            .padding(.horizontal)
            ScrollView {
                LazyVStack{
                    ForEach(playlist){ item in
                        if Store.shared.appState.playlist.createdPlaylistIds.contains(item.id) && item.id != Store.shared.appState.playlist.likedPlaylistId {
                            Button(action: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    if let songId = Store.shared.appState.playing.song?.id {
                                        Store.shared.dispatch(.playlistTracksRequest(pid: item.id, ids: [Int(songId)], op: true))
                                    }
                                }
                                withAnimation(.default){
                                    showList = false
                                    bottomType = .playingStatus
                                }
                            }) {
                                UserPlaylistRowView(playlist: item)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct PlayingExtensionControllView: View {
    @EnvironmentObject var store: Store
    
    private var settings: AppState.Settings { store.appState.settings }
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                store.dispatch(.coverShape)
            }) {
                QinSFView(systemName: settings.coverShape.systemName, size: .small, inactiveColor: Color.secondTextColor)
            }
            
            Button(action: {
                Store.shared.dispatch(.playerPlayMode)
            }) {
                QinSFView(systemName: settings.playMode.systemName, size: .small, inactiveColor: Color.secondTextColor)
            }
        }
        .foregroundColor(Color.secondTextColor)
    }
}

struct PlayerCoverView: View {
    @EnvironmentObject var store: Store
    private var playing: AppState.Playing { store.appState.playing }
    private var settings: AppState.Settings { store.appState.settings }
    
    @ObservedObject var viewModel: PlayerViewModel
    
    var type: NEUBorderStyle {
        switch settings.coverShape {
        case .circle:       return .convexFlat
        case .rectangle:    return .unevenness
        }
    }
    
    var body: some View {
        let url = playing.song?.album?.coverURLString
        QinCoverView(url, style: QinCoverStyle(size: viewModel.displayMode != .stand ? .medium : .large, shape: settings.coverShape, type: type))
            .contentShape(Circle())
            .onTapGesture {
                hideKeyboard()
                withAnimation(.default) {
                    viewModel.tapCover()
                }
            }
    }
}

struct PlayingNowListView: View {
    @EnvironmentObject private var store: Store
    @State private var listType: Int = 0
    
    var body: some View {
        VStack {
            Picker(selection: $listType, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                Text("播放列表").tag(0)
                Text("歌曲评论").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .fixedSize()
            
            ZStack {
                let offset = UIScreen.main.bounds.height
                PlayinglistView(songsId: store.appState.playing.playinglist.map(\.id))
                    .offset(y: listType == 0 ? 0 : offset)
                if listType == 1 {
                    CommentListView(id: Int(store.appState.playing.song?.id  ?? 0))
                }
            }
        }
    }
}
