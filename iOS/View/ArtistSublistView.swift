//
//  ArtistSublistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/8.
//

import SwiftUI
import NeteaseCloudMusicAPI

struct ArtistSublistView: View {
    let artists: [NCMArtistSublistResponse.Artist]
    @State private var artistId: Int = 0
    @State private var showArtistDetail: Bool = false
    private let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(
                destination: FetchedArtistDetailView(id: artistId),
                isActive: $showArtistDetail,
                label: {EmptyView()})
            HStack {
                Text("收藏的歌手")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainText)
                Spacer()
                Text("\(artists.count)收藏的歌手")
                    .foregroundColor(Color.secondTextColor)
            }
            .padding(.horizontal)
            ScrollView(Axis.Set.horizontal) {
                let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                    ForEach(artists) { item in
                        Button(action: {
                            artistId = Int(item.id)
                            showArtistDetail.toggle()
                        }, label: {
                            CommonGridItemView(item)
                                .padding(.vertical)
                        })
                    }
                }/*@END_MENU_TOKEN@*/
            }
        }
    }
}

#if DEBUG
struct ArtistSublistView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistSublistView(artists: [NCMArtistSublistResponse.Artist]())
    }
}
#endif
