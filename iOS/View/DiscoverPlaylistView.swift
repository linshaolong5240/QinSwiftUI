//
//  DiscoverPlaylistView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/10/12.
//

import SwiftUI

struct DiscoverPlaylistView: View {
    @EnvironmentObject private var store: Store
    private var playlist: AppState.Playlist {store.appState.playlist}
    
    @State private var categories: Int = 0
    @State private var showCategories: Bool = true
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                    Text("发现歌单")
                        .fontWeight(.bold)
                        .foregroundColor(.mainTextColor)
                    Spacer()
                    Button(action: {
                        showCategories.toggle()
                    }, label: {
                        NEUSFView(systemName: "square.grid.2x2")
                    })
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                .padding(.horizontal)
                .onAppear(perform: {
                    Store.shared.dispatch(.playlistCategories)
                })
                if playlist.categoriesRequesting == true {
                    Text("Loading")
                    Spacer()
                }
                else {
                    if showCategories {
                        Picker(selection: $categories, label: Text("")) /*@START_MENU_TOKEN@*/{
                            ForEach(playlist.categories) { item in
                                Text("\(item.name)").tag(item.id)
                            }
                        }/*@END_MENU_TOKEN@*/
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .onAppear(perform: {
                            categories = playlist.categories.last?.id ?? 0
                        })
                        if categories != playlist.categories.last?.id && playlist.categories.count > 0 {
                            MultilineHStack(playlist.categories[categories].subCategories) { item in
                                Button(action: {
                                    Store.shared.dispatch(.playlist(cat: item))
                                }, label: {
                                    Text(item)
                                        .foregroundColor(.black)
                                        .padding(.horizontal)
                                        .background(Color.orange)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                })
                            }
                            .padding(.horizontal)
                        }
                    }

                    if playlist.playlistRequesting {
                        Text("Loading")
                        Spacer()
                    }else {
                        DiscoverPlaylistsView(data: playlist.playlists)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct DiscoverPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverPlaylistView()
    }
}
#endif

struct DiscoverPlaylistsView: View {
    let data: [PlaylistViewModel]
    
    private let columns: [GridItem] = [.init(.adaptive(minimum: 130))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) /*@START_MENU_TOKEN@*/{
                ForEach(data) { item in
                    NavigationLink(destination: PlaylistDetailView(id: item.id, type: .subable)) {
                        PlaylistColumnView(item)
                    }
                }
            }/*@END_MENU_TOKEN@*/
        }
    }
}
