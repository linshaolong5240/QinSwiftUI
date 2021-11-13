//
//  NEUMenuStyle.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/10.
//

import SwiftUI

public struct NEUMenuStyle<S>: MenuStyle, NEUStyle where S: Shape {
    
    @Environment(\.colorScheme) private var colorScheme

    let shape: S
    
    public func makeBody(configuration: Configuration) -> some View {
        let backgroundColors: [Color] = neuBacgroundColors(colorScheme)

        Menu(configuration)
            .background(
                shape.fill(LinearGradient(gradient: Gradient(colors: backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .modifier(NEUShadowModifier())
            )
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
