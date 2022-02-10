//
//  QinBackwardButton.swift
//  Qin
//
//  Created by teenloong on 2021/11/12.
//

import SwiftUI
import NeumorphismSwiftUI

public struct QinBackwardButton: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    public var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            QinSFView(systemName: "chevron.backward" ,size: .medium)
        }
        .buttonStyle(NEUDefaultButtonStyle(shape: Circle()))
    }
}

#if DEBUG
struct QinBackwardButton_Previews: PreviewProvider {
    static var previews: some View {
        QinBackwardButton()
    }
}
#endif
