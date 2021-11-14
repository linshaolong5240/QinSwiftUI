//
//  NEUBorderModifier.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/14.
//

import SwiftUI

public enum NEUBorderStyle{
    case concave
    case convex
    case convexFlat
    case unevenness
}

public struct NEUBorderModifier<S>: ViewModifier, NEUStyle where S: Shape {

    @Environment(\.colorScheme) private var colorScheme

    let shape: S
    var borderWidth: CGFloat?
    let style: NEUBorderStyle
    
    init(shape: S, borderWidth: CGFloat? = nil, style: NEUBorderStyle = .unevenness) {
        self.shape = shape
        self.borderWidth = borderWidth
        self.style = style
    }

    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            let neuBorderColors: [Color] = neuBorderColors(colorScheme)
            let neuBorderWidth = borderWidth ?? geometry.size.minLength / 15
            let topLeftStrokeColor: Color = colorScheme == .light ? .white : .white.opacity(0.33)
            let topLeftstrokeWidth: CGFloat = geometry.size.minLength / 18

            switch style {
            case .concave:
                content
                    .mask(shape)
                shape.stroke(LinearGradient(gradient: Gradient(colors: neuBorderColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: neuBorderWidth)
            case .convex:
                ZStack {
                    content
                        .mask(shape)
                        .modifier(NEUShadowModifier())
                    shape.stroke(LinearGradient(gradient: Gradient(colors: neuBorderColors), startPoint: .topLeading, endPoint: .bottomTrailing), style: .init(lineWidth: neuBorderWidth))
                    shape.stroke(topLeftStrokeColor, lineWidth: topLeftstrokeWidth)
                        .blur(radius: 1)
                        .offset(x: topLeftstrokeWidth / 2, y: topLeftstrokeWidth / 2)
                        .mask(shape.padding(neuBorderWidth / 2))
                }
            case .convexFlat:
                ZStack {
                    content
                        .mask(shape)
                        .modifier(NEUShadowModifier())
                    shape.stroke(LinearGradient(gradient: Gradient(colors: neuBorderColors), startPoint: .topLeading, endPoint: .bottomTrailing), style: .init(lineWidth: neuBorderWidth))
                }
            case .unevenness:
                ZStack {
                    content
                        .mask(shape)
                        .modifier(NEUShadowModifier())
                    shape.stroke(LinearGradient(gradient: Gradient(colors: neuBorderColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing), style: .init(lineWidth: neuBorderWidth))
                }
            }
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
                HStack(spacing: 30) {
                    LinearGradient(gradient: Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .modifier(NEUBorderModifier(shape: Capsule(), style: .concave))
                        .frame(width: 50, height: 50)
                    LinearGradient(gradient: Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .modifier(NEUBorderModifier(shape: Capsule(), style: .convexFlat))
                        .frame(width: 50, height: 50)
                    LinearGradient(gradient: Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .modifier(NEUBorderModifier(shape: Capsule(), style: .convex))
                        .frame(width: 50, height: 50)
                    LinearGradient(gradient: Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .modifier(NEUBorderModifier(shape: Capsule(), style: .unevenness))
                        .frame(width: 50, height: 50)
                }
                HStack(spacing: 30) {
                    LinearGradient(gradient: Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), style: .concave))
                        .frame(width: 50, height: 50)
                    LinearGradient(gradient: Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), style: .convexFlat))
                        .frame(width: 50, height: 50)
                    LinearGradient(gradient: Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), style: .convex))
                        .frame(width: 50, height: 50)
                    LinearGradient(gradient: Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), style: .unevenness))
                        .frame(width: 50, height: 50)
                }
                LinearGradient(gradient: Gradient(colors: orangeColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), style: .concave))
                    .frame(height: 30)
                LinearGradient(gradient: Gradient(colors: orangeColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), style: .convex))
                    .frame(height: 30)
                LinearGradient(gradient: Gradient(colors: orangeColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), style: .convexFlat))
                    .frame(height: 30)
                LinearGradient(gradient: Gradient(colors: orangeColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .modifier(NEUBorderModifier(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), style: .unevenness))
                    .frame(height: 30)
                Spacer()
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
