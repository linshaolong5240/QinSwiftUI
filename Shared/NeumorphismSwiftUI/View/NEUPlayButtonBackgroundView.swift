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
            shape.fill(LinearGradient(gradient: Gradient(colors: .lightOrangeColors), startPoint: .topLeading, endPoint: .bottomTrailing))
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
            shape.fill(LinearGradient(gradient: Gradient(colors: .lightOrangeColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
        }
    }
}

struct NEUDarkToggleBackground<S: Shape>: View, NEUStyle {
    
    let shadow: Bool
    let shape: S
    
    init(shadow: Bool = true, shape: S) {
        self.shadow = shadow
        self.shape = shape
    }
    var body: some View {
        let orangeColors: [Color] = .darkOrangeColors
        
        if shadow == true {
            shape.fill(LinearGradient(gradient:Gradient(colors: orangeColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(
                    shape.stroke(LinearGradient(gradient:Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                )
                .shadow(color: .darkBackgourdStart, radius: 10, x: -10, y: -10)
                .shadow(color: .darkBackgourdEnd, radius: 10, x: 10, y: 10)
        }else {
            shape.fill(LinearGradient(gradient:Gradient(colors: orangeColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(
                    shape.stroke(LinearGradient(gradient:Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
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
