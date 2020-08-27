//
//  SearchBarView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/8/12.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var store: Store
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var search: AppState.Search {store.appState.search}
    private var searchBinding: Binding<AppState.Search> {$store.appState.search}
    @State private var searchType: NeteaseCloudMusicApi.SearchType = .song
    
    var body: some View {
        let searchTypeBinding = Binding<NeteaseCloudMusicApi.SearchType>(get: {
            self.searchType
        }, set: {
            self.searchType = $0
            Store.shared.dispatch(.search(keyword: search.keyword, type: searchType))
        })

        return ZStack {
            BackgroundView()
            VStack {
                HStack(spacing: 20.0) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        Store.shared.dispatch(.searchClean)
                    }) {
                        NEUButtonView(systemName: "chevron.backward", size: .medium)
                    }
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                    HStack(spacing: 0.0) {
                        NEUButtonView(systemName: "magnifyingglass", size: .medium)
                        TextField("搜索", text: searchBinding.keyword, onCommit: {
                            store.dispatch(.search(keyword: search.keyword, type: searchType))
                        })
                    }
                    .background(SearchBarBackgroundView())
                }
                .padding()
                Picker(selection: searchTypeBinding, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) /*@START_MENU_TOKEN@*/{
                    Text("单曲").tag(NeteaseCloudMusicApi.SearchType.song)
                    Text("歌单").tag(NeteaseCloudMusicApi.SearchType.playlist)
                }/*@END_MENU_TOKEN@*/
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                if search.searchRequesting {
                    Text("正在搜索...")
                        .foregroundColor(.secondTextColor)
                }else {
                    switch searchType {
                    case .song:
                        SearchSongResultView()
                    case .playlist:
                        SearchPlaylistResultView()
                    default:
                        SearchSongResultView()
                    }
                }
                Spacer()
            }
            .onAppear{
                Store.shared.dispatch(.search(keyword: search.keyword))
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchPlaylistResultView: View {
    @EnvironmentObject var store: Store
    private var search: AppState.Search {store.appState.search}
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(search.playlists) { item in
                    NavigationLink(destination: PlaylistDetailView(item.id)) {
                        SearchPlaylistResultRowView(viewModel: item)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}
struct SearchPlaylistResultRowView: View {
    let viewModel: PlaylistViewModel
    
    var body: some View {
        HStack {
            NEUImageView(url: viewModel.coverImgUrl, size: .medium, innerShape: RoundedRectangle(cornerRadius: 25, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/), outerShape: RoundedRectangle(cornerRadius: 33, style: .continuous))
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .foregroundColor(Color.mainTextColor)
                Text("\(viewModel.count) songs")
                    .foregroundColor(Color.secondTextColor)
            }
            Spacer()
        }
    }
}
struct SearchSongResultView: View {
    @EnvironmentObject var store: Store
    
    private var playing: AppState.Playing {store.appState.playing}
    private var search: AppState.Search {store.appState.search}

    @State var showPlayingNow: Bool = false

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<search.songs.count, id: \.self) { index in
                    Button(action: {
                        Store.shared.dispatch(.setPlayinglist(playinglist: search.songs, index: index))
                        if search.songs[index].id != playing.songDetail.id {
                            Store.shared.dispatch(.playByIndex(index: index))
                        }else {
                            showPlayingNow.toggle()
                        }
                    }) {
                        PlaylistDetailRowView(viewModel: search.songs[index])
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

struct SearchBarBackgroundView: View {
    var body: some View {
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
    }
}

struct SearchBarView: View {
    @EnvironmentObject var store: Store
    private var search: AppState.Search {store.appState.search}
    private var searchBinding: Binding<AppState.Search> {$store.appState.search}
    @State private var showSearch: Bool = false

    var body: some View {
        VStack {
            NavigationLink(destination: SearchView(), isActive: $showSearch) {
                EmptyView()
            }
            HStack(spacing: 0.0) {
                NEUButtonView(systemName: "magnifyingglass", size: .medium)
                TextField("搜索", text: searchBinding.keyword, onCommit: {
                    if search.keyword.count > 0 {
                        showSearch = true
                    }
                })
            }
            .background(SearchBarBackgroundView())
        }
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
//        SearchView()
//            .environmentObject(Store.shared)
        SearchPlaylistResultRowView(viewModel: PlaylistViewModel())
            .padding(.horizontal)
    }
}
#endif
