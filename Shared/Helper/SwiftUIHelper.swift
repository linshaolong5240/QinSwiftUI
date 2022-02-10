//
//  SwiftUIHelper.swift
//  SwiftHelper
//
//  Created by teenloong on 2021/12/13.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    //Conditional modifier https://designcode.io/swiftui-handbook-conditional-modifier
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#if canImport(AppKit)
@available(macOS 10.15, *)
public struct NSViewRepresent<T: NSView>: NSViewRepresentable {
    public let view: T
    
    public init(_ view: T) {
        self.view = view
    }

    public func makeNSView(context: Context) -> T {
        return view
    }
    
    public func updateNSView(_ uiView: T, context: Context) {
        
    }
    
    public typealias NSViewType = T
}

@available(macOS 10.15, *)
public struct NSViewControllerRepresent<T: NSViewController>: NSViewControllerRepresentable {
    public let viewController: T
    
    public init(_ viewController: T) {
        self.viewController = viewController
    }
    
    public func makeNSViewController(context: Context) -> NSViewControllerType {
        return viewController
    }
    
    public func updateNSViewController(_ uiViewController: NSViewControllerType, context: Context) {
        
    }
    
    public typealias NSViewControllerType = T
}

#endif

#if canImport(UIKit)
//Authorization Alert
@available(iOS 13.0, tvOS 13.0, *)
extension Alert {
    public static func systemAuthorization() {
        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    public static let locationAuthorization: Alert = Alert(title: Text("Location Permissions"), message: Text("Location Authorization Desc"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Go to Authorization"), action: { systemAuthorization() }))
    public static let photoLibraryAuthorization: Alert = Alert(title: Text("PhotoLibrary Permissions"), message: Text("PhotoLibrary Authorization Desc"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Go to Authorization"), action: { systemAuthorization() }))
    public static let cameraAuthorization: Alert = Alert(title: Text("Camera Permissions"), message: Text("Camera Authorization Desc"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Go to Authorization"), action: { systemAuthorization() }))
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct UIViewRepresent<T: UIView>: UIViewRepresentable {
    public let view: T
    
    public init(_ view: T) {
        self.view = view
    }

    public func makeUIView(context: Context) -> T {
        return view
    }
    
    public func updateUIView(_ uiView: T, context: Context) {
        
    }
    
    public typealias UIViewType = T
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct UIViewControllerRepresent<T: UIViewController>: UIViewControllerRepresentable {
    public let viewController: T
    
    public init(_ viewController: T) {
        self.viewController = viewController
    }
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    public typealias UIViewControllerType = T
}

//SwiftUI 隐藏导航栏后返回手势失效问题
//https://stackoverflow.com/questions/59921239/hide-navigation-bar-without-losing-swipe-back-gesture-in-swiftui
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension View {
    //StackNavigationViewStyle
    public func popToRootView() {
        func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
            guard let viewController = viewController else {
                return nil
            }

            if let navigationController = viewController as? UINavigationController {
                return navigationController
            }

            for childViewController in viewController.children {
                return findNavigationController(viewController: childViewController)
            }

            return nil
        }
        findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController)?
            .popToRootViewController(animated: true)
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension View {
    public func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
