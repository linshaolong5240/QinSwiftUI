//
//  PlayingView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

enum PlayingNowBottomType {
    case commentlist
    case createdPlaylist
    case playinglist
    case playingStatus
}

struct PlayingNowView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    
    private var playing: AppState.Playing { store.appState.playing }
    private var playlists: AppState.Playlists {store.appState.playlist}
    @State private var showMore: Bool = false
    @State private var bottomType: PlayingNowBottomType = .playingStatus
    @State private var showComment: Bool = false
    @State private var showArtist: Bool = false
    @State private var artistId: Int64 = 0

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
                        Spacer()
                        NEUNavigationBarTitleView("PLAYING NOW")
                        Spacer()
                        Button(action: {
                            withAnimation(.default){
                                showMore = true
                                bottomType = .createdPlaylist
                            }
                        }) {
                            NEUSFView(systemName: "plus" , size:  .medium)
                        }
                        .buttonStyle(NEUButtonStyle(shape: Circle()))
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom))
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
                                NEUSFView(systemName: store.appState.playlist.likedIds.contains(playing.song?.id ?? 0) ? "heart.fill" : "heart", size: .medium, active: playing.songDetail.liked)
                            }
                            .buttonStyle(NEUButtonStyle(shape: Circle()))
                            Spacer()
                            Button(action: {
                                showComment.toggle()
                                if showComment {
                                    if store.appState.comment.id != playing.songDetail.id {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            Store.shared.dispatch(.commentMusic(id: playing.songDetail.id))
                                        }
                                    }
                                }
                                withAnimation(.default) {
                                    if showComment {
                                        bottomType = .commentlist
                                    }else {
                                        bottomType = .playinglist
                                    }
                                }
                            }) {
                                NEUSFView(systemName: showComment ? "text.bubble.fill" : "text.bubble", size: .medium, active: showComment)
                            }
                            .buttonStyle(NEUButtonStyle(shape: Circle()))
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
                    PlayingNowStatusView(showMore: $showMore, showArtist: $showArtist, artistId: $artistId)
                        .offset(y: bottomType == .playingStatus ? 0 : screen.height)
                        .transition(.move(edge: .bottom))
                    PlayinglistView(songsId: playing.playinglist)
                        .offset(y: bottomType == .playinglist ? 0 : screen.height)
                        .transition(.move(edge: .bottom))
