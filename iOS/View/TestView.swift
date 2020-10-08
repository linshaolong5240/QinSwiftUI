//
//  TestView.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/26.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @State private var users = ["Paul", "Taylor", "Adele"]

    var body: some View {
        VStack {
            Button(action: {
                Store.shared.dispatch(.artists(id: 12206844))
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
            NEUBackgroundView()
            TestView()
        }
    }
}
