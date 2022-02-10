//
//  AVRoutePicker.swift
//  Qin
//
//  Created by teenloong on 2022/2/10.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
import AVKit

#if canImport(AppKit)
struct AVRoutePicker: NSViewRepresentable {
    func makeNSView(context: Context) -> AVRoutePickerView {
        let v = AVRoutePickerView()
        return v
    }
    
    func updateNSView(_ nsView: AVRoutePickerView, context: Context) {
        
    }
    
    typealias NSViewType = AVRoutePickerView
    

}
#endif

#if canImport(UIKit)
struct AVRoutePicker: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let v = AVRoutePickerView()
        v.activeTintColor = .orange
        return v
    }
    
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        
    }
    
    typealias UIViewType = AVRoutePickerView
}
#endif

#if DEBUG
struct AVRoutePicker_Previews: PreviewProvider {
    static var previews: some View {
        AVRoutePicker()
    }
}
#endif
