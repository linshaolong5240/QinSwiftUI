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
    
    var topLeftShadowColor: Color?
    var topLeftShadowRadius: CGFloat?
    var bottomRightShadowColor: Color?
    var bottomRightShadowRadius: CGFloat?
    
    let position: Position
    
    init(_ position: Position = .all) {
        self.position = position
    }
    
    init(topLeftShadowColor: Color? = nil,
         topLeftShadowRadius: CGFloat? = nil,
         bottomRightShadowColor: Color? = nil,
         bottomRightShadowRadius: CGFloat? = nil,
         position: Position = .all) {
        self.topLeftShadowColor = topLeftShadowColor
        self.topLeftShadowRadius = topLeftShadowRadius
        self.bottomRightShadowColor = bottomRightShadowColor
        self.bottomRightShadowRadius = bottomRightShadowRadius
        self.position = position
    }
    
    public func body(content: Content) -> some View {
        
        let neuTopLeftShadowColor: Color = neuTopLeftShadowColor(colorScheme)
        let neuTopLeftShadowRadius: CGFloat = neuTopLeftShadowRadius(colorScheme)
        
        let neuBottomRightShadowColor: Color = neuBottomRightShadowColor(colorScheme)
        let neuBottomRightShadowRadius: CGFloat = neuBottomRightShadowRadius(colorScheme)
        
        switch position {
        case .topLeading:
            content
                .shadow(color: topLeftShadowColor ?? neuTopLeftShadowColor,
                        radius: topLeftShadowRadius ?? neuTopLeftShadowRadius,
                        x: -(topLeftShadowRadius ?? neuTopLeftShadowRadius), y: -(topLeftShadowRadius ?? neuTopLeftShadowRadius))
        case .bottomTrailing:
            content
                .shadow(color: bottomRightShadowColor ?? neuBottomRightShadowColor, radius: bottomRightShadowRadius ?? neuBottomRightShadowRadius, x: bottomRightShadowRadius ?? neuBottomRightShadowRadius, y: bottomRightShadowRadius ?? neuBottomRightShadowRadius)
        case .all:
            content
                .shadow(color: topLeftShadowColor ?? neuTopLeftShadowColor,
                        radius: topLeftShadowRadius ?? neuTopLeftShadowRadius,
                        x: -(topLeftShadowRadius ?? neuTopLeftShadowRadius), y: -(topLeftShadowRadius ?? neuTopLeftShadowRadius))
                .shadow(color: bottomRightShadowColor ?? neuBottomRightShadowColor, radius: bottomRightShadowRadius ?? neuBottomRightShadowRadius, x: bottomRightShadowRadius ?? neuBottomRightShadowRadius, y: bottomRightShadowRadius ?? neuBottomRightShadowRadius)
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
