//
//  ViewModifier.swift
//  Qin
//
//  Created by 林少龙 on 2020/7/19.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct NEUShadow: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    let radius: CGFloat
    let offset: CGFloat
    init(radius: CGFloat = 10, offset: CGFloat = 10) {
        self.radius  = radius
        self.offset = offset
    }
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.white.opacity(colorScheme == .light ? 1 : 0.25),
                    radius: radius,
                    x: -offset, y: -offset)
            .shadow(color: Color.black.opacity(colorScheme == .light ? 0.25 : 0.5), radius: radius, x: offset, y: offset)
    }
}

//struct NEUShape<S>: ViewModifier where S: Shape{
//    @Environment(\.colorScheme) var colorScheme
//    let active: Bool
//    let s: S
//
//    func body(content: Content) -> some View {
//        content
//            .background(
//                VStack {
//                    if active {
//                        ZStack {
//                            if size != .small {
//                                Circle()
//                                .shadow(color: Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1)), radius: 10, x: -10, y: -10)
//                                .shadow(color: Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1)), radius: 5, x: 3, y: 3)
//                            }
//                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9194737077, green: 0.2849465311, blue: 0.1981146634, alpha: 1)),Color(#colorLiteral(red: 0.9983269572, green: 0.3682751656, blue: 0.2816230953, alpha: 1)),Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                            .clipShape(Circle())
//                        }
//                    }else {
//                        ZStack {
//                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),Color("BGC3")]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                                .clipShape(Circle())
//                                .padding(.all, size.width / 20)
//                        }
//                        .clipShape(Circle())
////                                .blur(radius: 0.25)
//                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 5, x: -5, y: -5)
//                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.2), radius: 10, x: 10, y: 10)
//                    }
//                }
//        )
//            .clipShape(s)
//    }
//}
