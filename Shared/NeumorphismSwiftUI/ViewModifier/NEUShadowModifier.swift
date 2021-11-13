//
//  NEUShadowModifier.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/14.
//

import SwiftUI

public struct NEUShadowModifier: ViewModifier, NEUStyle {
    
    enum Position {
        case topLeading
        case bottomTrailing
        case all
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    let position: Position
    
    init(_ position: Position = .all) {
        self.position = position
    }
    
    public func body(content: Content) -> some View {
        let topLeftShadowColor: Color = neuTopLeftShadowColor(colorScheme)
        let topLeftShadowRadius: CGFloat = neuTopLeftShadowRadius(colorScheme)
        
        let bottomRightShadowColor: Color = neuBottomRightShadowColor(colorScheme)
        let bottomRightShadowRadius: CGFloat = neuBottomRightShadowRadius(colorScheme)
        
        switch position {
        case .topLeading:
            content
                .shadow(color: topLeftShadowColor,
                        radius: topLeftShadowRadius,
                        x: -topLeftShadowRadius, y: -topLeftShadowRadius)
        case .bottomTrailing:
            content
                .shadow(color: bottomRightShadowColor, radius: bottomRightShadowRadius, x: bottomRightShadowRadius, y: bottomRightShadowRadius)
        case .all:
            content
                .shadow(color: topLeftShadowColor,
                        radius: topLeftShadowRadius,
                        x: -topLeftShadowRadius, y: -topLeftShadowRadius)
                .shadow(color: bottomRightShadowColor, radius: bottomRightShadowRadius, x: bottomRightShadowRadius, y: bottomRightShadowRadius)
        }
    }
}

#if DEBUG
fileprivate struct NEUShadowModifierDEBUGView: View, NEUStyle {
    
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let orangeColors: [Color] = neuOrangeColors(colorScheme)
        
        ZStack {
            NEUBackgroundView()
            VStack(spacing: 30) {
                Capsule()
                    .fill(LinearGradient(gradient: Gradient(colors: orangeColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 30)
                    .modifier(NEUShadowModifier())
            }
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
