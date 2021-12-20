//
//  PlayingNowButtonView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/12/5.
//

import SwiftUI
import NeumorphismSwiftUI
import Kingfisher
import struct Kingfisher.DownsamplingImageProcessor

struct PlayingNowButtonView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var player: Player
    @State private var showPlayingNow: Bool = false
    
    var body: some View {
        HStack {
            NavigationLink(destination: PlayingNowView(), isActive: $showPlayingNow, label: {EmptyView()})
            Button(action: {
                showPlayingNow.toggle()
            }){
                if let url = store.appState.playing.song?.album?.coverURLString {
                    KFImage(URL(string: url))
//                      .placeholder(placeholderImage)
                      .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100)))
                      .fade(duration: 0.25)
                      .onProgress { receivedSize, totalSize in  }
                      .onSuccess { result in  }
                      .onFailure { error in }
                      .resizable()
                      .renderingMode(.original)
                      .aspectRatio(contentMode: .fill)
                      .mask(Circle())
                      .padding(3)
                      .rotationEffect(.degrees(player.loadTime))
                }else {
                    Image("PlaceholderImage")
                        .resizable()
                        .renderingMode(.original)
                        .aspectRatio(contentMode: .fill)
                        .mask(Circle())
                        .padding(3)
                }
            }
            .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
            .frame(width: 48, height: 48)
        }
    }
}

#if DEBUG
struct PlayingNowButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingNowButtonView()
            .environmentObject(Store.shared)
            .environmentObject(Player.shared)
    }
}
#endif
