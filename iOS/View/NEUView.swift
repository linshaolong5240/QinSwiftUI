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
//    static let lightBackgourdStart = Color(red: 231 / 255, green: 233 / 255, blue: 237 / 255)
    static let lightBackgourdEnd = Color(red: 231 / 255, green: 233 / 255, blue: 237 / 255)
    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
    static let orangeStart = Color(red: 235 / 255, green: 72 / 255, blue: 50 / 255)
    static let orangeEnd = Color(red: 246 / 255, green: 143 / 255, blue: 130 / 255)}
extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct NEUView: View {
    var body: some View {
//        NeuDividerView()
        ZStack {
            BackgroundView()
            VStack {
                Spacer()
                RingProgressView(percent: 0.7)
            }
        }
    }
}

struct NEUView_Previews: PreviewProvider {
    static var previews: some View {
        NEUView()
    }
}


struct NeuDividerView: View {
    var body: some View {
        Color("backgroundColor")
            .frame(height: 1)
            .shadow(color: Color.white.opacity(0.1), radius: 1, x: 0, y: 0)
            .shadow(color: Color.black.opacity(1), radius: 1, x: 0, y: 2)
    }
}

struct RingProgressView: View {
    @Environment(\.colorScheme) var colorScheme

    let percent: Double
    
    var body: some View {
        ZStack(alignment: .trailing) {
//            GeometryReader {geometryProxy in
//                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9194737077, green: 0.2849465311, blue: 0.1981146634, alpha: 1)),Color(#colorLiteral(red: 0.9983269572, green: 0.3682751656, blue: 0.2816230953, alpha: 1)),Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
//                HStack {
//                    Spacer()
//                    if self.colorScheme == .light {
//                        Color(#colorLiteral(red: 0.8270753026, green: 0.8349325061, blue: 0.8597596884, alpha: 1))
//                            .frame(width: geometryProxy.size.width * CGFloat(1 - self.percent))
//                    }else {
//                        Color(.black)
//                            .frame(width: geometryProxy.size.width * CGFloat(1 - self.percent))
//                    }
//                }
//            }
            Circle()
                .stroke(Color(#colorLiteral(red: 0.9212211967, green: 0.9292807579, blue: 0.9416347146, alpha: 1)),
                        style: StrokeStyle(lineWidth: 5)
                )
            Circle()
                .trim(from: CGFloat(1 - percent), to: 1)
            .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9194737077, green: 0.2849465311, blue: 0.1981146634, alpha: 1)),Color(#colorLiteral(red: 0.9983269572, green: 0.3682751656, blue: 0.2816230953, alpha: 1)),Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1))]), startPoint: .bottomTrailing, endPoint: .topLeading),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
            )
                .rotationEffect(.degrees(90))
                .rotation3DEffect(.degrees(180), axis: (x: 10, y: 0, z: 0))
        }
    .padding()
    }
}
