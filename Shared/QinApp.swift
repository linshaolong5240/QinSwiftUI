//
//  QinApp.swift
//  Shared
//
//  Created by teenloong on 2020/8/6.
//

import SwiftUI

@main
struct QinApp: App {
    @Environment(\.scenePhase) private var scenePhase
    #if canImport(UIKit)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate: AppDelegate
    #endif
    @StateObject var store = Store.shared
    @StateObject var player = Player.shared
    let context = DataManager.shared.context()

    var body: some Scene {
        #if os(macOS)
        WindowGroup {
            ContentView()
                .onAppear {
                    store.dispatch(.loginRefreshRequest)
                }
                .environmentObject(store)
                .environmentObject(player)
                .environment(\.managedObjectContext, context)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            SidebarCommands()
        }
        #else
        WindowGroup {
            ContentView()
                .onAppear {
                    store.dispatch(.loginRefreshRequest)
                }
                .environmentObject(store)
                .environmentObject(player)
                .environment(\.managedObjectContext, context)
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                break
            case .background:
                break
            case .inactive:
                break
            @unknown default:
                break
            }
        }
        #endif
    }
}

#if canImport(UIKit)
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AudioSessionManager.shared.configuration()
        return true
    }
}
#endif
