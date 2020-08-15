//
//  ThemeViewModel.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/14.
//

import Foundation
import SwiftUI

protocol Theme{
    var backgroundView: AnyView { get }
}
class NeuTheme {
    enum NEUColorScheme {
        case light
//        case dark
    }
    static var shared: Theme = LightTheme()
    var colorScheme: NEUColorScheme = .light {
        didSet {
            switch self.colorScheme {
            case .light:
                NeuTheme.shared = LightTheme()
//            case .dark:
//                NeuTheme.shared = DarkTheme()
            }
        }
    }
}

struct LightTheme: Theme {
    struct BackgroundView: View {
        var body: some View {
            LinearGradient(gradient: Gradient(colors: [Color("backgroundColor"),Color("BGC2"),Color("BGC3")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        }
    }
    var backgroundView = AnyView(BackgroundView())
}

struct DarkTheme: Theme {
    struct BackgroundView: View {
        var body: some View {
            LinearGradient(gradient: Gradient(colors: [Color("backgroundColor"),Color("BGC2"),Color("BGC3")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        }
    }
    var backgroundView = AnyView(BackgroundView())
}
