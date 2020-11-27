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
    @State private var showMore: Bool = false
    @State private var bottomType: PlayingNowBottomType = .playingStatus
    @State private var showComment: Bool = false
    @State private var showArtist: Bool = false
    @State private var artistId: Int64 = 0
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                NavigationLink(destination: FetchedArtistDetailView(id: artistId), isActive: $showArtist) {
                    EmptyView()
                }
                NavigationLink(destination: CommentView(id: playing.song?.id ?? 0), isActive: $showComment) {
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
                            Button(action: {
                                if let id = Store.shared.appState.playing.song?.id {
                                    let like = !Store.shared.appState.playlist.likedIds.contains(id)
                                    Store.shared.dispatch(.like(id: id, like: like))
                                }
                            }) {
                                NEUSFView(systemName: store.appState.playlist.likedIds.contains(playing.song?.id ?? 0) ? "heart.fill" : "heart", size: .medium)
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
                    PlayingNowCoverView(showMore: $showMore, bottomType: $bottomType, showComment: $showComment)
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
                        PlaylistTracksView(showList: $showMore, bottomType: $bottomType)
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
            .environment(\.managedObjectContext, DataManager.shared.Context())
            .environment(\.colorScheme, .dark)
    }
}
#endif

struct PlayinglistView: View {
    @State private var show: Bool = false
    let songsId: [Int64]
    
    var body: some View {
        FetchedResultsView(entity: Song.entity(), predicate: NSPredicate(format: "%K IN %@", "id", songsId)) { (results: FetchedResults<Song>) in
            ScrollView {
                if let songs = results {
                    LazyVStack {
                        ForEach(songs.sorted(by: { (left, right) -> Bool in
                            let lIndex = songsId.firstIndex(of: left.id)!
                            let rIndex = songsId.firstIndex(of: right.id)!
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
    @Binding var artistId: Int64

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
                                    artistId = item.id
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
                    Store.shared.dispatch(.PlayerSeek(isSeeking: isEdit, time: player.loadTime)
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
                    Store.shared.dispatch(.PlayerPlayBackward)
                }) {
                    NEUSFView(systemName: "backward.fill", size: .big)
                }
                .buttonStyle(NEUButtonStyle2(shape: Circle()))
                
                NEUSFView(systemName: player.isPlaying ? "pause.fill" : "play.fill", size: .large, active: true)
                    .background(
                        NEUToggleBackground(isHighlighted: true, shape: Circle())
                    )
                    .onTapGesture {
                        Store.shared.dispatch(.PlayerPlayOrPause)
                    }
                
                Button(action: {
                    Store.shared.dispatch(.PlayerPlayForward)
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
            FetchedResultsView(entity: UserPlaylist.entity()) { (results: FetchedResults<UserPlaylist>) in
                ScrollView {
                    LazyVStack{
                        ForEach(results){ (item: UserPlaylist) in
                            Button(action: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    if let songId = Store.shared.appState.playing.song?.id {
                                        Store.shared.dispatch(.playlistTracks(pid: item.id, op: true, ids: [songId]))
                                    }
                                }
                                withAnimation(.default){
                                    showList = false
                                    bottomType = .playingStatus
                                }
                            }) {
                                HStack {
                                    NEUCoverView(url: item.coverImgUrl ?? "", coverShape: .rectangle, size: .little)
                                    VStack(alignment: .leading) {
                                        Text(item.name ?? "")
                                            .foregroundColor(.mainTextColor)
                                        Text("\(item.trackCount) songs")
                                            .foregroundColor(.secondTextColor)
                                    }
                                    Spacer()
                                }
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
                Store.shared.dispatch(.PlayerPlayMode)
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
    @Binding var showComment: Bool

    var body: some View {
        let url = playing.song?.album?.picUrl ?? ""
        switch settings.coverShape {
        case .circle:
            NEUImageView(url: url,
                         size: !showMore ? .large: .medium,
                         innerShape: Circle(),
                         outerShape: Circle(),
                         innerPadding: showMore ? 6 : 12,
                         shadowReverse: true,
                         isOrigin: false)
                .onTapGesture(perform: tapAction)
        case .rectangle:
            NEUImageView(url: url,
                         size: showMore ? .medium: .large,
                         innerShape: RoundedRectangle(cornerRadius: showMore ? 25 : 50, style: .continuous),
                         outerShape: RoundedRectangle(cornerRadius: showMore ? 35 : 65, style: .continuous),
                         innerPadding: showMore ? 10 : 20,
                         shadowReverse: false,
                         isOrigin: false)
                .onTapGesture(perform: tapAction)
        }
    }
    func tapAction() {
        withAnimation(.default) {
            showMore.toggle()
            if showMore {
                bottomType = .playinglist
            }else {
                bottomType = .playingStatus
            }
        }
        if !showMore {
            showComment = false
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
                    CommentListView(id: store.appState.playing.song?.id ?? 0)
//                        .offset(y: listType == 1 ? 0 : offset)
                        .transition(.move(edge: .bottom))
                        .animation(.default)
                }
            }
        }
    }
}
