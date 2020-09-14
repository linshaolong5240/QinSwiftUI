//
//  NEUButtonView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct NEUButtonView: View {
    let systemName: String
    let size: ButtonSize
    let active: Bool
    let activeColor: Color
    let inactiveColor: Color
    init(systemName: String,
         size: ButtonSize = .medium,
         active: Bool = false,
         activeColor: Color = .white,
         inactiveColor: Color = .mainTextColor) {
        self.systemName = systemName
        self.size = size
        self.active = active
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
    }
    var body: some View {
        VStack {
            Image(systemName: systemName)
                .font(.system(size: size.fontSize, weight: .bold))
                .frame(width: size.width, height: size.height)
                .foregroundColor(active ? activeColor : inactiveColor)
        }
    }
}

extension NEUButtonView {
    enum ButtonSize {
        case small
        case medium
        case big
        case large
        
        var width: CGFloat {
            switch self {
            case .small:
                return 40
            case .medium:
                return 48
            case .big:
                return 70
            case .large:
                return 90
            }
        }
        var height: CGFloat {
            switch self {
            case .small:
                return 40
            case .medium:
                return 48
            case .big:
                return 70
            case .large:
                return 90
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small:
                return 15
            case .medium:
                return 15
            case .big:
                return 20
            case .large:
                return 25
            }
        }
    }
}

#if DEBUG
struct NEUButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
//            VStack(spacing: 20.0) {
//                NEUCircleButtonView(systemName: "arrow.left", size: .small, active: true)
//                NEUCircleButtonView(systemName: "arrow.left", size: .medium, active: true)
//                NEUCircleButtonView(systemName: "arrow.left", size: .big, active: true)
//                NEUCircleButtonView(systemName: "arrow.left", size: .large, active: true)
//            }
        }
    }
}
#endif
