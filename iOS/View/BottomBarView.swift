//
//  BottomBarView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/26.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    
    private var playing: AppState.Playing { store.appState.playing }
    
    var body: some View {
        ZStack {
            HStack {
                ZStack {
                    ProgressView(value: playing.loadPercent)
                        .progressViewStyle(NEURingProgressViewStyle())
                        .padding()
                        .frame(width: 90, height: 90)
                    Button(action: {
                        Store.shared.dispatch(.PlayerPlayOrPause)
                    }) {
                        NEUButtonView(systemName: player.isPlaying ? "pause" : "play.fill", size: .small, active: true)
                    }.buttonStyle(NEUButtonToggleStyle(isHighlighted: true, shadow: false, shape: Circle()))
                }
                NavigationLink(destination: PlayingNowView()) {
                    VStack(alignment: .leading) {
                        Text(playing.songDetail.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .foregroundColor(Color.mainTextColor)
                        HStack {
                            Text(playing.songDetail.artists)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .foregroundColor(Color.secondTextColor)
                            LyricView(isOneLine: true)
                            Spacer()
                        }
                    }
                }
                Spacer()
                Button(action: {
                    Store.shared.dispatch(.playForward)
                }) {
                    NEUButtonView(systemName: "forward.fill", size: .medium)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
            }
            .padding(.trailing)
        }
        .background(
            NEUBackgroundView()
        )
        .clipShape(Capsule())
    }
}
#if DEBUG
struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                Spacer()
                BottomBarView()
            }
        }
        .environmentObject(Store.shared)
        .environmentObject(Player.shared)
        .environment(\.colorScheme, .light)
        ZStack {
            NEUBackgroundView()
            VStack {
                Spacer()
                BottomBarView()
            }
        }
        .environmentObject(Store.shared)
        .environmentObject(Player.shared)
        .environment(\.colorScheme, .dark)
    }
}
#endif
