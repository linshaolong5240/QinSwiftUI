//
//  UIApplication+Extension.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/5.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
extension UIApplication {
    func endEditing() {
        windows.forEach { $0.endEditing(true )}
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
