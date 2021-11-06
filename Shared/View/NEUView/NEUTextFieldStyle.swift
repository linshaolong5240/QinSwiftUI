//
//  NEUTextFieldStyle.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/10.
//

import SwiftUI

public struct NEUTextFieldStyle<Label>: TextFieldStyle where Label: View {
    
    let label: Label
    
    init(label: Label) {
        self.label = label
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(spacing: 0.0) {
            label
                .foregroundColor(.mainTextColor)
            configuration
                .padding(.trailing)
        }
        .background(NEUTextFieldBackground())
    }
}

#if DEBUG
struct NEUTextFieldStyle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            NEUBackgroundView()
            VStack {
                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .textFieldStyle(NEUTextFieldStyle(label: Text("test").padding()))
            }
        }
        .preferredColorScheme(.light)
        
        ZStack {
            NEUBackgroundView()
            VStack {
                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .textFieldStyle(NEUTextFieldStyle(label: Text("test").padding()))
            }
        }
        .preferredColorScheme(.dark)
    }
}
#endif

struct NEUTextFieldBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let colors: [Color] = [.lightOrangeEnd, .lightOrangeMiddle, .lightOrangeStart]
        let topLeftShadowColor: Color = colorScheme == .light ? .black.opacity(0.25) : .darkBackgourdEnd
        let bottomRightShadowColor: Color = colorScheme == .light ? Color.white : .darkBackgourdStart

        ZStack {
            colorScheme == .light ? Color.lightBackgourdStart : Color.darkBackgourdStart
            LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
                .mask(RoundedRectangle(cornerRadius: 12))
                .padding(5)
                .shadow(color: topLeftShadowColor, radius: 5, x: -5, y: -5)
                .shadow(color: bottomRightShadowColor, radius: 5, x: 5, y: 5)
                .mask(RoundedRectangle(cornerRadius: 15))
        }
        .mask(RoundedRectangle(cornerRadius: 15))
    }
}
