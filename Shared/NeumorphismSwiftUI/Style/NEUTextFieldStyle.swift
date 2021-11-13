//
//  NEUTextFieldStyle.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/10.
//

import SwiftUI

protocol NEUTextFieldStyle: TextFieldStyle, NEUStyle {
    
}

public struct NEUDefaultTextFieldStyle<Label>: NEUTextFieldStyle where Label: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let label: Label
    
    init(label: Label) {
        self.label = label
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        let backgroundColors: [Color] = neuBacgroundColors(colorScheme)
        let orangeColors: [Color] = .lightOrangeColors.reversed()

        HStack() {
            label
            configuration
                .padding(.trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(
            ZStack {
                LinearGradient(gradient: Gradient(colors: backgroundColors.reversed()), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .mask(Capsule())
                    .modifier(NEUShadowModifier())
                LinearGradient(gradient: Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .mask(Capsule())
                    .padding(5)
            }
        )
    }
}

#if DEBUG
fileprivate struct NEUTextFieldStyleDEBUGView: View {
    
    @State private var text: String = "Loong"
    
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                TextField("Placeholder", text: $text)
                    .textFieldStyle(NEUDefaultTextFieldStyle(label: Text("Test:")))
            }
        }
    }
}

struct NEUTextFieldStyle_Previews: PreviewProvider {
    static var previews: some View {
        NEUTextFieldStyleDEBUGView()
        .preferredColorScheme(.light)
        NEUTextFieldStyleDEBUGView()
        .preferredColorScheme(.dark)
    }
}
#endif
