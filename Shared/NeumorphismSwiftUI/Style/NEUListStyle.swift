//
//  NEUListStyle.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/12.
//

import SwiftUI

#if DEBUG
struct NEUListStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            NEUListRowBackgroundView(isHighlighted: true)
                .frame(height: 60)
                .padding()
        }
        .environment(\.colorScheme, .light)
    }
}
#endif

struct NEUListRowBackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    let isHighlighted: Bool

    var body: some View {
        if colorScheme == .light {
            NEULightListRowBackgroundView(isHighlighted: isHighlighted)
        }else {
            NEUDarkListRowBackgroundView(isHighlighted: isHighlighted)
        }
    }
}

struct NEULightListRowBackgroundView: View {
    let isHighlighted: Bool
    
    var body: some View {
        if isHighlighted {
//            ZStack {
//                Color.lightBackgourdStart
//                LinearGradient(.lightOrangeEnd, .lightOrangeMiddle, .lightOrangeStart)
//                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//                    .padding(5)
//                    .shadow(color: Color.black.opacity(0.25), radius: 5, x: -5, y: -5)
//                    .shadow(color: Color.white, radius: 5, x: 5, y: 5)
//                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
//            }
//            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            LinearGradient(gradient: Gradient(colors: [Color.lightBackgourdEnd, Color.lightBackgourdStart]), startPoint: .top, endPoint: .bottom)
                .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: .lightBackgourdStart, radius: 1, y: -2)
                .shadow(color: .lightBackgourdEnd, radius: 1, y: 2)

        }else{
            Color.clear
        }
    }
}

struct NEUDarkListRowBackgroundView: View {
    let darkStart = Color(red: 26 / 255, green: 28 / 255, blue: 31 / 255)
    let darkEnd = Color(red: 18 / 255, green: 19 / 255, blue: 21 / 255)

    let isHighlighted: Bool

    var body: some View {
        if isHighlighted {
//            ZStack {
//                Color.darkBackgourdStart
//                LinearGradient(.darkOrangeEnd, .darkOrangeMiddle, .darkOrangeStart)
//                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//                    .padding(5)
//                    .shadow(color: .darkBackgourdEnd, radius: 5, x: -5, y: -5)
//                    .shadow(color: .darkBackgourdStart, radius: 5, x: 5, y: 5)
//                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
//            }
            LinearGradient(gradient: Gradient(colors: [darkEnd, darkStart]), startPoint: .top, endPoint: .bottom)
                .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: .darkBackgourdStart, radius: 1, y: -2)
                .shadow(color: .black, radius: 1, y: 2)
        }else {
            Color.clear
        }
        
    }
}
