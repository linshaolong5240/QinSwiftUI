//
//  NEUProgressViewStyle.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/13.
//

import SwiftUI

public struct NEURingProgressViewStyle: ProgressViewStyle {
    public func makeBody(configuration: Configuration) -> some View {
        NEURingProgressView(percent: configuration.fractionCompleted ?? 0)
    }
}

#if DEBUG
struct NEUProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            ProgressView(value: 0.7)
                .progressViewStyle(NEURingProgressViewStyle())
                .frame(width: 100, height: 100, alignment: .center)
        }
        .preferredColorScheme(.light)

        ZStack {
            NEUBackgroundView()
            ProgressView(value: 0.7)
                .progressViewStyle(NEURingProgressViewStyle())
                .frame(width: 100, height: 100, alignment: .center)
        }
        .preferredColorScheme(.dark)
    }
}
#endif

struct NEURingProgressView: View {
    @Environment(\.colorScheme) private var colorScheme
    let percent: Double
    
    var body: some View {
        let bottomColor: Color = Color(#colorLiteral(red: 0.8532857299, green: 0.883516252, blue: 1, alpha: 1))
        let colors: [Color] = colorScheme == .light ? [.lightOrangeEnd, .lightOrangeMiddle, .lightOrangeStart] : [.lightOrangeEnd, .lightOrangeMiddle, .lightOrangeStart]
        let topLeftShadowColor: Color = colorScheme == .light ? .white : .darkBackgourdStart
        let bottomRightShadowColor: Color = colorScheme == .light ?.black.opacity(0.2) : .darkBackgourdEnd
        ZStack {
            Circle()
                .stroke(bottomColor, lineWidth: 5)
            Circle()
                .trim(from: CGFloat(1 - percent), to: 1)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(.degrees(90))
                .rotation3DEffect(.degrees(180), axis: (x: 10, y: 0, z: 0))
        }
        .shadow(color: topLeftShadowColor, radius: 5, x: -5, y: -5)
        .shadow(color: bottomRightShadowColor, radius: 5, x: 5, y: 5)
    }
}
