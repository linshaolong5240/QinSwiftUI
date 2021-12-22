//
//  PlayerControlBarView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/26.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI
import NeumorphismSwiftUI

struct PlayerControlBarView: View, NEUStyle {
    
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var player: Player
    
    private var playing: AppState.Playing { store.appState.playing }

    var body: some View {
        let backgroundColors: [Color] = neuBacgroundColors(colorScheme)
        let borderColors: [Color] = neuBorderColors(colorScheme)

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
                            .foregroundColor(Color.mainText)
                        HStack {
                            HStack {
                                ForEach(playing.song?.artists ?? []) { item in
                                    Text(item.name ?? "")
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .foregroundColor(Color.secondTextColor)
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
        .background(
            VStack(spacing: 0) {
                LinearGradient(gradient: Gradient(colors: borderColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 6)
                LinearGradient(gradient: Gradient(colors: backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing)
            }
        )
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
