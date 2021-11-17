//
//  UIDevice+Extension.swift
//  Qin (iOS)
//
//  Created by 林少龙 on 2021/11/18.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return keyWindow?.safeAreaInsets.bottom ?? 0 > 0
    }
}
