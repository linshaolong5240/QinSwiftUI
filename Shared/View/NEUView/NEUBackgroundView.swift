//
//  NEUBackgroundView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct NEUBackgroundView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if colorScheme == .light {
            NEULightBackgroundView()
        }else {
            NEUDarkBackgroundView()
        }
    }
}
struct NEULightBackgroundView: View {
    var body: some View {
        LinearGradient(Color.lightBackgourdStart, Color.lightBackgourdEnd)
            .edgesIgnoringSafeArea(.all)
    }
}
struct NEUDarkBackgroundView: View {
    var body: some View {
        LinearGradient(Color.darkBackgourdStart, Color.darkBackgourdMiddle,  Color.darkBackgourdEnd)
            .edgesIgnoringSafeArea(.all)
    }
}
#if DEBUG
struct BackGroundView_Previews: PreviewProvider {
    static var previews: some View {
        NEUDarkBackgroundView()
    }
}
#endif
