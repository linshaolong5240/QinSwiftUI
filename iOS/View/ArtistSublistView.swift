//
//  ArtistSublistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/8.
//

import SwiftUI

struct ArtistSublistView: View {
    @FetchRequest(entity: Artist.entity(), sortDescriptors: [], predicate: nil) var artists: FetchedResults<Artist>

    let artistSublist: [ArtistViewModel]
    
    @State private var artist = Artist()
    @State private var showArtistDetail: Bool = false
    private let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(
                destination: ArtistDetailView(artist),
                isActive: $showArtistDetail,
                label: {EmptyView()})
            HStack {
                Text("收藏的歌手")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                Spacer()
                Text("\(artistSublist.count)收藏的歌手")
                    .foregroundColor(Color.secondTextColor)
            }
            .padding(.horizontal)
            ScrollView(Axis.Set.horizontal) {
                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                    ForEach(artists) { item in
                        Button(action: {
                            artist = item
                            showArtistDetail.toggle()
                        }, label: {
                            ArtistView(item)
                                .padding(.vertical)
                        })
                    }
                }/*@END_MENU_TOKEN@*/
            }
//            ScrollView(Axis.Set.horizontal) {
//                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
//                    ForEach(artistSublist) { item in
//                        Button(action: {
//                            artist = item
//                            showArtistDetail.toggle()
//                        }, label: {
//                            ArtistView(item)
//                                .padding(.vertical)
//                        })
//                    }
//                }/*@END_MENU_TOKEN@*/
//            }
        }
    }
}

#if DEBUG
struct ArtistSublistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistSublistView(artistSublist: [ArtistViewModel]())
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
            NEUCoverView(url: artist.picUrl ?? "", coverShape: .rectangle, size: .small)
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
