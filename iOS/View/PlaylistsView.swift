//
//  HomeView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/29.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct PlaylistsView: View {
    @EnvironmentObject var store: Store
    
    let title: String
    let data: [PlaylistViewModel]
        
    var body: some View {
        VStack(spacing: 0.0) {
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.mainTextColor)
                Spacer()
                Text("\(data.count) \(title)")
                    .foregroundColor(Color.secondTextColor)
            }
            .padding(.horizontal)
            ScrollView(Axis.Set.horizontal, showsIndicators: true) {
                HStack(alignment: .top) {
                    ForEach(data) { item in
                        NavigationLink(destination: PlaylistDetailView(item.id)) {
                            PlaylistView(viewModel: item)
                                .padding(20)
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
let playlistsData = (1...10).map{_ in
   PlaylistViewModel()
}
struct PlaylistsView_Previews: PreviewProvider {

    static var previews: some View {
        ZStack {
            BackgroundView()
            VStack {
                PlaylistsView(title: "test", data: playlistsData)
                    .environmentObject(Store.shared)
//                PlaylistView(viewModel: PlaylistViewModel())
//                Spacer()
            }
        }
    }
}
#endif

struct PlaylistView: View {
    let viewModel: PlaylistViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            NEUImageView(url: viewModel.coverImgUrl, size: .medium, innerShape: RoundedRectangle(cornerRadius: 25, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/), outerShape: RoundedRectangle(cornerRadius: 33, style: .continuous))
            Text(viewModel.name)
                .foregroundColor(Color.mainTextColor)
                .lineLimit(2)
                .frame(width: 120, alignment: .leading)
            Text("\(viewModel.count) songs")
                .foregroundColor(Color.secondTextColor)
        }
    }
}
