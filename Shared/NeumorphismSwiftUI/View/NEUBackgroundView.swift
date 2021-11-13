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
        let colors = colorScheme == .light ? Color.lightBackgroundColors : Color.darkBackgroundColors
        
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

#if DEBUG
struct NEUBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        NEUBackgroundView()
            .preferredColorScheme(.light)
        NEUBackgroundView()
            .preferredColorScheme(.dark)
    }
}
#endif
