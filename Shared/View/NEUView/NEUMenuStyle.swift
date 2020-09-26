//
//  NEUMenuStyle.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/10.
//

import SwiftUI

struct NEUMenuStyle<S>: MenuStyle where S: Shape{
    let shape: S
    
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .background(NEUButtonBackground(isHighlighted: false, shape: shape))
    }
}

#if DEBUG
struct NEUMenuStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            Menu {
                Button("Open in Preview", action: {})
                Button("Save as PDF", action: {})
            } label: {
                NEUSFView(systemName: "ellipsis")
            }
            .menuStyle(NEUMenuStyle(shape: Circle()))
        }
    }
}
#endif
