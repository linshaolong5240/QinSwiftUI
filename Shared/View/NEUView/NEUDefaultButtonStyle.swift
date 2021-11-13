//
//  NEUButtonStyle.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/8/15.
//

import SwiftUI

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
