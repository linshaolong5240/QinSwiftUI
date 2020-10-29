//
//  ArtistSublistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/8.
//

import SwiftUI

struct ArtistSublistView: View {
    @State private var artistId: Int64 = 0
    @State private var showArtistDetail: Bool = false
    private let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
    
    var body: some View {
        FetchedResultsView(entity: ArtistSub.entity()) { (results: FetchedResults<ArtistSub>) in
            VStack(spacing: 0) {
                NavigationLink(
                    destination: ArtistDetailView(id: artistId),
                    isActive: $showArtistDetail,
                    label: {EmptyView()})
                HStack {
                    Text("收藏的歌手")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.mainTextColor)
                    Spacer()
                    Text("\(results.count)收藏的歌手")
                        .foregroundColor(Color.secondTextColor)
                }
                .padding(.horizontal)
                ScrollView(Axis.Set.horizontal) {
                    let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
                    LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                        ForEach(results) { item in
                            Button(action: {
                                artistId = item.id
                                showArtistDetail.toggle()
                            }, label: {
                                CommonGridItemView(item )
                                    .padding(.vertical)
                            })
                        }
                    }/*@END_MENU_TOKEN@*/
                }
            }
        }
    }
}

#if DEBUG
struct ArtistSublistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistSublistView()
    }
}
#endif

struct ArtistView: View {
    let artist: Artist
    
    init(_ artist: Artist) {
        self.artist = artist
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            NEUCoverView(url: artist.img1v1Url ?? "", coverShape: .rectangle, size: .small)
                .padding()
            Group {
                Text(artist.name ?? "")
                    .foregroundColor(Color.mainTextColor)
                    .lineLimit(1)
                    .frame(width: 110, alignment: .leading)
            }
            .padding(.leading)
        }
    }
}
