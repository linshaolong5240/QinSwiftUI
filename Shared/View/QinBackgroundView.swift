//
//  QinBackgroundView.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/12.
//

import SwiftUI
import NeumorphismSwiftUI

typealias QinBackgroundView = NEUBackgroundView

#if DEBUG
fileprivate struct QinBackgroundViewDEBUGView: View {
    var body: some View {
        ZStack {
            QinBackgroundView()
        }
    }
}
struct QinBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        QinBackgroundViewDEBUGView()
            .preferredColorScheme(.light)
        QinBackgroundViewDEBUGView()
            .preferredColorScheme(.dark)
    }
}
#endif
