//
//  UserCloudView.swift
//  Qin (macOS)
//
//  Created by 林少龙 on 2021/7/8.
//

import SwiftUI

struct UserCloudView: View {
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                Button(action: {
                    Store.shared.dispatch(.userCloudRequest)
                }) {
                    Text("User Cloud")
                }
            }
        }
        .navigationTitle("User Cloud")
    }
}

#if DEBUG
struct UserCloudView_Previews: PreviewProvider {
    static var previews: some View {
        UserCloudView()
    }
}
#endif
