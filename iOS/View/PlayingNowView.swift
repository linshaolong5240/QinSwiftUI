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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var playing: AppState.Playing { store.appState.playing }
    private var playingBing: Binding<AppState.Playing> {$store.appState.playing}
    private var playlists: AppState.Playlists {store.appState.playlists}
    private var settings: AppState.Settings {store.appState.settings}
    
    @State private var showMore: Bool = false
    @State private var showComment: Bool = false
    @State private var bottomType: PlayingNowBottomType = .playingStatus
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                if !showMore {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            NEUButtonView(systemName: "chevron.backward", size: .medium)
                        }
                        .buttonStyle(NEUButtonStyle(shape: Circle()))
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
                            NEUButtonView(systemName: "plus", size: .medium)
                        }
                        .buttonStyle(NEUButtonStyle(shape: Circle()))
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .top))
                }
                ZStack {
                    HStack {
                        NEUButtonView(systemName: "heart.fill", active: playing.like)
                            .background(
                                NEUToggleBackground(isHighlighted: playing.like, shape: Circle())
                            )
                            .offset(x: showMore ? 0 : -screen.width/4)
                            .transition(.move(edge: .trailing))
                            .onTapGesture {
                                Store.shared.dispatch(.like(id: playing.songDetail.id, like: playing.like ? false : true))
                            }
                        Spacer()
                        NEUButtonView(systemName: "text.bubble", active: showComment)
                            .background(
                                NEUToggleBackground(isHighlighted: showComment, shape: Circle())
                            )
                            .offset(x: showMore ? 0 : screen.width/4)
                            .transition(.move(edge: .leading))
                            .animation(.default)
                            .onTapGesture {
                                showComment.toggle()
                                withAnimation(.default) {
                                    if showComment {
                                        bottomType = .commentlist
                                    }else {
                                        bottomType = .playinglist
                                    }
                                }
                            }
                    }
                    .padding(.horizontal)
                    Button(action: {
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
                    }) {
                        NEUImageView(url: playing.songDetail.albumPicURL,
                                     size: !showMore ? .large: .medium,
                                     innerShape: RoundedRectangle(cornerRadius: !showMore ? 50 : 25, style: .continuous),
                                     outerShape: RoundedRectangle(cornerRadius: !showMore ? 66 : 33, style: .continuous), isOrigin: true)
                    }
                    if !showMore {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: settings.playMode == .playlist ? "repeat" : "repeat.1")
                                    .foregroundColor(Color.secondTextColor)
                                    .onTapGesture {
                                        Store.shared.dispatch(.playModeToggle)
                                    }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                ZStack {
                    PlayingNowStatusView()
                        .offset(y: bottomType == .playingStatus ? 0 : screen.height)
                        .transition(.move(edge: .bottom))
                    PlayinglistView(showList: $showMore)
                        .offset(y: bottomType == .playinglist ? 0 : screen.height)
                        .transition(.move(edge: .bottom))
                        .animation(.default)
                    CommentListView()
                        .offset(y: bottomType == .commentlist ? 0 : screen.height)
                        .transition(.move(edge: .bottom))
                        .animation(.default)
                    CreatedPlaylistView(showList: $showMore, bottomType: $bottomType)
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
            .environment(\.colorScheme, .light)
    }
}
#endif

struct LyricView: View {
    let lyric: String
    var body: some View {
        ScrollView {
            Text(lyric)
                .foregroundColor(.secondTextColor)
        }
    }
}

