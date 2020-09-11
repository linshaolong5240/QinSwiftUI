//
//  NEUProgressView.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/12.
//

import SwiftUI

#if DEBUG
struct NEUProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            NEURingProgressView(percent: 0.6)
                .frame(width: 90, height: 90, alignment: .center)
        }
        .environment(\.colorScheme, .light)

        ZStack {
            NEUBackgroundView()
            NEURingProgressView(percent: 0.6)
                .frame(width: 90, height: 90, alignment: .center)
        }
        .environment(\.colorScheme, .dark)
    }
}
#endif

struct NEURingProgressView: View {
    @Environment(\.colorScheme) var colorScheme
    let percent: Double
    
    var body: some View {
        if colorScheme == .light {
            NEULightRingProgressView(percent: percent)
        }else {
            NEUDarkRingProgressView(percent: percent)
        }
    }
}

struct NEULightRingProgressView: View {
    let percent: Double
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Circle()
                .stroke(Color(red: 209 / 255, green: 211 / 255, blue: 217 / 255), lineWidth: 5)
            Circle()
                .trim(from: CGFloat(1 - percent), to: 1)
                .stroke(
                    LinearGradient(.lightOrangeEnd, .lightOrangeMiddle, .lightOrangeStart),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(.degrees(90))
                .rotation3DEffect(.degrees(180), axis: (x: 10, y: 0, z: 0))
        }
        .shadow(color: Color.white, radius: 5, x: -5, y: -5)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
    }
}

struct NEUDarkRingProgressView: View {
    @Environment(\.colorScheme) var colorScheme

    let percent: Double
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Circle()
                .stroke(Color.white, lineWidth: 5)
            Circle()
                .trim(from: CGFloat(1 - percent), to: 1)
                .stroke(
                    LinearGradient(.darkOrangeEnd, .darkOrangeMiddle, .darkOrangeStart),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(.degrees(90))
                .rotation3DEffect(.degrees(180), axis: (x: 10, y: 0, z: 0))
        }
        .shadow(color: .darkBackgourdStart, radius: 5, x: -5, y: -5)
        .shadow(color: .darkBackgourdEnd, radius: 5, x: 5, y: 5)
    }
}
