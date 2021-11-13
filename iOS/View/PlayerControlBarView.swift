//
//  PlayerControlBarView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/26.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct PlayerControlBarView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var player: Player
    
    private var playing: AppState.Playing { store.appState.playing }

    private var backgroundColors: [Color] {
        colorScheme == .light ? [Color(#colorLiteral(red: 0.937254902, green: 0.9411764706, blue: 0.9529411765, alpha: 1)), Color(#colorLiteral(red: 0.9019607843, green: 0.9098039216, blue: 0.9254901961, alpha: 1)), Color(#colorLiteral(red: 0.8862745098, green: 0.8980392157, blue: 0.9137254902, alpha: 1))] : [Color(#colorLiteral(red: 0.2352941176, green: 0.2509803922, blue: 0.2666666667, alpha: 1)), Color(#colorLiteral(red: 0.1647058824, green: 0.1725490196, blue: 0.1882352941, alpha: 1)), Color(#colorLiteral(red: 0.09411764706, green: 0.1019607843, blue: 0.1098039216, alpha: 1))]
    }

    var body: some View {
        HStack {
            ZStack {
                ProgressView(value: player.loadPercent)
                    .progressViewStyle(NEURingProgressViewStyle())
                    .padding()
                    .frame(width: 90, height: 90)
                Button(action: {
                    Store.shared.dispatch(.playerPlayOrPause)
                }) {
                    QinSFView(systemName: player.isPlaying ? "pause" : "play.fill", size: .small, active: true)
                        .background(
                            NEUPlayButtonBackgroundView(shape: Circle(), shadow: false)
                        )
                }
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
                Store.shared.dispatch(.playerPlayForward)
            }) {
                QinSFView(systemName: "forward.fill", size: .medium)
            }
            .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
        }
        .padding(.trailing)
        .background(LinearGradient(gradient: Gradient(colors: backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing))
        .mask(Capsule())
    }
}
#if DEBUG
struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            QinBackgroundView()
            VStack {
                Spacer()
                PlayerControlBarView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .environmentObject(Store.shared)
        .environmentObject(Player.shared)
        .environment(\.colorScheme, .light)
        ZStack {
            QinBackgroundView()
            VStack {
                Spacer()
                PlayerControlBarView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .environmentObject(Store.shared)
        .environmentObject(Player.shared)
        .environment(\.colorScheme, .dark)
    }
}
#endif
