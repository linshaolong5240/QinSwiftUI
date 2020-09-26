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
    private var playingBing: Binding<AppState.Playing> {$store.appState.playing}
    private var playlists: AppState.Playlists {store.appState.playlists}

    @State private var showMore: Bool = false
    @State private var bottomType: PlayingNowBottomType = .playingStatus
    @State private var showComment: Bool = false

    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                if !showMore {
                    HStack {
                        NEUBackwardButton()
                        Spacer()
                        Text("PLAYING NOW")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.mainTextColor)
                        Spacer()
                        Button(action: {
                            withAnimation(.default){
                                showMore = true
                                bottomType = .createdPlaylist
                            }
                        }) {
                            NEUButtonView(systemName: "plus" , size:  .medium)
                        }
                        .buttonStyle(NEUButtonStyle(shape: Circle()))
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .top))
                }
                ZStack {
                    HStack {
                        Button(action: {
                            Store.shared.dispatch(.like(id: playing.songDetail.id, like: playing.like ? false : true))
                        }) {
                            NEUButtonView(systemName: playing.like ? "heart.fill" : "heart", size: .medium, active: playing.like)

                        }
                        .buttonStyle(NEUButtonToggleStyle(isHighlighted: playing.like, shape: Circle()))
                        .offset(x: showMore ? 0 : -screen.width/4)
                        .transition(.move(edge: .trailing))
                        Spacer()
                        Button(action: {
                            showComment.toggle()
                            if showComment {
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                                    Store.shared.dispatch(.commentMusic(id: playing.songDetail.id))
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
                            NEUButtonView(systemName: showComment ? "text.bubble.fill" : "text.bubble", size: .medium, active: showComment)
                        }
                        .buttonStyle(NEUButtonToggleStyle(isHighlighted: showComment, shape: Circle()))
                        .offset(x: showMore ? 0 : screen.width/4)
                        .transition(.move(edge: .leading))
                    }
                    .padding(.horizontal)
                    PlayingNowCoverView(showMore: $showMore, bottomType: $bottomType, showComment: $showComment)
                    HStack {
                        Spacer()
                        if !showMore {
                            PlayingExtensionControllView()
                        }
                    }
                }
                ZStack {
                    PlayingNowStatusView()
                        .offset(y: bottomType == .playingStatus ? 0 : screen.height)
                        .transition(.move(edge: .bottom))
                    PlayinglistView(showList: $showMore, bottomType: $bottomType)
                        .offset(y: bottomType == .playinglist ? 0 : screen.height)
                        .transition(.move(edge: .bottom))
                    CommentListView()
                        .offset(y: bottomType == .commentlist ? 0 : screen.height)
                        .transition(.move(edge: .bottom))
                    CreatedPlaylistView(playlists: playlists.createdPlaylist, songId: playing.songDetail.id, showList: $showMore, bottomType: $bottomType)
                        .offset(y: bottomType == .createdPlaylist ? 0 : screen.height)
                        .transition(.move(edge: .bottom))
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
            .environment(\.colorScheme, .dark)
    }
}
#endif

struct LyricView: View {
    @EnvironmentObject var store: Store
    
    private var viewModel: LyricViewModel { store.appState.lyric.lyric }
    let isOneLine: Bool

    var body: some View {
        VStack {
            if isOneLine {
                Text(viewModel.lyric)
                    .fontWeight(.bold)
                    .foregroundColor(.secondTextColor)
                    .lineLimit(1)
            }else {
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(0..<viewModel.lyricParser.lyrics.count, id: \.self) { index in
                            Text(viewModel.lyricParser.lyrics[index])
                                .fontWeight(index == viewModel.index ? .bold : .none)
                                .foregroundColor(index == viewModel.index ? .orange : .secondTextColor)
                                .lineLimit(1)
                                .id(index)
                        }
                    }
                    .onReceive(viewModel.$index, perform: { value in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(value, anchor: .center)
                        }
                    })
                }
            }
        }
    }
}

struct PlayinglistView: View {
    @EnvironmentObject var store: Store
    private var playing: AppState.Playing { store.appState.playing }
    @Binding var showList: Bool
    @Binding var bottomType: PlayingNowBottomType

