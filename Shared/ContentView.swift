//
//  ContentView.swift
//  Shared
//
//  Created by 林少龙 on 2020/8/6.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(macOS)
        SideBarNavigationView()
            .frame(width: 800, height: 600)
        #else
        HomeView()
        #endif
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
