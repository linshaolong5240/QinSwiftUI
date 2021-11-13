//
//  NEUToggleStyle.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/10.
//

import SwiftUI

public protocol NEUToggleStyle: ToggleStyle, NEUStyle { }

public struct NEUDefaultToggleStyle: NEUToggleStyle {
    
    @Environment(\.colorScheme) private var colorScheme

    public func makeBody(configuration: Self.Configuration) -> some View {
        
        let buttonBackgroundColors: [Color] = neuBacgroundColors(colorScheme)
        let backgroundColor: Color = colorScheme == .light ? Color(#colorLiteral(red: 0.8624982834, green: 0.8703991771, blue: 0.8829225898, alpha: 1)) : Color(#colorLiteral(red: 0.2546238303, green: 0.2623955607, blue: 0.283208847, alpha: 1))
//        let pressedBackgroundColor: Color = colorScheme == .light ? Color(#colorLiteral(red: 0.8624982834, green: 0.8703991771, blue: 0.8829225898, alpha: 1)) : Color(#colorLiteral(red: 0.2546238303, green: 0.2623955607, blue: 0.283208847, alpha: 1))
        
        HStack {
            configuration.label
            ZStack {
                Capsule()
                    .fill(configuration.isOn ? Color.accentColor : backgroundColor)
                    .modifier(NEUShadowModifier())
                HStack {
                    if configuration.isOn {
                        Spacer()
                    }
                    Button(action: {
                        withAnimation {
                            configuration.isOn.toggle()
                        }
                    }) {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: buttonBackgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 28, height: 28)
                            .modifier(NEUShadowModifier())
                    }
                    .buttonStyle(PlainButtonStyle())
                    if !configuration.isOn {
                        Spacer()
                    }
                }
                .padding(.horizontal, 2)
                .frame(width: 50, height: 31)
                .mask(Capsule())
            }
            .frame(width: 50, height: 31)
        }
    }
}

#if DEBUG
fileprivate struct NEUToggleStyleDEBUGView: View {
    @State private var onOff: Bool = false
    var body: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                Toggle("Label", isOn: $onOff) .toggleStyle(SwitchToggleStyle(tint: .red))
                    .fixedSize()
                Toggle("Label", isOn: $onOff).toggleStyle(NEUDefaultToggleStyle())
                    .accentColor(.orange)
            }
        }
    }
}

struct NEUToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        NEUToggleStyleDEBUGView()
        .preferredColorScheme(.light)
        NEUToggleStyleDEBUGView()
        .preferredColorScheme(.dark)
    }
}
#endif
