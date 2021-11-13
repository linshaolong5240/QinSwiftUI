//
//  NEUProgressViewStyle.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/13.
//

import SwiftUI

public struct NEURingProgressViewStyle: ProgressViewStyle, NEUStyle {
    
    @Environment(\.colorScheme) private var colorScheme

    public func makeBody(configuration: Configuration) -> some View {
        
        let bottomColor: Color = Color(#colorLiteral(red: 0.8532857299, green: 0.883516252, blue: 1, alpha: 1))
        let orangeColors: [Color] = neuOrangeColors(colorScheme).reversed()
        let backgroundColors: [Color] = neuBacgroundColors(colorScheme).reversed()
        
        ZStack {
            Circle().fill(LinearGradient(gradient: Gradient(colors: backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing))
                .modifier(NEUShadowModifier())
            Circle()
                .stroke(bottomColor, lineWidth: 5)
            Circle()
                .trim(from: CGFloat(1 - (configuration.fractionCompleted ?? 0)), to: 1)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: orangeColors), startPoint: .topLeading, endPoint: .bottomTrailing),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(.degrees(90))
                .rotation3DEffect(.degrees(180), axis: (x: 10, y: 0, z: 0))
        }
    }
}

#if DEBUG
fileprivate struct NEURingProgressViewStyleDEBUGView: View {
    var body: some View {
        ZStack {
            NEUBackgroundView()
            ProgressView(value: 0.7)
                .progressViewStyle(NEURingProgressViewStyle())
                .frame(width: 100, height: 100, alignment: .center)
        }
    }
}

struct NEUProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        NEURingProgressViewStyleDEBUGView()
        .preferredColorScheme(.light)
        NEURingProgressViewStyleDEBUGView()
        .preferredColorScheme(.dark)
    }
}
#endif
