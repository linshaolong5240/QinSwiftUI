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
        }
        .background(NEUTextFieldBackground())
    }
}

#if DEBUG
struct NEUTextFieldStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                .textFieldStyle(NEUTextFieldStyle(label: Text("test").padding()))
        }
    }
}
#endif

struct NEUTextFieldBackground: View {
    var body: some View {
        ZStack {
            Color.white
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9194737077, green: 0.2849465311, blue: 0.1981146634, alpha: 1)),Color(#colorLiteral(red: 0.9983269572, green: 0.3682751656, blue: 0.2816230953, alpha: 1)),Color(#colorLiteral(red: 0.9645015597, green: 0.5671981573, blue: 0.5118380189, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(5)
                .shadow(color: Color.black.opacity(0.25), radius: 5, x: -5, y: -5)
                .shadow(color: Color.white, radius: 5, x: 5, y: 5)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}
