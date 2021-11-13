//
//  NEUBorderModifier.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/14.
//

import SwiftUI

public struct NEUBorderModifier<S>: ViewModifier, NEUStyle where S: Shape {
    
    @Environment(\.colorScheme) private var colorScheme

    let shape: S

    public func body(content: Content) -> some View {
        let backgroundColors: [Color] = neuBacgroundColors(colorScheme).reversed()
        
        GeometryReader { geometry in
            let borderWidth: CGFloat = geometry.size.minLength / 10
            content
                .mask(shape)
                .modifier(NEUShadowModifier())
            shape.stroke(LinearGradient(gradient: Gradient(colors: backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing), style: .init(lineWidth: borderWidth))
        }
    }
}


#if DEBUG
fileprivate struct NEUBorderModifierDEBUGView: View, NEUStyle {
    
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let orangeColors: [Color] = neuOrangeColors(colorScheme)
        
        ZStack {
            NEUBackgroundView()
            VStack(spacing: 30) {
                LinearGradient(gradient: Gradient(colors: orangeColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .modifier(NEUBorderModifier(shape: Capsule()))
                    .frame(height: 30)
                
                LinearGradient(gradient: Gradient(colors: orangeColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: 10, style: .continuous)))
                    .frame(height: 30)

            }
            .padding()
        }
    }
}

struct NEUBorderModifier_Previews: PreviewProvider {
    static var previews: some View {
        NEUBorderModifierDEBUGView()
            .preferredColorScheme(.light)
        NEUBorderModifierDEBUGView()
            .preferredColorScheme(.dark)
    }
}
#endif
