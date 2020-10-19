//
//  NEUButtonStyle.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/8/15.
//

import SwiftUI

struct NEUButtonBackground<S: Shape>: View {
    @Environment(\.colorScheme) var colorScheme

    var isHighlighted: Bool

    let shape: S
    var body: some View {
        if colorScheme == .light {
            NEULightButtonBackground(isHighlighted: isHighlighted, shape: shape)
        }else {
            NEUDarkButtonBackground(isHighlighted: isHighlighted, shape: shape)
        }
    }
}

struct NEUButtonBackground2<S: Shape>: View {
    @Environment(\.colorScheme) var colorScheme

    var isHighlighted: Bool

    let shape: S
    var body: some View {
        if colorScheme == .light {
            NEULightButtonBackground(isHighlighted: isHighlighted, shape: shape)
        }else {
            NEUDarkButtonBackground2(isHighlighted: isHighlighted, shape: shape)
        }
    }
}

struct NEULightButtonBackground<S: Shape>: View {
    var isHighlighted: Bool
    let shape: S
    var body: some View {
        ZStack {
            if isHighlighted {
                shape.fill(LinearGradient(Color.lightBackgourdEnd, Color.white))
                    .overlay(
                        shape
                            .stroke(Color.gray.opacity(0.2), lineWidth: 4)
                            .blur(radius: 4)
                            .offset(x: 2, y: 2)
//                            .mask(shape.fill(LinearGradient(Color.black, Color.clear)))
                    )
                    .overlay(
                        shape
                            .stroke(Color.white.opacity(0.2), lineWidth: 8)
                            .blur(radius: 4)
                            .offset(x: -2, y: -2)
//                            .mask(shape.fill(LinearGradient(Color.clear, Color.black)))
                    )
            }else {
                shape.fill(LinearGradient(Color.white, Color.lightBackgourdEnd))
//                    .mask(shape.fill(LinearGradient(Color.white, Color.white.opacity(0.9))))
                    .shadow(color: Color.white, radius: 5, x: -5, y: -5)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct NEUDarkButtonBackground<S: Shape>: View {
    private let darkStart = Color( red: 47 / 255, green: 53 / 255, blue: 58 / 255)
    private let darkMiddle = Color( red: 34 / 255, green: 37 / 255, blue: 41 / 255)
    private let darkEnd = Color(red: 28 / 255, green: 30 / 255, blue: 34 / 255)
    
    var isHighlighted: Bool
    let shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape.fill(LinearGradient(Color.darkBackgourdEnd, Color.darkBackgourdStart))
                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -10, y: -10)
                    .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
                    .overlay(
                        shape.fill(LinearGradient(darkEnd, darkMiddle, darkStart))
                            .padding(3)
                    )
            }else {
                shape.fill(LinearGradient(Color.darkBackgourdEnd, Color.darkBackgourdStart))
                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -10, y: -10)
                    .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
                    .overlay(
                        shape.fill(LinearGradient(darkStart, darkMiddle, darkEnd))
                            .overlay(
                                shape.stroke(Color.white.opacity(0.2), lineWidth: 1.0)
                                    .blur(radius: 3.0)
                                    .offset(x: 1, y: 1)
                            )
                            .padding(3)
                    )
                
            }
        }
    }
}
struct NEUDarkButtonBackground2<S: Shape>: View {
    private let darkStart = Color( red: 33 / 255, green: 37 / 255, blue: 42 / 255)
    private let darkEnd = Color( red: 22 / 255, green: 22 / 255, blue: 22 / 255)
    
    var isHighlighted: Bool
    