struct PlayinglistView: View {
    @EnvironmentObject var store: Store
    private var playing: AppState.Playing { store.appState.playing }
    @Binding var showList: Bool
    
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
                        Button(action: {
                            if self.playing.index != index {
                                Store.shared.dispatch(.playByIndex(index: index))
                            }else {
                                withAnimation(.default){
                                    showList = true
                                }
                            }
                        }) {
                            PlayingNowListRowView(viewModel: self.playing.playinglist[index], active: self.playing.playinglist[index].id == self.playing.songDetail.id ? true : false)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

struct PlayingNowListRowView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    
    let viewModel: SongViewModel
    let active: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.name)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.mainTextColor )
                        .lineLimit(1)
                    Text(viewModel.artists)
                        .foregroundColor(Color.secondTextColor)
                        .lineLimit(1)
                }
                .foregroundColor(active ? .white : Color.secondTextColor)
                Spacer()
                Button(action: {
                    if active {
                        Store.shared.dispatch(.togglePlay)
                    }else {
                        Store.shared.dispatch(.playRequest(id: self.viewModel.id))
                    }
                }) {
                    NEUButtonView(systemName: active && player.isPlaying ? "pause.fill" : "play.fill", size: .small, active: active)
                        .background(
                            NEUToggleBackground(isHighlighted: active, shadow: false, shape: Circle())
                        )
                }
                //                NEUCircleButtonView(systemName: active && player.isPlaying ? "pause.fill" : "play.fill",
                //                                    size: .small,
                //                                    active: active ?  true : false)
                //                    .onTapGesture{
                //                        if self.active {
                //                            Store.shared.dispatch(.togglePlay)
                //                        }else {
                //                            Store.shared.dispatch(.playRequest(id: self.viewModel.id))
                //                        }
                //                    }
            }
            .padding(10)
            .background(
                VStack {
                    if active {
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
struct PlayingNowStatusView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    
    private var playing: AppState.Playing { store.appState.playing }
    private var playingBinding: Binding<AppState.Playing> { $store.appState.playing }
    
    var body: some View {
        VStack {
            Text(playing.songDetail.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.mainTextColor)
                .lineLimit(1)
            Text(playing.songDetail.artists)
                .fontWeight(.bold)
                .foregroundColor(Color.secondTextColor)
                .lineLimit(1)
            Spacer()
            Text(playing.lyric)
                .fontWeight(.bold)
                .foregroundColor(.secondTextColor)
                .lineLimit(2)
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
                .buttonStyle(NEUButtonStyle(shape: Circle()))
                
                NEUButtonView(systemName: player.isPlaying ? "pause.fill" : "play.fill", size: .large, active: true)
                    .background(
                        NEUToggleBackground(isHighlighted: true, shape: Circle())
                    )
                    .onTapGesture {
                        Store.shared.dispatch(.togglePlay)
                    }
                
                Button(action: {
                    Store.shared.dispatch(.playForward)
                }) {
                    NEUButtonView(systemName: "forward.fill", size: .big)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
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
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    Store.shared.dispatch(.commentMusic(id: playing.songDetail.id))
                }
            }
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
            NEUImageView(url: viewModel.avatarUrl, size: .small, innerShape: RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/), outerShape: RoundedRectangle(cornerRadius: 15, style: .continuous))
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
    @EnvironmentObject var store: Store
    private var user: User? {store.appState.settings.loginUser}
    private var playing: AppState.Playing { store.appState.playing }
    private var playlists: AppState.Playlists {store.appState.playlists}
    
    @Binding var showList: Bool
    @Binding  var bottomType: PlayingNowBottomType

    @State private var showCreate: Bool = false
    @State private var name: String = ""
    
    var body: some View {
        ZStack {
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
                }
                .padding(.horizontal)
                ScrollView {
                    LazyVStack{
                        ForEach(playlists.userPlaylists.filter{$0.userId == user!.uid}){ item in
                            Button(action: {
                                Store.shared.dispatch(.playlistTracks(pid: item.id, op: true, ids: [self.playing.songDetail.id]))
                                withAnimation(.default){
                                    showList = false
                                    bottomType = .playingStatus
                                }
                            }) {
                                HStack {
                                    NEUImageView(url: item.coverImgUrl, size: .small, innerShape: RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/), outerShape: RoundedRectangle(cornerRadius: 15, style: .continuous))
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
            .offset(y: showCreate ? screen.height : 0)
            VStack {
                TextField("name", text: $name)
                    .autocapitalization(.none)
                    .keyboardType(.default)
                    .padding()
                Button(action: {
                    Store.shared.dispatch(.playlistCreate(name: self.name))
                    self.name = ""
                    self.showCreate.toggle()
                }) {
                    Text("添加")
                }
                Spacer()
            }
            .offset(y: showCreate ? 0 : screen.height)
        }
    }
}
