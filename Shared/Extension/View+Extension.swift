//
//  UIApplication+Extension.swift
//  Qin
//
//  Created by 林少龙 on 2020/8/5.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
