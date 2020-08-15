//
//  NEUView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/30.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

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
