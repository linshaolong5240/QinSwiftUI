//
//  DiscoverView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/10/10.
//

import SwiftUI

struct DiscoverView: View {
    enum DiscoverType: String, CaseIterable {
        case album = "专辑", artist = "歌手", playlist = "歌单"
    }

    @State private var discoverType: DiscoverType = .playlist
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                HStack {
                    NEUBackwardButton()
                    Spacer()
                    NEUNavigationBarTitleView("发现")
                    Spacer()
                    Button(action: {}, label: {
                        NEUSFView(systemName: "ellipsis")
                    })
                    .buttonStyle(NEUButtonStyle(shape: Circle()))
                }
                .padding(.horizontal)

                Picker(selection: $discoverType, label: Text("")) /*@START_MENU_TOKEN@*/{
                    ForEach(DiscoverType.allCases, id: \.self) { item in
                        Text("\(item.rawValue)").tag(item)
                    }
                }/*@END_MENU_TOKEN@*/
                .pickerStyle(SegmentedPickerStyle())
//                DiscoverPlaylistView(viewModel: <#DiscoverPlaylistViewModel#>)
            }
        }
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
#endif
