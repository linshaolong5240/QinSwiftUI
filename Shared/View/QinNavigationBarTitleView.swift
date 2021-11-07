//
//  QinNavigationBarTitleView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/10/15.
//

import SwiftUI

struct QinNavigationBarTitleView: View {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    var body: some View {
        Text(title)
            .fontWeight(.bold)
            .foregroundColor(.mainTextColor)
    }
}

struct NEUNavigationBarTitleView_Previews: PreviewProvider {
    static var previews: some View {
        QinNavigationBarTitleView("title")
    }
}
