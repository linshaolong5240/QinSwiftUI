//
//  NEUView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/30.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

extension Color {
    static let lightBackgourdStart = Color(red: 250 / 255, green: 250 / 255, blue: 250 / 255)
    static let lightBackgourdEnd = Color(red: 231 / 255, green: 233 / 255, blue: 237 / 255)
    static let darkBackgourdStart = Color(red: 54 / 255, green: 58 / 255, blue: 64 / 255)
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
//        NeuDividerView()
        ZStack {
            NEUBackgroundView()
            VStack {
                Spacer()
                NEURingProgressView(percent: 0.7)
            }
        }
    }
}

struct NEUView_Previews: PreviewProvider {
    static var previews: some View {
        NEUView()
    }
}
#endif

struct NeuDividerView: View {
    var body: some View {
        Color("backgroundColor")
            .frame(height: 1)
            .shadow(color: Color.white.opacity(0.1), radius: 1, x: 0, y: 0)
            .shadow(color: Color.black.opacity(1), radius: 1, x: 0, y: 2)
    }
}
