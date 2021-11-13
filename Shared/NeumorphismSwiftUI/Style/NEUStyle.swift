//
//  NEUStyle.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/10.
//

import Foundation
import SwiftUI

public extension Array where Element == Color {
    static let lightOrangeColors: [Color] = [Color(#colorLiteral(red: 0.9647058824, green: 0.568627451, blue: 0.5137254902, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.368627451, blue: 0.2823529412, alpha: 1)), Color(#colorLiteral(red: 0.8823529412, green: 0.3294117647, blue: 0.03921568627, alpha: 1))]
    static let darkOrangeColors: [Color] = [Color(#colorLiteral(red: 0.8823529412, green: 0.3294117647, blue: 0.03921568627, alpha: 1)), Color(#colorLiteral(red: 0.9254901961, green: 0.2862745098, blue: 0.07450980392, alpha: 1)), Color(#colorLiteral(red: 0.7333333333, green: 0.1254901961, blue: 0.05490196078, alpha: 1))]
}

public extension Color {
    static let neuMainText: Color = Color("NEUMainTextColor")
    static let neuSecondaryText: Color = Color("NEUSecondaryTextColor")
}

extension Color {
    static let lightBackgroundColors: [Color] = [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9529411765, alpha: 1)), Color(#colorLiteral(red: 0.831372549, green: 0.8431372549, blue: 0.8588235294, alpha: 1))]
    static let darkBackgroundColors: [Color] = [Color(#colorLiteral(red: 0.1843137255, green: 0.2, blue: 0.2274509804, alpha: 1)), Color(#colorLiteral(red: 0.1490196078, green: 0.1647058824, blue: 0.1803921569, alpha: 1)), Color(#colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.137254902, alpha: 1))]
    
//    static let lightOrangeColors: [Color] = [Color(#colorLiteral(red: 0.9647058824, green: 0.568627451, blue: 0.5137254902, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.368627451, blue: 0.2823529412, alpha: 1)), Color(#colorLiteral(red: 0.8823529412, green: 0.3294117647, blue: 0.03921568627, alpha: 1))]
//    static let darkOrangeColors: [Color] = [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9529411765, alpha: 1)), Color(#colorLiteral(red: 0.831372549, green: 0.8431372549, blue: 0.8588235294, alpha: 1))]

    static let lightTopLeftShadowColor: Color = .white
    static let darkTopLeftShadowColor: Color = .white.opacity(0.11)
    static let lightBottomRightShadowColor: Color = .black.opacity(0.22)
    static let darkBottomRightShadowColor: Color = .black.opacity(0.33)

    static let lightBackgourdStart = Color(red: 250 / 255, green: 250 / 255, blue: 250 / 255)
    static let lightBackgourdEnd = Color(red: 231 / 255, green: 233 / 255, blue: 237 / 255)
    static let darkBackgourdStart = Color(red: 54 / 255, green: 58 / 255, blue: 64 / 255)
    static let darkBackgourdMiddle = Color(red: 37 / 255, green: 40 / 255, blue: 44 / 255)
    static let darkBackgourdEnd = Color(red: 24 / 255, green: 25 / 255, blue: 28 / 255)

    static let darkOrangeStart = Color(red: 225 / 255, green: 84 / 255, blue: 10 / 255)
    static let darkOrangeMiddle = Color(red: 236 / 255, green: 73 / 255, blue: 19 / 255)
    static let darkOrangeEnd = Color(red: 187 / 255, green: 32 / 255, blue: 14 / 255)
}

public protocol NEUStyle { }

extension NEUStyle {
    
    public func neuBacgroundColors(_ colorScheme: ColorScheme) -> [Color] {
        colorScheme == .light ? Color.lightBackgroundColors : Color.darkBackgroundColors
    }
    
    public func neuPressedBacgroundColors(_ colorScheme: ColorScheme) -> [Color] {
        (colorScheme == .light ? Color.lightBackgroundColors : Color.darkBackgroundColors).reversed()
    }
    
    public func neuOrangeColors(_ colorScheme: ColorScheme) -> [Color] {
        colorScheme == .light ? .lightOrangeColors : .darkOrangeColors
    }
    
    public func neuTopLeftShadowColor(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? .lightTopLeftShadowColor : .darkTopLeftShadowColor
    }
    
    public func neuBottomRightShadowColor(_ colorScheme: ColorScheme) -> Color {
        colorScheme == .light ? .lightBottomRightShadowColor : .darkBottomRightShadowColor
    }
    
    public func neuTopLeftShadowRadius(_ colorScheme: ColorScheme) -> CGFloat {
        colorScheme == .light ? 5 : 10
    }
    
    public func neuBottomRightShadowRadius(_ colorScheme: ColorScheme) -> CGFloat {
        colorScheme == .light ? 10 : 10
    }
    
}
