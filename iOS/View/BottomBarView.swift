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
                    ProgressView(value: player.loadPercent)
                        .progressViewStyle(NEURingProgressViewStyle())
                        .padding()
                        .frame(width: 90, height: 90)
                    Button(action: {
                        Store.shared.dispatch(.PlayerPlayOrPause)
                    }) {
                        NEUSFView(systemName: player.isPlaying ? "pause" : "play.fill", size: .small, active: true)
                    }.buttonStyle(NEUButtonToggleStyle(isHighlighted: true, shadow: false, shape: Circle()))
                }
                NavigationLink(destination: PlayingNowView()) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(playing.song?.name ?? "")
                                .font(.title)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .foregroundColor(Color.mainTextColor)
                            HStack {
                                if let artists = playing.song?.artists {
                                    HStack {
                                        ForEach(Array(artists as! Set<Artist>)) { item in
                                            Text(item.name ?? "")
                                                .fontWeight(.bold)
                                                .lineLimit(1)
                                                .foregroundColor(Color.secondTextColor)
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                }
                Button(action: {
                    Store.shared.dispatch(.PlayerPlayForward)
                }) {
                    NEUSFView(systemName: "forward.fill", size: .medium)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
            }
            .padding(.trailing)
        }
        .background(
            NEUBackgroundView()
        )
        .mask(Capsule())
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
