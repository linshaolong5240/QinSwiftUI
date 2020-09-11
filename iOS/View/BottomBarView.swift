//
//  BottomBarView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/26.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct BottomBarView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var store: Store
    @EnvironmentObject var player: Player
    
    private var playing: AppState.Playing { store.appState.playing }
    
    var body: some View {
        ZStack {
            HStack {
                ZStack {
                    NEURingProgressView(percent: playing.loadPercent)
                        .padding()
                        .frame(width: 90, height: 90)
                    NEUButtonView(systemName: player.isPlaying ? "pause" : "play.fill", size: .small, active: true)
                        .background(
                            NEUToggleBackground(isHighlighted: true, shadow: false, shape: Circle())
                        )
                        .onTapGesture {
                            Store.shared.dispatch(.PlayerPlayOrPause)
                        }
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
                            Text(playing.lyric)
                                .foregroundColor(.secondTextColor)
                                .lineLimit(1)
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
            //            ZStack {
            //                if colorScheme == .light {
            //                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),Color("BGC3")]), startPoint: .topLeading, endPoint: .bottomTrailing)
            //                }
            //                else {
            //                    BackgroundView()
            //                }
            //            }
            //            .shadow(radius: 10)
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
