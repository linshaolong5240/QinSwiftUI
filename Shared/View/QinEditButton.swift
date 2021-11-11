//
//  QinEditButton.swift
//  Qin
//
//  Created by 林少龙 on 2021/11/12.
//

import SwiftUI

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
            QinSFView(systemName: "square.and.pencil", size: .small, active: editModeBinding?.wrappedValue.isEditing ?? false)
        }
        .buttonStyle(NEUButtonToggleStyle(isHighlighted: editModeBinding?.wrappedValue.isEditing ?? false, shape: Circle()))
    }
}

#if DEBUG
struct QinEditButton_Previews: PreviewProvider {
    static var previews: some View {
        QinEditButton(action: {})
    }
}
#endif