    var body: some View {
        VStack {
            HStack {
                Text("播放列表")
                    .font(.title)
                    .foregroundColor(.secondTextColor)
                Spacer()
            }
            .padding(.horizontal)
            ScrollView {
                LazyVStack {
                    ForEach(0 ..< playing.playinglist.count, id: \.self) { index in
                        SongRowView(viewModel: playing.playinglist[index], index: index, action: {
                            if self.playing.index != index {
                                Store.shared.dispatch(.playByIndex(index: index))
                            }else {
                                Store.shared.dispatch(.PlayerPlayOrPause)
                            }
                        })
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if playing.index != index {
                                Store.shared.dispatch(.playByIndex(index: index))
                            }else {
                                withAnimation(.default){
                                    showList = false
                                    bottomType = .playingStatus
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct PlayingNowStatusView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    
    private var playing: AppState.Playing { store.appState.playing }
    private var playingBinding: Binding<AppState.Playing> { $store.appState.playing }
    
    var body: some View {
        VStack {
            VStack {
                Text(playing.songDetail.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundColor(Color.mainTextColor)
                Text(playing.songDetail.artists)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundColor(Color.secondTextColor)
            }
            .padding()
            Spacer()
            LyricView(isOneLine: false)
            Spacer()
            HStack {
                Text(String(format: "%02d:%02d", Int(playing.loadTime/60),Int(playing.loadTime)%60))
                    .frame(width: 50, alignment: Alignment.leading)
                Slider(value: playingBinding.loadTime, in: 0...(playing.totalTime > 0 ? playing.totalTime : 1.0), onEditingChanged: { (isEdit) in
                    Store.shared.dispatch(.seek(isSeeking: isEdit)
                    )
                })
                .accentColor(Color(colorScheme == .light ? #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) ))
                .modifier(NEUShadow())
                Text(playing.totalTimeLabel)
                    .frame(width: 50, alignment: Alignment.trailing)
            }
            .font(.system(size: 13))
            .foregroundColor(Color.secondTextColor)
            HStack(spacing: 20) {
                Button(action: {
                    Store.shared.dispatch(.playBackward)
                }) {
                    NEUButtonView(systemName: "backward.fill", size: .big)
                }
                .buttonStyle(NEUBigButtonStyle(shape: Circle()))
                
                NEUButtonView(systemName: player.isPlaying ? "pause.fill" : "play.fill", size: .large, active: true)
                    .background(
                        NEUToggleBackground(isHighlighted: true, shape: Circle())
                    )
                    .onTapGesture {
                        Store.shared.dispatch(.PlayerPlayOrPause)
                    }
                
                Button(action: {
                    Store.shared.dispatch(.playForward)
                }) {
                    NEUButtonView(systemName: "forward.fill", size: .big)
                }
                .buttonStyle(NEUBigButtonStyle(shape: Circle()))
            }
            .padding(.vertical)
        }
    }
}

struct CommentListView: View {
    @EnvironmentObject var store: Store
    private var playing: AppState.Playing { store.appState.playing }
    
    var body: some View {
        VStack {
            HStack {
                Text("评论")
                    .font(.title)
                    .foregroundColor(.secondTextColor)
                Spacer()
                Button(action: {
                    
                }) {
                    NEUButtonView(systemName: "square.and.pencil", size: .small)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
            }
            .padding(.horizontal)
            if playing.commentRequesting {
                Text("正在加载...")
                    .foregroundColor(.secondTextColor)
            }else {
                ScrollView {
                    VStack {
                        ForEach(playing.hotComments) { item in
                            CommentRowView(item)
                                .padding(.horizontal)
                            Divider()
                        }
                        ForEach(playing.comments) { item in
                            CommentRowView(item)
                                .padding(.horizontal)
                            Divider()
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct CommentRowView: View {
    let viewModel: CommentViewModel
    
    init(_ viewModel: CommentViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        HStack(alignment: .top) {
            NEUCoverView(url: viewModel.avatarUrl, coverShape: .rectangle, size: .small)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(viewModel.nickname)
                    Spacer()
                    Text(String(viewModel.likedCount))
                    Image(systemName: viewModel.liked ? "hand.thumbsup.fill" : "hand.thumbsup")
                }
                .foregroundColor(.secondTextColor)
                Text(viewModel.content)
                    .foregroundColor(.mainTextColor)
            }
            Spacer()
        }
    }
}

struct CreatedPlaylistView: View {
//    @EnvironmentObject var store: Store
//    private var playing: AppState.Playing { store.appState.playing }
//    private var playlists: AppState.Playlists {store.appState.playlists}
//
    let playlists: [PlaylistViewModel]
    let songId: Int
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
                    NEUButtonView(systemName: "rectangle.stack.badge.plus", size: .small)
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
                            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                                Store.shared.dispatch(.playlistTracks(pid: item.id, op: true, ids: [songId]))
                            }
                            withAnimation(.default){
                                showList = false
                                bottomType = .playingStatus
                            }
                        }) {
                            HStack {
                                NEUCoverView(url: item.coverImgUrl, coverShape: .rectangle, size: .small)
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
                NEUButtonView(systemName: settings.coverShape.systemName, size: .small, inactiveColor: Color.secondTextColor)
            }
            
            Button(action: {
                Store.shared.dispatch(.playMode)
            }) {
                NEUButtonView(systemName: settings.playMode.systemName, size: .small, inactiveColor: Color.secondTextColor)
            }
        }
        .foregroundColor(Color.secondTextColor)
        .padding(.horizontal)
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
