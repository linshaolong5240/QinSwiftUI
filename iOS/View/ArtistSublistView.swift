//
//  ArtistSublistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/8.
//

import SwiftUI

struct ArtistSublistView: View {
    let artistSublist: [ArtistSublist]
    
    private let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
    var body: some View {
        VStack {
            HStack {
                Text("收藏的歌手")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                Spacer()
                Text("\(artistSublist.count)收藏的歌手")
                    .foregroundColor(Color.secondTextColor)
            }
            ScrollView(Axis.Set.horizontal) {
                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                    ForEach(artistSublist) { item in
                        NavigationLink(destination: ArtistDetailView(id: item.id)) {
                            ArtistView(artist: item)
                        }
                    }
                }/*@END_MENU_TOKEN@*/
            }
        }
    }
}

#if DEBUG
struct ArtistSublistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistSublistView(artistSublist: [ArtistSublist]())
    }
}
#endif

struct ArtistView: View {
    let artist: ArtistSublist
    
    var body: some View {
        VStack(alignment: .leading) {
            NEUCoverView(url: artist.picUrl, coverShape: .rectangle, size: .small)
                .padding()
            Group {
                Text(artist.name)
                    .foregroundColor(Color.mainTextColor)
                    .lineLimit(1)
                    .frame(width: 110, alignment: .leading)
            }
            .padding(.leading)
        }
    }
}
