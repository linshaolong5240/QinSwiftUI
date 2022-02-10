//
//  TestView.swift
//  Qin
//
//  Created by teenloong on 2020/6/26.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

#if DEBUG
struct TestView: View {
    @State private var users = ["Paul", "Taylor", "Adele"]

    var body: some View {
        VStack {
            Button(action: {
                Store.shared.dispatch(.artistDetailRequest(id: 12206844))
                print("test")
            }, label: {
                Text("Button")
            })
        }
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            QinBackgroundView()
            TestView()
        }
    }
}
#endif
