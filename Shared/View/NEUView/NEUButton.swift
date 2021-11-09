//
//  NEUButton.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/14.
//

import SwiftUI

#if DEBUG
struct NEUButton_Previews: PreviewProvider {
    static var previews: some View {
        NEUBackwardButton()
    }
}
#endif

public struct NEUBackwardButton: View {
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

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct NEUEditButton: View {
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
