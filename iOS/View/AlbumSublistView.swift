//
//  AlbumSublistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/9.
//

import SwiftUI

struct AlbumSublistView: View {
    let albumSublist: [AlbumViewModel]
    
    private let rows: [GridItem] = [.init(.adaptive(minimum: 130))]
    
    @State private var album = AlbumViewModel()
    @State private var showAlbumDetail: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(
                destination: AlbumDetailView(album),
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
                            album = item
                            showAlbumDetail.toggle()
                        }, label: {
                            AlbumSubView(item)
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
        AlbumSublistView(albumSublist: [AlbumViewModel]())
    }
}
#endif

struct AlbumSubView: View {
    let viewModel: AlbumViewModel
    
    init(_ viewModel: AlbumViewModel) {
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
