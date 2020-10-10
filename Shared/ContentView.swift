//
//  ContentView.swift
//  Shared
//
//  Created by 林少龙 on 2020/8/6.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        #if !os(macOS)
        HomeView()
        #else
        Text("hello world")
            .padding()
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
