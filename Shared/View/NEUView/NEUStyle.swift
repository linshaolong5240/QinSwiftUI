//
//  NEUStyle.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/10.
//

import Foundation
import SwiftUI

public protocol NEUStyle {
    
    func neuTopLeftShadowColor(_ colorScheme: ColorScheme) -> Color
    func neuBottomRightShadowColor(_ colorScheme: ColorScheme) -> Color

    func neuTopLeftShadowRadius(_ colorScheme: ColorScheme) -> CGFloat
    func neuBottomRightShadowRadius(_ colorScheme: ColorScheme) -> CGFloat

}

extension NEUStyle {
    
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
