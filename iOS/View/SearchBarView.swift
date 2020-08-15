//
//  SearchBarView.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2020/8/12.
//

import SwiftUI

struct SearchView: View {
    @State var searchKeyword: String = ""

    var body: some View {
        TextField("搜索", text: $searchKeyword, onCommit: {
            Store.shared.dispatch(.search(keyword: searchKeyword))
        })
        .padding(10)
        .background(
            Color.white
                .clipShape(Capsule())
        )
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
