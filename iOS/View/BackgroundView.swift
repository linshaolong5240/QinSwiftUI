//
//  BackGroundView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
    private let theme = NeuTheme.shared
    var body: some View {
        theme.backgroundView
    }
}
#if DEBUG
struct BackGroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
#endif
