//
//  NEUDivider.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/11.
//

import SwiftUI

struct NEUDivider: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        if colorScheme == .light {
            NEULightDivider()
        }else {
            NEUDarkDivider()
        }
    }
}

struct NEULightDivider: View {
    var body: some View {
        Color.lightBackgourdStart
            .frame(height: 2)
            .shadow(color: Color.white, radius: 3, y: -2)
            .shadow(color: Color.black.opacity(0.2), radius: 3, y: 2)
            .padding(.bottom, 2)
    }
}
struct NEUDarkDivider: View {
    var body: some View {
        Color.darkBackgourdStart
            .frame(height: 2)
            .shadow(color: Color.darkBackgourdStart, radius: 3, y: -2)
            .shadow(color: Color.darkBackgourdEnd, radius: 3, y: 2)
            .padding(.bottom, 2)
    }
}
#if DEBUG
struct NEUDivider_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                NEULightDivider()
            }
        }
        ZStack {
            NEUBackgroundView()
            VStack {
                NEUDarkDivider()
            }
        }
    }
}
#endif