//                    CommentListView(id: playing.songDetail.id)
//                        .offset(y: bottomType == .commentlist ? 0 : screen.height)
//                        .transition(.move(edge: .bottom))
                    //                    CreatedPlaylistView(playlists: playlists.createdPlaylist, songId: playing.songDetail.id, showList: $showMore, bottomType: $bottomType)
                    //                        .offset(y: bottomType == .createdPlaylist ? 0 : screen.height)
                    //                        .transition(.move(edge: .bottom))
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
        VStack {
            HStack {
                Text("播放列表\(songsId.count)首")
                    .foregroundColor(.mainTextColor)
                Spacer()
            }
            .padding(.horizontal)
            .onAppear {
                DispatchQueue.main.async {
                    show = true
                }
            }
            if show {
                FetchedResultsView(entity: Song.entity(), predicate: NSPredicate(format: "%K IN %@", "id", songsId)) { (results: FetchedResults<Song>) in
                    if let songs = results {
                        ScrollView {
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
    }
}

struct PlayingNowStatusView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var player: Player
    
    private var playing: AppState.Playing { store.appState.playing }
    private var playingBinding: Binding<AppState.Playing> { $store.appState.playing }

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
                if let artists = playing.song?.ar {
                    HStack {
                        ForEach(artists.map{SongDetailJSONModel.Artist(id: $0["id"] as! Int64, name: $0["name"] as? String)}) { item in
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
            Spacer()
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

struct CommentListView: View {
    @EnvironmentObject var store: Store
    private var comment: AppState.Comment { store.appState.comment }
    @State var editComment: String = ""
    
    let id: Int64
    
    var body: some View {
        VStack {
            HStack {
                Text("评论")
                    .font(.title)
                    .foregroundColor(.mainTextColor)
                TextField("编辑评论", text: $editComment)
                    .textFieldStyle(NEUTextFieldStyle(label: NEUSFView(systemName: "text.bubble", size: .small)))
                Button(action: {
                    hideKeyboard()
                    Store.shared.dispatch(.comment(id: id, content: editComment, type: .song, action: .add))
                    editComment = ""
                }) {
                    NEUSFView(systemName: "arrow.up.message", size: .small)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
            }
            .padding(.horizontal)
            if comment.commentMusicRequesting {
                Text("正在加载...")
                    .foregroundColor(.mainTextColor)
                Spacer()
            }else {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("热门评论(\(String(comment.hotComments.count)))")
                            .foregroundColor(.mainTextColor)
                        ForEach(comment.hotComments) { item in
                            CommentRowView(viewModel: item, id: id, type: .song)
                            Divider()
                        }
                        Text("最新评论(\(String(comment.total)))")
                            .foregroundColor(.mainTextColor)
                        ForEach(comment.comments) { item in
                            CommentRowView(viewModel: item, id: id, type: .song)
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                    if comment.comments.count < comment.total {
                        Button(action: {
                            Store.shared.dispatch(.commentMusicLoadMore)
                        }, label: {
                            Text("加载更多")
                        })
                    }
                    Spacer()
                        .frame(height: 20)
                }
            }
        }
    }
}

struct CommentRowView: View {
    @EnvironmentObject var store: Store
    private var user: User? {store.appState.settings.loginUser}

    @StateObject var viewModel: CommentViewModel
    let id: Int64
    let type: NeteaseCloudMusicApi.CommentType
    
    @State var showBeReplied = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            NEUCoverView(url: viewModel.avatarUrl, coverShape: .rectangle, size: .little)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(viewModel.nickname)
                    Spacer()
                    Text(String(viewModel.likedCount))
                    Button(action: {
                        Store.shared.dispatch(.commentLike(id: id, cid:viewModel.commentId, like: viewModel.liked ? false : true, type: type))
                        viewModel.liked.toggle()
                    }, label: {
                        Image(systemName: viewModel.liked ? "hand.thumbsup.fill" : "hand.thumbsup")
                    })
                }
                .foregroundColor(.secondTextColor)
                Text(viewModel.content)
                    .foregroundColor(.mainTextColor)
                HStack {
                    if viewModel.beReplied.count > 0 {
                        Button(action: {
                            showBeReplied.toggle()
                        }, label: {
                            HStack(spacing: 0.0) {
                                Text("\(viewModel.beReplied.count)条回复")
                                Image(systemName: showBeReplied ? "chevron.down" : "chevron.up")
                            }
                        })
                    }
                    Spacer()
                    if viewModel.userId == user?.uid {
                        Button(action: {
                            Store.shared.dispatch(.comment(id: id, cid: viewModel.commentId, type: type, action: .delete))
                        }, label: {
                            Text("删除")
                        })
                    }
                }
                if showBeReplied {
                    ForEach(viewModel.beReplied) { item in
                        CommentRowView(viewModel: item, id: id, type: type)
                    }
                }
            }
        }
    }
}

struct CreatedPlaylistView: View {
//    @EnvironmentObject var store: Store
//    private var playing: AppState.Playing { store.appState.playing }
//    private var playlists: AppState.Playlists {store.appState.playlist}
//
    let playlists: [PlaylistViewModel]
    let songId: Int64
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
                    ForEach(playlists){ item in
                        Button(action: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                Store.shared.dispatch(.playlistTracks(pid: item.id, op: true, ids: [songId]))
                            }
                            withAnimation(.default){
                                showList = false
                                bottomType = .playingStatus
                            }
                        }) {
                            HStack {
                                NEUCoverView(url: item.coverImgUrl, coverShape: .rectangle, size: .little)
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .foregroundColor(.mainTextColor)
                                    Text("\(item.count) songs")
                                        .foregroundColor(.secondTextColor)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct PlayingExtensionControllView: View {
    @EnvironmentObject var store: Store

    private var settings: AppState.Settings {store.appState.settings}

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
    private var settings: AppState.Settings {store.appState.settings}
    
    @Binding var showMore: Bool
    @Binding var bottomType: PlayingNowBottomType
    @Binding var showComment: Bool

    var body: some View {
        switch settings.coverShape {
        case .circle:
            NEUImageView(url: playing.songDetail.albumPicURL,
                         size: !showMore ? .large: .medium,
                         innerShape: Circle(),
                         outerShape: Circle(),
                         innerPadding: showMore ? (screen.width * 0.3 / 16) : (screen.width * 0.7 / 24),
                         shadowReverse: true,
                         isOrigin: true)
                .onTapGesture(perform: tapAction)
        case .rectangle:
            NEUImageView(url: playing.songDetail.albumPicURL,
                         size: showMore ? .medium: .large,
                         innerShape: RoundedRectangle(cornerRadius: showMore ? 25 : 50, style: .continuous),
                         outerShape: RoundedRectangle(cornerRadius: showMore ? 35 : 65, style: .continuous),
                         innerPadding: showMore ? (screen.width * 0.3 / 12) : (screen.width * 0.7 / 16),
                         shadowReverse: false,
                         isOrigin: true)
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
