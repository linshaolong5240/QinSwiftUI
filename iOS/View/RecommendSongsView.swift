//
//  RecommendSongsView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/11/6.
//

import SwiftUI

struct RecommendSongsView: View {
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
//                CommonNavigationBarView(id: id, title: "歌单详情", type: .playlist)
//                    .padding(.horizontal)
//                PlaylistDetailView(playlist: playlist)
            }
            .navigationBarHidden(true)
        }
    }
}

struct RecommendSongsView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendSongsView()
    }
}
