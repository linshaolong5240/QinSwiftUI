//
//  NEUBackgroundView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

public struct NEUBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    public var body: some View {
        let colors = colorScheme == .light ? [Color(#colorLiteral(red: 0.9098039216, green: 0.9137254902, blue: 0.9294117647, alpha: 1)), Color(#colorLiteral(red: 0.8980392157, green: 0.9058823529, blue: 0.9215686275, alpha: 1))] : [Color.darkBackgourdStart, Color.darkBackgourdMiddle,  Color.darkBackgourdEnd]
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

#if DEBUG
struct BackGroundView_Previews: PreviewProvider {
    static var previews: some View {
        NEUBackgroundView()
            .preferredColorScheme(.light)
        NEUBackgroundView()
            .preferredColorScheme(.dark)

    }
}
#endif
