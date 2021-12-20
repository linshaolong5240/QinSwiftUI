//
//  QinSearchBarView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/8/12.
//

import SwiftUI
import NeumorphismSwiftUI
import Combine

extension SearchPlaylistResponse.Result.Playlist: Identifiable {
    
}

extension NCMSearchSongResponse.Result.Song: Identifiable {
    
}

struct QinSearchView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: SearchViewModel
    
    @State private var searchType: NCMSearchType = .song
    @State private var showCancell = false
    
    var body: some View {
        ZStack {
            QinBackgroundView()
            VStack {
                HStack {
                    QinBackwardButton()
                    TextField("搜索",
                              text: $viewModel.key,
                              onEditingChanged: { isEditing in
                        showCancell = isEditing
                    },
                              onCommit: { viewModel.search() })
                        .textFieldStyle(NEUDefaultTextFieldStyle(label: Image(systemName: "magnifyingglass").foregroundColor(.mainText)))
                    if showCancell {
                        Button(action: {
                            hideKeyboard()
                        }, label: {
                            Text("取消")
                        })
                    }
                }
                .padding(.horizontal)
                Picker(selection: $viewModel.type, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) /*@START_MENU_TOKEN@*/{
                    Text("单曲").tag(NCMSearchType.song)
                    Text("歌单").tag(NCMSearchType.playlist)
                }/*@END_MENU_TOKEN@*/
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if viewModel.requesting {
                    Text("正在搜索...")
                        .foregroundColor(.secondTextColor)
                    Spacer()
                }else {
                    switch searchType {
                    case .song:
                        EmptyView()
//                        SearchSongResultView(songsId: search.songsId.map(Int64.init))
                    case .playlist:
                        EmptyView()
//                        SearchPlaylistResultView(playlists: search.result.playlists)
                    default:
                        Spacer()
                    }
                }
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
            .padding(.vertical)
        }
    }
}

struct SearchPlaylistResultRowView: View {
    let viewModel: SearchPlaylistResponse.Result.Playlist
    
    var body: some View {
        HStack(alignment: .top) {
            QinCoverView(viewModel.coverImgUrl, style: QinCoverStyle(size: .little, shape: .rectangle))
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
                    .padding(.vertical)
                }
            }
        }
    }
}

struct QinSearchBarView: View {
    @ObservedObject var viewModel = SearchViewModel()
    @State private var key: String = ""
    @State private var showSearch: Bool = false
    @State private var showCancel = false

    var body: some View {
        VStack {
            NavigationLink(destination: QinSearchView(viewModel: viewModel), isActive: $showSearch) {
                EmptyView()
            }
            HStack {
                TextField("搜索",
                          text: $key,
                          onEditingChanged: { isEditing in showCancel = isEditing
                          },
                          onCommit: {
                            if !key.isEmpty {
                                showSearch = true
                            }
                          })
                    .textFieldStyle(NEUDefaultTextFieldStyle(label: Image(systemName: "magnifyingglass").foregroundColor(.mainText)))
                if showCancel {
                    Button(action: {
                        key = ""
                        hideKeyboard()
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
            QinSearchView(viewModel: SearchViewModel())
                .environmentObject(Store.shared)
        }
        
//        SearchPlaylistResultRowView(viewModel: PlaylistViewModel())
//            .padding(.horizontal)
    }
}
#endif
