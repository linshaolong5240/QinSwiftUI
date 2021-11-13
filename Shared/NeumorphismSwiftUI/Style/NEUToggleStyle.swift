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
        
        let buttonColors: [Color] = neuBacgroundColors(colorScheme)
        let backgroundColors: [Color] = neuBacgroundColors(colorScheme).reversed()
        let orangeColors: [Color] = neuOrangeColors(colorScheme)
        
        HStack {
            configuration.label
            ZStack {
                LinearGradient(gradient: Gradient(colors: configuration.isOn ? orangeColors : backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing)
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
                            .fill(LinearGradient(gradient: Gradient(colors: buttonColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 28, height: 28)
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
            .mask(Capsule())
            .frame(width: 50, height: 31)
            .modifier(NEUShadowModifier())
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
                Toggle("Label", isOn: .constant(true)).toggleStyle(NEUDefaultToggleStyle())
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