    let shape: S
    var body: some View {
        GeometryReader { geometry in
            return ZStack {
                if isHighlighted {
                    shape.fill(LinearGradient(Color.darkBackgourdStart, Color.darkBackgourdEnd))
                        .overlay(
                            shape.stroke(LinearGradient(darkStart, darkEnd),
                                         lineWidth: makeLineWidthOuter(geometry: geometry))
                        )
                        .shadow(color: .darkBackgourdStart, radius: 10, x: -10, y: -10)
                        .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
                }else {
                    shape.fill(LinearGradient(Color.darkBackgourdStart, Color.darkBackgourdEnd))
                        .overlay(
                            shape.stroke(Color.gray, lineWidth: makeLineWidthInner(geometry: geometry))
                                .blur(radius: 1)
                                .offset(x: 2, y: 2)
                                .mask(shape)
                        )
                        .overlay(
                            shape.stroke(Color.black, lineWidth: makeLineWidthInner(geometry: geometry))
                                .blur(radius: 1)
                                .offset(x: -2, y: -2)
                                .mask(shape)
                        )
                        .overlay(
                            shape.stroke(LinearGradient(darkStart, darkEnd),
                                         lineWidth: makeLineWidthOuter(geometry: geometry))
                        )
                        .shadow(color: .darkBackgourdStart, radius: 10, x: -10, y: -10)
                        .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
                }
            }
        }
    }
    
    private func makeLineWidthInner(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width > geometry.size.height ? geometry.size.height / 40 : geometry.size.width / 40
    }
    private func makeLineWidthOuter(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width > geometry.size.height ? geometry.size.height / 15 : geometry.size.width / 15
    }

    private func offsetOuter(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width > geometry.size.height ? geometry.size.height / 15 : geometry.size.width / 15
    }
}

struct NEUButtonStyle<S: Shape>: ButtonStyle {
    let shape: S
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .contentShape(shape)
            .background(
                NEUButtonBackground(isHighlighted: configuration.isPressed, shape: shape)
            )
    }
}

struct NEUButtonToggleBackground<S: Shape>: View {
    @Environment(\.colorScheme) var colorScheme

    var isHighlighted: Bool
    let shadow: Bool
    let shape: S

    var body: some View {
        if colorScheme == .light {
            NEULightToggleBackground(isHighlighted: isHighlighted, shadow: shadow, shape: shape)
        }else {
            NEUDarkToggleBackground(isHighlighted: isHighlighted, shadow: shadow, shape: shape)
        }
    }
}

struct NEUBorderButtonToggleBackground<S: Shape>: View {
    @Environment(\.colorScheme) var colorScheme

    var isHighlighted: Bool
    let shadow: Bool
    let shape: S

    var body: some View {
        if colorScheme == .light {
            NEULightToggleBackground(isHighlighted: isHighlighted, shadow: shadow, shape: shape)
        }else {
            NEUBorderDarkToggleBackground(isHighlighted: isHighlighted, shadow: shadow, shape: shape)
        }
    }
}

struct NEUButtonToggleStyle<S: Shape>: ButtonStyle {
    let isHighlighted: Bool
    let shadow: Bool
    let shape: S
    init(isHighlighted: Bool, shadow: Bool = true, shape: S) {
        self.isHighlighted = isHighlighted
        self.shadow = shadow
        self.shape = shape
    }
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .contentShape(shape)
            .background(
                NEUButtonToggleBackground(isHighlighted: isHighlighted, shadow: shadow, shape: shape)
            )
    }
}

struct NEUBorderButtonToggleStyle<S: Shape>: ButtonStyle {
    let isHighlighted: Bool
    let shadow: Bool
    let shape: S
    init(isHighlighted: Bool, shadow: Bool = true, shape: S) {
        self.isHighlighted = isHighlighted
        self.shadow = shadow
        self.shape = shape
    }
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .contentShape(shape)
            .background(
                NEUBorderButtonToggleBackground(isHighlighted: isHighlighted, shadow: shadow, shape: shape)
            )
    }
}

struct NEUButtonStyle2<S: Shape>: ButtonStyle {
    let shape: S
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .contentShape(shape)
            .background(
                NEUButtonBackground2(isHighlighted: configuration.isPressed, shape: shape)
            )
    }
}
struct NEULightToggleBackground<S: Shape>: View {
    var isHighlighted: Bool
    let shadow: Bool
    let shape: S
    
