//
//  QinEditButton.swift
//  Qin
//
//  Created by teenloong on 2021/11/12.
//

import SwiftUI
import NeumorphismSwiftUI

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct QinEditButton: View {
    @Environment(\.editMode) private var editModeBinding:  Binding<EditMode>?
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            if editModeBinding?.wrappedValue.isEditing ?? false {
                editModeBinding?.wrappedValue = .inactive
                action()
            }else {
                editModeBinding?.wrappedValue = .active
            }
        }) {
            QinSFView(systemName: "square.and.pencil", size: .medium)
        }
        .buttonStyle(NEUDefaultButtonStyle(shape: Circle(), toggle: editModeBinding?.wrappedValue.isEditing ?? false))

    }
}

#if DEBUG
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
struct QinEditButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            QinBackgroundView()
            QinEditButton(action: {})
        }
    }
}
#endif
