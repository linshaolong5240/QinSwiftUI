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
    private var playing: AppState.Playing {store.appState.playing}

    @State var showPlayingNow: Bool = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack(spacing: 20.0) {
                    NEUCircleButtonView(systemName: "chevron.backward", size: .medium, active: false)
                        .onTapGesture{
                            presentationMode.wrappedValue.dismiss()
                        }
                    SearchBarView()
                }
                .padding(.horizontal)
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
                Spacer()
            }
            .onAppear{
                if search.keyword.count > 0 {
                    Store.shared.dispatch(.search(keyword: search.keyword))
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(Store.shared)
    }
}

struct SearchBarView: View {
    @EnvironmentObject var store: Store
    private var keyword: String {store.appState.search.keyword}
    private var keywordBinding: Binding<String> {$store.appState.search.keyword}
    @State var showSearch: Bool = false

    var body: some View {
        VStack {
            NavigationLink(destination: SearchView(), isActive: $showSearch) {
                EmptyView()
            }
            TextField("搜索", text: keywordBinding, onCommit: {
                showSearch.toggle()
            })
            .padding(10)
            .background(
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
        )
        }
    }
}