    init(isHighlighted: Bool, shadow: Bool = true, shape: S) {
        self.isHighlighted = isHighlighted
        self.shadow = shadow
        self.shape = shape
    }
    var body: some View {
        ZStack {
            if isHighlighted {
                if shadow {
                    shape.fill(LinearGradient(.lightOrangeEnd, .lightOrangeMiddle, .lightOrangeStart))
//                        .overlay(
//                            Circle().stroke(Color.gray)
//                                .blur(radius: 4)
//                                .offset(x: 2, y: 2)
//                        )
//                        .overlay(
//                            Circle().stroke(Color.white)
//                                .blur(radius: 4)
//                                .offset(x: -2, y: -2)
//                        )
                        .shadow(color: Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1)), radius: 10, x: -10, y: -10)
                        .shadow(color: Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1)), radius: 10, x: 5, y: 5)
                }else {
                    shape.fill(LinearGradient(.lightOrangeEnd, .lightOrangeMiddle, .lightOrangeStart))
                }
            }else {
                shape.fill(LinearGradient(Color.white, Color.lightBackgourdEnd))
                    .shadow(color: Color.white, radius: 5, x: -5, y: -5)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            }
        }
    }
}
struct NEUDarkToggleBackground<S: Shape>: View {
    private let darkStart = Color( red: 47 / 255, green: 53 / 255, blue: 58 / 255)
    private let darkMiddle = Color( red: 34 / 255, green: 37 / 255, blue: 41 / 255)
    private let darkEnd = Color(red: 28 / 255, green: 30 / 255, blue: 34 / 255)
    
    var isHighlighted: Bool
    let shadow: Bool
    let shape: S
    
    init(isHighlighted: Bool, shadow: Bool = true, shape: S) {
        self.isHighlighted = isHighlighted
        self.shadow = shadow
        self.shape = shape
    }
    var body: some View {
        ZStack {
            if isHighlighted {
                if shadow == true {
                    shape.fill(LinearGradient(.darkOrangeEnd, .darkOrangeMiddle, .darkOrangeStart))
                        .overlay(
                            shape.stroke(LinearGradient(.darkOrangeStart, .darkOrangeMiddle, .darkOrangeEnd), lineWidth: 3)
                        )
                        .shadow(color: .darkBackgourdStart, radius: 10, x: -10, y: -10)
                        .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
                }else {
                    shape.fill(LinearGradient(.darkOrangeEnd, .darkOrangeMiddle, .darkOrangeStart))
                        .overlay(
                            shape.stroke(LinearGradient(.darkOrangeStart, .darkOrangeMiddle, .darkOrangeEnd), lineWidth: 3)
                        )
                }
            }else {
                shape.fill(LinearGradient(Color.darkBackgourdEnd, Color.darkBackgourdStart))
                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -10, y: -10)
                    .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
                    .overlay(
                        shape.fill(LinearGradient(darkStart, darkMiddle, darkEnd))
                            .overlay(
                                shape.stroke(Color.white.opacity(0.2), lineWidth: 1.0)
                                    .blur(radius: 3.0)
                                    .offset(x: 1, y: 1)
                            )
                            .padding(3)
                    )
            }
        }
    }
}

struct NEUBorderDarkToggleBackground<S: Shape>: View {
    private let borderDarkStart = Color( red: 33 / 255, green: 37 / 255, blue: 42 / 255)
    private let borderDarkEnd = Color( red: 22 / 255, green: 22 / 255, blue: 22 / 255)
    
    var isHighlighted: Bool
    let shadow: Bool
    let shape: S
    
