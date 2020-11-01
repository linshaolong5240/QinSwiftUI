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
    let context = DataManager.shared.Context()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    store.dispatch(.loginRefresh)
                }
                .environmentObject(store)
                .environmentObject(player)
                .environment(\.managedObjectContext, context)
        }
    }
}
