//
//  NEUTextFieldStyle.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/10.
//

import SwiftUI

struct NEUTextFieldStyle<Label>: TextFieldStyle where Label: View {
    let label: Label
    init(label: Label) {
        self.label = label
    }
    func _body(configuration: TextField<Self._Label>) -> some View {
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
    }
}
#endif

struct NEULightTextFieldBackground: View {
    var body: some View {
        ZStack {
            Color.lightBackgourdStart
            LinearGradient(.lightOrangeEnd, .lightOrangeMiddle, .lightOrangeStart)
                .mask(RoundedRectangle(cornerRadius: 12))
                .padding(5)
                .shadow(color: Color.black.opacity(0.25), radius: 5, x: -5, y: -5)
                .shadow(color: Color.white, radius: 5, x: 5, y: 5)
                .mask(RoundedRectangle(cornerRadius: 15))
        }
        .mask(RoundedRectangle(cornerRadius: 15))
    }
}
struct NEUDarkTextFieldBackground: View {
    var body: some View {
        ZStack {
            Color.darkBackgourdStart
            LinearGradient(.darkOrangeEnd, .darkOrangeMiddle, .darkOrangeStart)
                .mask(RoundedRectangle(cornerRadius: 12))
                .padding(5)
                .shadow(color: .darkBackgourdEnd, radius: 5, x: -5, y: -5)
                .shadow(color: .darkBackgourdStart, radius: 5, x: 5, y: 5)
                .mask(RoundedRectangle(cornerRadius: 15))
        }
        .mask(RoundedRectangle(cornerRadius: 15))
    }
}
struct NEUTextFieldBackground: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if colorScheme == .light {
            NEULightTextFieldBackground()
        }else {
            NEUDarkTextFieldBackground()
        }
    }
}
