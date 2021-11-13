//
//  SearchBarView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/8/12.
//

import SwiftUI

extension SearchPlaylistResponse.Result.Playlist: Identifiable {
    
}

extension SearchSongResponse.Result.Song: Identifiable {
    
}

struct SearchView: View {
    @EnvironmentObject var store: Store
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var search: AppState.Search {store.appState.search}
    private var searchBinding: Binding<AppState.Search> {$store.appState.search}
    @State private var searchType: SearchType = .song
    @State private var showCancel = false
    
    var body: some View {
        ZStack {
            QinBackgroundView()
            VStack {
                HStack {
                    QinBackwardButton()
                    TextField("搜索", text: searchBinding.keyword,
                              onEditingChanged: { isEditing in
                                if showCancel != isEditing {
                                    showCancel = isEditing
                                }
                              },
                              onCommit: {
                                store.dispatch(.searchRequest(keyword: search.keyword, type: searchType))
                              })
                        .textFieldStyle(NEUDefaultTextFieldStyle(label: QinSFView(systemName: "magnifyingglass", size: .medium)))
                    if showCancel {
                        Button(action: {
                            hideKeyboard()
                        }, label: {
                            Text("取消")
                        })
                    }
                }
                .padding(.horizontal)
                Picker(selection: $searchType, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) /*@START_MENU_TOKEN@*/{
                    Text("单曲").tag(SearchType.song)
                    Text("歌单").tag(SearchType.playlist)
                }/*@END_MENU_TOKEN@*/
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: searchType, perform: { value in
                    Store.shared.dispatch(.searchRequest(keyword: search.keyword, type: value))
                })
                if search.searchRequesting {
                    Text("正在搜索...")
                        .foregroundColor(.secondTextColor)
                    Spacer()
                }else {
                    switch searchType {
                    case .song:
                        SearchSongResultView(songsId: search.songsId.map(Int64.init))
                    case .playlist:
                        SearchPlaylistResultView(playlists: search.result.playlists)
                    default:
                        Spacer()
                    }
                }
            }
            .onAppear {
                Store.shared.dispatch(.searchRequest(keyword: search.keyword))
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchPlaylistResultView: View {
    let playlists: [SearchPlaylistResponse.Result.Playlist]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(playlists) { item in
                    NavigationLink(destination: FetchedPlaylistDetailView(id: Int(item.id))) {
                        SearchPlaylistResultRowView(viewModel: item)
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct SearchPlaylistResultRowView: View {
    let viewModel: SearchPlaylistResponse.Result.Playlist
    
    var body: some View {
        HStack(alignment: .top) {
            NEUCoverView(url: viewModel.coverImgUrl, coverShape: .rectangle, size: .little)
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .foregroundColor(Color.mainText)
                Text("\(viewModel.trackCount) songs")
                    .foregroundColor(Color.secondTextColor)
            }
            Spacer()
        }
    }
}

struct SearchSongResultView: View {
    let songsId: [Int64]
    
    var body: some View {
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

struct SearchBarView: View {
    @EnvironmentObject var store: Store
    private var search: AppState.Search { store.appState.search }
    private var searchBinding: Binding<AppState.Search> { $store.appState.search }
    @State private var showSearch: Bool = false
    @State private var showCancel = false

    var body: some View {
        VStack {
            NavigationLink(destination: SearchView(), isActive: $showSearch) {
                EmptyView()
            }
            HStack {
                TextField("搜索",
                          text: searchBinding.keyword,
                          onEditingChanged: { isEditing in
                            if showCancel != isEditing {
                                showCancel = isEditing
                            }
                          },
                          onCommit: {
                            if search.keyword.count > 0 {
                                showSearch = true
                            }
                          })
                .textFieldStyle(NEUDefaultTextFieldStyle(label: QinSFView(systemName: "magnifyingglass", size: .medium)))
                .foregroundColor(.mainText)
                if showCancel {
                    Button(action: {
                        Store.shared.appState.search.keyword = ""
                        self.hideKeyboard()
                    }, label: {
                        Text("取消")
                    })
                }
            }
        }
    }
}

#if DEBUG
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            QinBackgroundView()
            SearchView()
                .environmentObject(Store.shared)
        }
        
//        SearchPlaylistResultRowView(viewModel: PlaylistViewModel())
//            .padding(.horizontal)
    }
}
#endif
