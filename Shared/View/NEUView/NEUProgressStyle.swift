//
//  NEUProgressViewStyle.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/13.
//

import SwiftUI

struct NEURingProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        NEURingProgressView(percent: configuration.fractionCompleted ?? 0)
    }
}

#if DEBUG
struct NEUProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            ProgressView(value: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/)
                .progressViewStyle(NEURingProgressViewStyle())
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
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
