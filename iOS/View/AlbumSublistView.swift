//
//  AlbumSublistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/9.
//

import SwiftUI

struct AlbumSublistView: View {
    let albumSublist: [AlbumSub]
    
    private let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
    
    @State private var albumDetailId: Int = 0
    @State private var showAlbumDetail: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(
                destination: AlbumDetailView(id: albumDetailId),
                isActive: $showAlbumDetail,
                label: {EmptyView()})
            HStack {
                Text("收藏的专辑")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                Spacer()
                Text("\(albumSublist.count)收藏的专辑")
                    .foregroundColor(Color.secondTextColor)
            }
            .padding(.horizontal)
            ScrollView(Axis.Set.horizontal) {
                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                    ForEach(albumSublist) { item in
                        Button(action: {
                            albumDetailId = item.id
                            showAlbumDetail.toggle()
                        }, label: {
                            AlbumSubView(album: item)
                                .padding(.vertical)
                        })
                    }
                }/*@END_MENU_TOKEN@*/
            }
        }
    }
}

#if DEBUG
struct AlbumSublistView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSublistView(albumSublist: [AlbumSub]())
    }
}
#endif

struct AlbumSubView: View {
    let album: AlbumSub
    
    var body: some View {
        VStack(alignment: .leading) {
            NEUCoverView(url: album.picUrl, coverShape: .rectangle, size: .small)
                .padding()
            Group {
                Text(album.name)
                    .foregroundColor(Color.mainTextColor)
                    .lineLimit(1)
                    .frame(width: 110, alignment: .leading)
            }
            .padding(.leading)
        }
    }
}