    init(isHighlighted: Bool, shadow: Bool = true, shape: S) {
        self.isHighlighted = isHighlighted
        self.shadow = shadow
        self.shape = shape
    }
    var body: some View {
        GeometryReader { geometry in
            return ZStack {
                let lineWidth = geometry.size.width > geometry.size.height ? geometry.size.height / 40 : geometry.size.width / 40
                let boardLineWidth = geometry.size.width > geometry.size.height ? geometry.size.height / 15 : geometry.size.width / 15
                if isHighlighted {
                    shape.fill(LinearGradient(Color.darkBackgourdStart, Color.darkBackgourdEnd))
                        .overlay(
                            shape.stroke(LinearGradient(borderDarkStart, borderDarkEnd),
                                         lineWidth: boardLineWidth)
                        )
                        .shadow(color: .darkBackgourdStart, radius: 10, x: -10, y: -10)
                        .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
                }else {
                    shape.fill(LinearGradient(Color.darkBackgourdStart, Color.darkBackgourdEnd))
                        .overlay(
                            shape.stroke(Color.gray, lineWidth: lineWidth)
                                .blur(radius: 1)
                                .offset(x: lineWidth, y: lineWidth)
                                .mask(shape)
                        )
                        .overlay(
                            shape.stroke(Color.black, lineWidth: lineWidth)
                                .blur(radius: 1)
                                .offset(x: -lineWidth, y: -lineWidth)
                                .mask(shape)
                        )
                        .overlay(
                            shape.stroke(LinearGradient(borderDarkStart, borderDarkEnd),
                                         lineWidth: boardLineWidth)
                        )
                        .shadow(color: .darkBackgourdStart, radius: 10, x: -10, y: -10)
                        .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
                }
            }
        }
    }
}

struct NEUToggleBackground<S: Shape>: View {
    @Environment(\.colorScheme) var colorScheme

    var isHighlighted: Bool
    let shadow: Bool
    let shape: S
    
    init(isHighlighted: Bool, shadow: Bool = true, shape: S) {
        self.isHighlighted = isHighlighted
        self.shadow = shadow
        self.shape = shape
    }
    var body: some View {
        if colorScheme == .light {
            NEULightToggleBackground(isHighlighted: isHighlighted, shadow: shadow, shape: shape)
        }else {
            NEUDarkToggleBackground(isHighlighted: isHighlighted, shadow: shadow, shape: shape)
        }
    }
}

struct NEUToggleStyle<S: Shape>: ToggleStyle {
    let shape: S
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            configuration.label
                .contentShape(shape)
                .background(
                    NEUToggleBackground(isHighlighted: configuration.isOn, shape: shape)
                )        }
        
    }
}
#if DEBUG
struct NEUButtonStyleDebugView: View {
    @State private var vibrateOnRing = false
    
    var body: some View {
        ZStack {
            NEUDarkBackgroundView()
            VStack(spacing: 50.0) {
                Button(action: {
                    print("pressed")
                }) {
                    NEUSFView(systemName: "heart.fill", size: .small)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
                Button(action: {
                    print("pressed")
                }) {
                    NEUSFView(systemName: "heart.fill", size: .medium)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
                Button(action: {
                    print("pressed")
                }) {
                    NEUSFView(systemName: "heart.fill", size: .small)
                }
                .buttonStyle(NEUButtonStyle2(shape: Circle()))
                Button(action: {
                    print("pressed")
                }) {
                    NEUSFView(systemName: "heart.fill", size: .medium)
                }
                .buttonStyle(NEUButtonStyle2(shape: Circle()))
                Button(action: {
                    print("pressed")
                }) {
                    NEUSFView(systemName: "heart.fill", size: .big)
                }
                .buttonStyle(NEUButtonStyle2(shape: Circle()))
                Button(action: {
                    print("pressed")
                }) {
                    NEUSFView(systemName: "heart.fill", size: .large)
                }
                .buttonStyle(NEUButtonStyle2(shape: Circle()))
                Toggle(isOn: $vibrateOnRing, label: {
                    NEUSFView(systemName: "heart.fill", size: .big)
                }).toggleStyle(NEUToggleStyle(shape: Circle()))
            }
        }
    }
}

struct NEUButtonStyle_Previews: PreviewProvider {

    static var previews: some View {
        NEUButtonStyleDebugView()
            .environment(\.colorScheme, .dark)
    }
}
#endif
