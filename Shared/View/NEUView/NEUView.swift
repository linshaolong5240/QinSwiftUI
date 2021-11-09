//
//  NEUView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/30.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

extension Color {
    static let lightBackgroundColors: [Color] = [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.9411764706, green: 0.9450980392, blue: 0.9529411765, alpha: 1)), Color(#colorLiteral(red: 0.831372549, green: 0.8431372549, blue: 0.8588235294, alpha: 1))]
    static let darkBackgroundColors: [Color] = [Color(#colorLiteral(red: 0.1843137255, green: 0.2, blue: 0.2274509804, alpha: 1)), Color(#colorLiteral(red: 0.1490196078, green: 0.1647058824, blue: 0.1803921569, alpha: 1)), Color(#colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.137254902, alpha: 1))]

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
    static let lightOrangeStart = Color(red: 246 / 255, green: 145 / 255, blue: 131 / 255)
    static let lightOrangeMiddle = Color(red: 255 / 255, green: 94 / 255, blue: 72 / 255)
    static let lightOrangeEnd = Color(red: 225 / 255, green: 84 / 255, blue: 10 / 255)
}
extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

#if DEBUG
struct NEUView: View {
    var body: some View {
        ZStack {
            NEUBackgroundView()
            NEURingProgressView(percent: 0.7)
        }
    }
}

struct NEUView_Previews: PreviewProvider {
    static var previews: some View {
        NEUView()
    }
}
#endif
