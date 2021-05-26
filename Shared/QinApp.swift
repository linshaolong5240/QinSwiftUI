//
//  QinApp.swift
//  Shared
//
//  Created by 林少龙 on 2020/8/6.
//

import SwiftUI

@main
struct QinApp: App {
    @StateObject var store = Store.shared
    @StateObject var player = Player.shared
    let context = DataManager.shared.context()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    store.dispatch(.loginRefreshRequest)
                }
                .environmentObject(store)
                .environmentObject(player)
                .environment(\.managedObjectContext, context)
        }
    }
}
