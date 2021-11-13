//
//  NEUDivider.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/11.
//

import SwiftUI

public struct NEUDivider: View {
    @Environment(\.colorScheme) private var colorScheme

    public var body: some View {
        let topShadowColor: Color = colorScheme == .light ? Color.white : Color.darkBackgourdStart
        let topShadowRadius: CGFloat = 3
        let topShadowOffset: CGPoint = .init(x: 0, y: -2)
        let bottomShadowColor: Color = colorScheme == .light ?  Color.black.opacity(0.2) : Color.darkBackgourdEnd
        let bottomShadowRadius: CGFloat = 3
        let bottomShadowOffset: CGPoint = .init(x: 0, y: 2)
        ZStack {
            colorScheme == .light ?  Color.lightBackgourdStart : Color.darkBackgourdStart
        }
        .frame(height: 2)
        .shadow(color: topShadowColor, radius: topShadowRadius, x: topShadowOffset.x, y: topShadowOffset.y)
        .shadow(color: bottomShadowColor, radius: bottomShadowRadius, x: bottomShadowOffset.x, y: bottomShadowOffset.y)
    }
}

#if DEBUG
struct NEUDivider_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            NEUDivider()
        }
        .preferredColorScheme(.light)
        ZStack {
            NEUBackgroundView()
            NEUDivider()
        }
        .preferredColorScheme(.dark)
    }
}
#endif
