//
//  PlayingView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

enum PlayingNowBottomType {
    case createdPlaylist
    case playinglist
    case playingStatus
}

struct PlayingNowView: View {
    @EnvironmentObject var store: Store
 
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
            NEUBackgroundView()
            VStack {
                NavigationLink(destination: FetchedArtistDetailView(id: artistId), isActive: $showArtist) {
                    EmptyView()
                }
                if !showMore {
                    HStack {
                        NEUBackwardButton()
                            .transition(.move(edge: .bottom))
                            .matchedGeometryEffect(id: 0, in: namespace)
                        Spacer()
                        NEUNavigationBarTitleView("PLAYING NOW")
                            .transition(.move(edge: .top))
                        Spacer()
                        Button(action: {
                            withAnimation(.default) {
                                showMore = true
                                bottomType = .createdPlaylist
                            }
                        }) {
                            NEUSFView(systemName: "plus" , size:  .medium)
                        }
                        .buttonStyle(NEUButtonStyle(shape: Circle()))
                        .transition(.move(edge: .bottom))
                        .matchedGeometryEffect(id: 1, in: namespace)
                    }
                    .padding(.horizontal)
                }else {
                    NEUNavigationBarTitleView(playing.song?.name ?? "")
                }
                ZStack {
                    if showMore {
                        HStack {
                            Button {
                                let id = Int(playing.song?.id ?? 0)
                                let like = !playlist.songlikedIds.contains(id)
                                Store.shared.dispatch(.songLikeRequest(id: id, like: like))
                            } label: {
                                let imageName = playlist.songlikedIds.contains(Int(playing.song?.id ?? 0)) ? "heart.fill" : "heart"
                                NEUSFView(systemName: imageName, size: .medium)
                            }
                            .buttonStyle(NEUButtonStyle(shape: Circle()))
                            .matchedGeometryEffect(id: 0, in: namespace)
                            Spacer()
                            Button(action: {}) {
                                NEUSFView(systemName: "ellipsis")
                            }
                            .buttonStyle(NEUButtonStyle(shape: Circle()))
                            .matchedGeometryEffect(id: 1, in: namespace)
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .top))
                    }
                    PlayingNowCoverView(showMore: $showMore, bottomType: $bottomType)
                    HStack {
                        Spacer()
                        if !showMore {
                            PlayingExtensionControllView()
                        }
                    }
                }
                ZStack {
                    let screen = UIScreen.main.bounds
                    if bottomType == .playingStatus {
                        PlayingNowStatusView(showMore: $showMore, showArtist: $showArtist, artistId: $artistId)
//                            .offset(y: bottomType == .playingStatus ? 0 : screen.height)
                            .transition(.move(edge: .bottom))
                    }
                    PlayingNowListView()
                        .offset(y: bottomType == .playinglist ? 0 : screen.height)
                        .transition(.move(edge: .bottom))
                    if bottomType == .createdPlaylist {
                        PlaylistTracksView(playlist: store.appState.playlist.createdPlaylist, showList: $showMore, bottomType: $bottomType)
                        .offset(y: bottomType == .createdPlaylist ? 0 : screen.height)
                        .transition(.move(edge: .bottom))
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .alert(item: $store.appState.error) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }
}

#if DEBUG
struct PlayingView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingNowView()
            .environmentObject(Store.shared)
            .environmentObject(Player.shared)
            .environment(\.managedObjectContext, DataManager.shared.context())
            .environment(\.colorScheme, .dark)
    }
}
#endif

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
                            SongRowView(song: item)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

struct PlayingNowStatusView: View {
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
                    .foregroundColor(Color.mainTextColor)
                if let artists = playing.song?.artists {
                    HStack {
                        ForEach(Array(artists as! Set<Artist>)) { item in
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
                            NEUSFView(systemName: "text.justify", size: .small, inactiveColor: Color.secondTextColor)
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
            HStack(spacing: 20) {
                Button(action: {
                    Store.shared.dispatch(.playerPlayBackward)
                }) {
                    NEUSFView(systemName: "backward.fill", size: .big)
                }
                .buttonStyle(NEUButtonStyle2(shape: Circle()))
                
                NEUSFView(systemName: player.isPlaying ? "pause.fill" : "play.fill", size: .large, active: true)
                    .background(
                        NEUToggleBackground(isHighlighted: true, shape: Circle())
                    )
                    .onTapGesture {
                        Store.shared.dispatch(.playerPlayOrPause)
                    }
                
                Button(action: {
                    Store.shared.dispatch(.playerPlayForward)
                }) {
                    NEUSFView(systemName: "forward.fill", size: .big)
                }
                .buttonStyle(NEUButtonStyle2(shape: Circle()))
            }
            .padding(.vertical)
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
                    NEUSFView(systemName: "rectangle.stack.badge.plus", size: .small)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
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
                                        Store.shared.dispatch(.playlistTracks(pid: item.id, ids: [Int(songId)], op: true))
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
                NEUSFView(systemName: settings.coverShape.systemName, size: .small, inactiveColor: Color.secondTextColor)
            }
            
            Button(action: {
                Store.shared.dispatch(.playerPlayMode)
            }) {
                NEUSFView(systemName: settings.playMode.systemName, size: .small, inactiveColor: Color.secondTextColor)
            }
        }
        .foregroundColor(Color.secondTextColor)
    }
}

struct PlayingNowCoverView: View {
    @EnvironmentObject var store: Store
    private var playing: AppState.Playing { store.appState.playing }
    private var settings: AppState.Settings { store.appState.settings }
    
    @Binding var showMore: Bool
    @Binding var bottomType: PlayingNowBottomType

    var body: some View {
        let url = playing.song?.album?.picUrl
        switch settings.coverShape {
        case .circle:
            NEUImageView(url: url,
                         size: !showMore ? .large: .medium,
                         innerShape: Circle(),
                         outerShape: Circle(),
                         innerPadding: showMore ? 6 : 12,
                         shadowReverse: true,
                         isOrigin: false)
                .contentShape(Circle())
                .onTapGesture(perform: tapAction)
        case .rectangle:
            NEUImageView(url: url,
                         size: showMore ? .medium: .large,
                         innerShape: RoundedRectangle(cornerRadius: showMore ? 25 : 50, style: .continuous),
                         outerShape: RoundedRectangle(cornerRadius: showMore ? 35 : 65, style: .continuous),
                         innerPadding: showMore ? 10 : 20,
                         shadowReverse: false,
                         isOrigin: false)
                .contentShape(Circle())
                .onTapGesture(perform: tapAction)
        }
    }
    func tapAction() {
        self.hideKeyboard()
        withAnimation(.default) {
            showMore.toggle()
            if showMore {
                bottomType = .playinglist
            }else {
                bottomType = .playingStatus
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
                PlayinglistView(songsId: store.appState.playing.playinglist)
                    .offset(y: listType == 0 ? 0 : offset)
                    .transition(.move(edge: .bottom))
                    .animation(.default)
                if listType == 1 {
                    CommentListView(id: Int(store.appState.playing.song?.id  ?? 0))
//                        .offset(y: listType == 1 ? 0 : offset)
                        .transition(.move(edge: .bottom))
                        .animation(.default)
                }
            }
        }
    }
}
