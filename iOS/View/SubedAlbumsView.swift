//
//  AlbumSublistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/9.
//

import SwiftUI

struct SubedAlbumsView: View {
    @FetchRequest(entity: AlbumSub.entity(), sortDescriptors: []) var results: FetchedResults<AlbumSub>
    @State private var albumDetailId: Int64 = 0
    @State private var showAlbumDetail: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(
                destination: FetchedAlbumDetailView(id: albumDetailId),
                isActive: $showAlbumDetail,
                label: {EmptyView()})
            HStack {
                Text("收藏的专辑")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                Spacer()
                Text("\(results.count)收藏的专辑")
                    .foregroundColor(Color.secondTextColor)
            }
            .padding(.horizontal)
            ScrollView(Axis.Set.horizontal) {
                let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
                LazyHGrid(rows: rows) /*@START_MENU_TOKEN@*/{
                    ForEach(results) { item in
                        Button(action: {
                            albumDetailId = item.id
                            showAlbumDetail.toggle()
                        }, label: {
                            AlbumSubGridView(album: item)
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
        SubedAlbumsView()
    }
}
#endif

struct AlbumSubGridView: View {
    @ObservedObject var album: AlbumSub
    
    var body: some View {
        VStack(alignment: .leading) {
            NEUCoverView(url: album.picUrl, coverShape: .rectangle, size: .small)
                .padding()
            Group {
                Text(album.name ?? "")
                    .foregroundColor(Color.mainTextColor)
                    .lineLimit(1)
                    .frame(width: 110, alignment: .leading)
//                Text("\(viewModel.count) songs")
//                    .foregroundColor(Color.secondTextColor)
            }
            .padding(.leading)
        }
    }
}
