//
//  QinBackgroundView.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/12.
//

import SwiftUI

//#if DEBUG
//struct QinBackgroundView_Previews: PreviewProvider {
//    static var previews: some View {
//        QinBackgroundView()
//    }
//}
//#endif

struct QinToggleBackground<S: Shape>: View {
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
                    shape.fill(Color.accentColor)
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
                    shape.fill(Color.accentColor)
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
