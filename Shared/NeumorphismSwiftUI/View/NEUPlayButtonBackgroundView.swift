//
//  NEUPlayButtonBackgroundView.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/13.
//

import SwiftUI

public struct NEUPlayButtonBackgroundView<S: Shape>: View {
    
    @Environment(\.colorScheme) private var colorScheme

    let shape: S
    let shadow: Bool

    init(shape: S, shadow: Bool = true) {
        self.shadow = shadow
        self.shape = shape
    }
    
    public var body: some View {
        if colorScheme == .light {
            NEULightToggleBackground(shadow: shadow, shape: shape)
        }else {
            NEUDarkToggleBackground(shadow: shadow, shape: shape)
        }
    }
}

struct NEULightToggleBackground<S: Shape>: View {
    
    let shadow: Bool
    let shape: S
    
    init(shadow: Bool = true, shape: S) {
        self.shadow = shadow
        self.shape = shape
    }
    
    var body: some View {
        if shadow {
            shape.fill(LinearGradient(Color.lightOrangeEnd, Color.lightOrangeMiddle, .lightOrangeStart))
                .overlay(
                    Circle().stroke(Color.gray)
                        .blur(radius: 4)
                        .offset(x: 2, y: 2)
                )
                .overlay(
                    Circle().stroke(Color.white)
                        .blur(radius: 4)
                        .offset(x: -2, y: -2)
                )
                .shadow(color: Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1)), radius: 10, x: -10, y: -10)
                .shadow(color: Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1)), radius: 10, x: 5, y: 5)
        }else {
            shape.fill(LinearGradient(Color.lightOrangeEnd, Color.lightOrangeMiddle, .lightOrangeStart))
        }
    }
}

struct NEUDarkToggleBackground<S: Shape>: View {
    private let darkStart = Color( red: 47 / 255, green: 53 / 255, blue: 58 / 255)
    private let darkMiddle = Color( red: 34 / 255, green: 37 / 255, blue: 41 / 255)
    private let darkEnd = Color(red: 28 / 255, green: 30 / 255, blue: 34 / 255)
    
    let shadow: Bool
    let shape: S
    
    init(shadow: Bool = true, shape: S) {
        self.shadow = shadow
        self.shape = shape
    }
    var body: some View {
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
    }
}

#if DEBUG
struct NEUPlayButtonBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        NEUPlayButtonBackgroundView(shape: Circle(), shadow: true)
            .preferredColorScheme(.light)
        NEUPlayButtonBackgroundView(shape: Circle(), shadow: true)
            .preferredColorScheme(.dark)

    }
}
#endif
