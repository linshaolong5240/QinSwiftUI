//
//  NEUButtonStyle.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/10.
//

import SwiftUI

public protocol NEUButtonStyle: ButtonStyle, NEUStyle {
    func neuBacgroundColors(_ colorScheme: ColorScheme) -> [Color]
    func neuPressedBacgroundColors(_ colorScheme: ColorScheme) -> [Color]
}

extension NEUButtonStyle {
    public func neuBacgroundColors(_ colorScheme: ColorScheme) -> [Color] {
        colorScheme == .light ? Color.lightBackgroundColors : Color.darkBackgroundColors
    }
    
    public func neuPressedBacgroundColors(_ colorScheme: ColorScheme) -> [Color] {
        (colorScheme == .light ? Color.lightBackgroundColors : Color.darkBackgroundColors).reversed()
    }
}

public struct NEUDefaultButtonStyle<S: Shape>: NEUButtonStyle {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let shape: S
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .contentShape(shape)
            .background(
                GeometryReader { geometry in
                    let backgroundColors: [Color] = neuBacgroundColors(colorScheme)
                    let pressedBackgroundColors: [Color] = neuPressedBacgroundColors(colorScheme)
                    
                    let topLeftShadowColor: Color = neuTopLeftShadowColor(colorScheme)
                    let bottomRightShadowColor: Color = neuBottomRightShadowColor(colorScheme)

                    let topLeftShadowRadius: CGFloat = neuTopLeftShadowRadius(colorScheme)
                    let bottomRightShadowRadius: CGFloat = neuBottomRightShadowRadius(colorScheme)

                    if configuration.isPressed {
                        shape.fill(                            LinearGradient(gradient: Gradient(colors: pressedBackgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                    }else {
                        shape.fill(LinearGradient(gradient: Gradient(colors: backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(color: topLeftShadowColor, radius: topLeftShadowRadius, x: -topLeftShadowRadius, y: -topLeftShadowRadius)
                            .shadow(color: bottomRightShadowColor, radius: bottomRightShadowRadius, x: bottomRightShadowRadius, y: bottomRightShadowRadius)
                    }
                }
            )
    }
}

public struct NEUUnevennessButtonStyle<S: Shape>: NEUButtonStyle {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let shape: S

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .contentShape(shape)
            .background(
                GeometryReader { geometry in
                    let minLength: CGFloat = min(geometry.size.width, geometry.size.height)
                    let padding: CGFloat = minLength / 15.0

                    let backgroundColors: [Color] = colorScheme == .light ? Color.lightBackgroundColors : Color.darkBackgroundColors
                    let pressedBackgroundColors: [Color] = backgroundColors.reversed()

                    let topLeftShadowColor: Color = neuTopLeftShadowColor(colorScheme)
                    let bottomRightShadowColor: Color = neuBottomRightShadowColor(colorScheme)
                    
                    let topLeftShadowRadius: CGFloat = neuTopLeftShadowRadius(colorScheme)
                    let bottomRightShadowRadius: CGFloat = neuBottomRightShadowRadius(colorScheme)
                    
                    shape
                        .fill(LinearGradient(gradient: Gradient(colors: pressedBackgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: topLeftShadowColor,
                                radius: topLeftShadowRadius, x: -topLeftShadowRadius, y: -topLeftShadowRadius)
                        .shadow(color: bottomRightShadowColor, radius: bottomRightShadowRadius, x: bottomRightShadowRadius, y: bottomRightShadowRadius)
                    if !configuration.isPressed {
                        shape
                            .fill(LinearGradient(gradient: Gradient(colors: backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .padding(padding)
                    }
                }
            )
    }
}

public struct NEUConvexBorderButtonStyle<S: Shape>: NEUButtonStyle {

    @Environment(\.colorScheme) private var colorScheme

    let shape: S
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .contentShape(shape)
            .background(
                GeometryReader { geometry in
                    let minLength: CGFloat = min(geometry.size.width, geometry.size.height)

                    let backgroundColors: [Color] = colorScheme == .light ? Color.lightBackgroundColors : Color.darkBackgroundColors

                    let topLeftShadowColor: Color = neuTopLeftShadowColor(colorScheme)
                    let bottomRightShadowColor: Color = neuBottomRightShadowColor(colorScheme)
                    
                    let topLeftShadowRadius: CGFloat = neuTopLeftShadowRadius(colorScheme)
                    let bottomRightShadowRadius: CGFloat = neuBottomRightShadowRadius(colorScheme)
                    
                    let borderColors: [Color] = colorScheme == .light ? [Color( red: 245 / 255, green: 245 / 255, blue: 245 / 255), Color( red: 225 / 255, green: 230 / 255, blue: 235 / 255), Color( red: 210 / 255, green: 215 / 255, blue: 220 / 255)] : [Color( red: 33 / 255, green: 37 / 255, blue: 42 / 255), Color( red: 22 / 255, green: 24 / 255, blue: 26 / 255)]
                    let borderStrokeWidth: CGFloat = minLength / 15

                    let strokeWidth: CGFloat = minLength / 40
                    let topLeftStrokeColor: Color = colorScheme == .light ? .white : .white.opacity(0.11)
                    let bottomRightStokeColor: Color = colorScheme == .light ? .black.opacity(0.22) : .black

                    shape.fill(LinearGradient(colors: backgroundColors, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: topLeftShadowColor, radius: topLeftShadowRadius, x: -topLeftShadowRadius, y: -topLeftShadowRadius)
                        .shadow(color: bottomRightShadowColor, radius: bottomRightShadowRadius, x: bottomRightShadowRadius, y: bottomRightShadowRadius)
                    shape.stroke(LinearGradient(colors: borderColors, startPoint: .topLeading, endPoint: .bottomTrailing),
                                 lineWidth: borderStrokeWidth)
                    if !configuration.isPressed {
                        shape.stroke(topLeftStrokeColor, lineWidth: strokeWidth)
                            .blur(radius: 1)
                            .offset(x: strokeWidth, y: strokeWidth)
                            .mask(shape)
                        shape.stroke(bottomRightStokeColor, lineWidth: strokeWidth)
                            .blur(radius: 1)
                            .offset(x: -strokeWidth, y: -strokeWidth)
                            .mask(shape)
                    }
                }
            )
    }
}

#if DEBUG
fileprivate struct NEUButtonStyleDebugView: View {
    @State private var vibrateOnRing = false
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack(spacing: 50.0) {
                Button(action: {
                    print("pressed")
                }) {
                    QinSFView(systemName: "heart.fill", size: .medium)
                }
                .buttonStyle(NEUUnevennessButtonStyle(shape: Circle()))
                Button(action: {
                    print("pressed")
                }) {
                    QinSFView(systemName: "heart.fill", size: .medium)
                }
                .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
                Button(action: {
                    print("pressed")
                }) {
                    QinSFView(systemName: "heart.fill", size: .medium)
                }
                .buttonStyle(NEUDefaultButtonStyle(shape: RoundedRectangle(cornerRadius: 10, style: .continuous)))
                Button(action: {
                    print("pressed")
                }) {
                    QinSFView(systemName: "heart.fill", size: .medium)
                }
                .buttonStyle(NEUConvexBorderButtonStyle(shape: Circle()))
                Button(action: {
                    print("pressed")
                }) {
                    QinSFView(systemName: "heart.fill", size: .medium)
                }
                .buttonStyle(NEUConvexBorderButtonStyle(shape: RoundedRectangle(cornerRadius: 10, style: .continuous)))
            }
        }
    }
}

struct NEUButtonStyle_Previews: PreviewProvider {

    static var previews: some View {
        NEUButtonStyleDebugView()
            .preferredColorScheme(.light)
        NEUButtonStyleDebugView()
            .preferredColorScheme(.dark)
    }
}
#endif
