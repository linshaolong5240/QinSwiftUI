//
//  UINavigationController+Extension.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2021/4/7.
//

import Foundation
import UIKit

//SwiftUI 隐藏导航栏后返回手势失效问题
//https://stackoverflow.com/questions/59921239/hide-navigation-bar-without-losing-swipe-back-gesture-in-swiftui
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
