//
//  NEUListStyle.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/12.
//

import SwiftUI

#if DEBUG
struct NEUListStyle: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct NEUListStyle_Previews: PreviewProvider {
    static var previews: some View {
        NEUListStyle()
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
            ZStack {
                Color.lightBackgourdStart
                LinearGradient(.lightOrangeEnd, .lightOrangeMiddle, .lightOrangeStart)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(5)
                    .shadow(color: Color.black.opacity(0.25), radius: 5, x: -5, y: -5)
                    .shadow(color: Color.white, radius: 5, x: 5, y: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }else{
            Color(.clear)
        }
    }
}

struct NEUDarkListRowBackgroundView: View {
    let isHighlighted: Bool

    var body: some View {
        if isHighlighted {
            ZStack {
                Color.darkBackgourdStart
                LinearGradient(.darkOrangeEnd, .darkOrangeMiddle, .darkOrangeStart)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(5)
                    .shadow(color: .darkBackgourdEnd, radius: 5, x: -5, y: -5)
                    .shadow(color: .darkBackgourdStart, radius: 5, x: 5, y: 5)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }else {
            Color.clear
        }
        
    }
}
