//
//  AlbumSublistView.swift
//  Qin
//
//  Created by 林少龙 on 2020/10/9.
//

import SwiftUI

struct AlbumSublistView: View {
    @State private var albumDetailId: Int64 = 0
    @State private var showAlbumDetail: Bool = false
    
    var body: some View {
        FetchedResultsView(entity: AlbumSub.entity()) { (results: FetchedResults<AlbumSub>) in
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
                                GridItemView(item )
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
struct AlbumSublistView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumSublistView()
    }
}
#endif
