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
    var isHighlighted: Bool
    
    let shape: S
    var body: some View {
        ZStack {
            if isHighlighted {
                shape.fill(LinearGradient(Color.darkBackgourdEnd, Color.darkBackgourdStart))
                    .overlay(
                        shape.stroke(LinearGradient(Color( red: 43 / 255, green: 46 / 255, blue: 54 / 255), Color(red: 42 / 255, green: 46 / 255, blue: 54 / 255)), lineWidth: 3)
                    )
                    .shadow(color: .darkBackgourdStart, radius: 10, x: -10, y: -10)
                    .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
            }else {
                shape.fill(LinearGradient(Color.darkBackgourdStart, Color.darkBackgourdEnd))
                    .overlay(
                        shape.stroke(LinearGradient(Color( red: 43 / 255, green: 46 / 255, blue: 54 / 255), Color(red: 42 / 255, green: 46 / 255, blue: 54 / 255)), lineWidth: 3)
                    )
                    .shadow(color: .darkBackgourdStart, radius: 10, x: -10, y: -10)
                    .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
            }
        }
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
                shape.fill(LinearGradient(Color.darkBackgourdStart, Color.darkBackgourdEnd))
                    .overlay(
                        shape.stroke(LinearGradient(Color( red: 43 / 255, green: 46 / 255, blue: 54 / 255), Color(red: 42 / 255, green: 46 / 255, blue: 54 / 255)), lineWidth: 3)
                    )
                    .shadow(color: .darkBackgourdStart, radius: 10, x: -10, y: -10)
                    .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
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
                    NEUButtonView(systemName: "heart", size: .small)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
                Button(action: {
                    print("pressed")
                }) {
                    NEUButtonView(systemName: "heart", size: .medium)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))
                Button(action: {
                    print("pressed")
                }) {
                    NEUButtonView(systemName: "heart", size: .big)
                }
                .buttonStyle(NEUButtonStyle(shape: Circle()))

                Toggle(isOn: $vibrateOnRing, label: {
                    NEUButtonView(systemName: "heart", size: .big)
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