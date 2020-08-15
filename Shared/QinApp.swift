//
//  QinApp.swift
//  Shared
//
//  Created by 林少龙 on 2020/8/6.
//

import SwiftUI
#if os(iOS)
let screen = UIScreen.main.bounds
#endif
@main
struct QinApp: App {
    @StateObject var store = Store.shared
    @StateObject var player = Player.shared
    var body: some Scene {
        WindowGroup {
//            ContentView()
            #if !os(macOS)
            HomeView()
                .environmentObject(store)
                .environmentObject(player)
            #else
            Text("hello world")
                .padding()
            #endif
        }
    }
}
