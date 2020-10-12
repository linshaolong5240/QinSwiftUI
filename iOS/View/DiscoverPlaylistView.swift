//
//  DiscoverPlaylistView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/10/12.
//

import SwiftUI

struct DiscoverPlaylistView: View {
    @EnvironmentObject private var store: Store
    private var viewModel: DiscoverPlaylistViewModel {store.appState.playlist.discoverPlaylistViewModel}
    private var viewModeBindingl: Binding<DiscoverPlaylistViewModel> {$store.appState.playlist.discoverPlaylistViewModel}

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
                .onAppear {
                    Store.shared.dispatch(.playlist(category: viewModel.subcategory))
                }
                    if showCategories {
                        Picker(selection: viewModeBindingl.category, label: Text("")) /*@START_MENU_TOKEN@*/{
                            ForEach(viewModel.categories) { item in
                                Text("\(item.name)").tag(item.id)
                            }
                        }/*@END_MENU_TOKEN@*/
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .onChange(of: viewModel.category, perform: { [viewModel] value in
                            if value == viewModel.categories.last?.id {
                                Store.shared.dispatch(.playlist(category: viewModel.categories.last!.name))
                            }
                        })
                        if viewModel.category != viewModel.categories.last?.id && viewModel.categories.count > 0 {
                            MultilineHStack(viewModel.categories[viewModel.category].subCategories) { item in
                                Button(action: {
                                    Store.shared.dispatch(.playlist(category: item))
                                }, label: {
                                    Text(item)
                                        .foregroundColor(item == viewModel.subcategory ? Color.white : Color.black)
                                        .padding(.horizontal)
                                        .background(Color.orange)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                })
                            }
                            .padding(.horizontal)
                        }
                    }

                    if viewModel.playlistRequesting {
                        Text("Loading")
                        Spacer()
                    }else {
                        DiscoverPlaylistsView(data: viewModel.playlists)
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
