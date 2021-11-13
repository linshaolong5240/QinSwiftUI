//
//  NEUShadowModifier.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/14.
//

import SwiftUI

public struct NEUShadowModifier: ViewModifier, NEUStyle {
    
    @Environment(\.colorScheme) private var colorScheme
    
    public func body(content: Content) -> some View {
        let topLeftShadowColor: Color = neuTopLeftShadowColor(colorScheme)
        let topLeftShadowRadius: CGFloat = neuTopLeftShadowRadius(colorScheme)
        
        let bottomRightShadowColor: Color = neuBottomRightShadowColor(colorScheme)
        let bottomRightShadowRadius: CGFloat = neuBottomRightShadowRadius(colorScheme)

        content
            .shadow(color: topLeftShadowColor,
                    radius: topLeftShadowRadius,
                    x: -topLeftShadowRadius, y: -topLeftShadowRadius)
            .shadow(color: bottomRightShadowColor, radius: bottomRightShadowRadius, x: bottomRightShadowRadius, y: bottomRightShadowRadius)
    }
}

#if DEBUG
fileprivate struct NEUShadowModifierDEBUGView: View, NEUStyle {
    
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let orangeColors: [Color] = neuOrangeColors(colorScheme)
        
        ZStack {
            NEUBackgroundView()
            Capsule()
                .fill(LinearGradient(gradient: Gradient(colors: orangeColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 30)
                .modifier(NEUShadowModifier())
            .padding()
        }
    }
}

struct NEUShadowModifier_Previews: PreviewProvider {
    static var previews: some View {
        NEUShadowModifierDEBUGView()
            .preferredColorScheme(.light)
        NEUShadowModifierDEBUGView()
            .preferredColorScheme(.dark)
    }
}
#endif
