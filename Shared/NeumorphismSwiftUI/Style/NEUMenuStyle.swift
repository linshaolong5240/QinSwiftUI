//
//  NEUMenuStyle.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/10.
//

import SwiftUI

public struct NEUMenuStyle<S>: MenuStyle where S: Shape{
    let shape: S
    
    public func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .background(NEUMenuBackground(shape: shape))
    }
}

#if DEBUG
struct NEUMenuStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            Menu {
                Button("Open in Preview", action: {})
                Button("Save as PDF", action: {})
            } label: {
                QinSFView(systemName: "ellipsis")
            }
            .menuStyle(NEUMenuStyle(shape: Circle()))
        }
    }
}
#endif

fileprivate struct NEUMenuBackground<S: Shape>: View {
    @Environment(\.colorScheme) private var colorScheme

    let shape: S
    public var body: some View {
        let backgroundColors: [Color] = colorScheme == .light ? Color.lightBackgroundColors : Color.darkBackgroundColors
        let topLeftShadowColor: Color = colorScheme == .light ? .white : .white.opacity(0.11)
        let topLeftShadowRadius: CGFloat = colorScheme == .light ? 5: 10
        let bottomRightShadowColor: Color = colorScheme == .light ? .black.opacity(0.22) : .black.opacity(0.33)
        let bottomRightShadowRadius: CGFloat = colorScheme == .light ? 10: 10
        
        shape.fill(LinearGradient(gradient: Gradient(colors: backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing))
            .shadow(color: topLeftShadowColor, radius: topLeftShadowRadius, x: -topLeftShadowRadius, y: -topLeftShadowRadius)
            .shadow(color: bottomRightShadowColor, radius: bottomRightShadowRadius, x: bottomRightShadowRadius, y: bottomRightShadowRadius)
    }
}
