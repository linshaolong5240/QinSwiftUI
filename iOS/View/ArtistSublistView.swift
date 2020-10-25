//
//  ArtistSublistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/8.
//

import SwiftUI

struct ArtistSublistView: View {
    let artistSublist: [ArtistViewModel]
    
    @State private var artist = ArtistViewModel()
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
                    ForEach(artistSublist) { item in
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
    let viewModel: ArtistViewModel
    
    init(_ viewModel: ArtistViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            NEUCoverView(url: viewModel.coverUrl, coverShape: .rectangle, size: .small)
                .padding()
            Group {
                Text(viewModel.name)
                    .foregroundColor(Color.mainTextColor)
                    .lineLimit(1)
                    .frame(width: 110, alignment: .leading)
            }
            .padding(.leading)
        }
    }
}
