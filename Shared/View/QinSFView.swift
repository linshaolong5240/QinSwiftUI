//
//  QinSFView.swift
//  Qin
//
//  Created by 林少龙 on 2020/4/28.
//  Copyright © 2020 teenloong. All rights reserved.
//

import SwiftUI

struct QinSFView: View {
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

extension QinSFView {
    enum ButtonSize {
        case small
        case medium
        case big
        case large
        
        var size: CGSize {
            switch self {
            case .small:
                return CGSize(width: 35, height: 35)
            case .medium:
                return CGSize(width: 50, height: 50)
            case .big:
                return CGSize(width: 60, height: 60)
            case .large:
                return CGSize(width: 80, height: 80)
            }
        }
        
        var width: CGFloat { size.width }
        
        var height: CGFloat { size.height }
        
        var fontSize: CGFloat {
            switch self {
            case .small:
                return 10
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
            VStack(spacing: 20.0) {
                Button(action: {}, label: {
                    QinSFView(systemName: "play.fill",size: .medium)
                })
                .buttonStyle(NEUSimpleButtonStyle(shape: Circle()))
            }
        }
        .preferredColorScheme(.dark)
    }
}
#endif
