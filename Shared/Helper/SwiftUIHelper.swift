//
//  SwiftUIHelper.swift
//  SwiftHelper
//
//  Created by 林少龙 on 2021/12/13.
//

import SwiftUI

#if canImport(UIKit)
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
struct ViewRepresentable<T: UIView>: UIViewRepresentable {
    let view: T
    
    init(_ view: T) {
        self.view = view
    }

    func makeUIView(context: Context) -> T {
        return view
    }
    
    func updateUIView(_ uiView: T, context: Context) {
        
    }
    
    typealias UIViewType = T
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
struct ViewControllerRepresentable<T: UIViewController>: UIViewControllerRepresentable {
    let viewController: T
    
    init(_ viewController: T) {
        self.viewController = viewController
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    typealias UIViewControllerType = T
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

extension View {
    //StackNavigationViewStyle
    func popToRootView() {
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

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


fileprivate var currentOverCurrentContextUIHost: UIHostingController<AnyView>? = nil

extension View {
    public func present<Content>(
        isPresented: Binding<Bool>,
        animated: Bool = false,
        dismissAnimate: Bool = false,
        modalPresentationStyle: UIModalPresentationStyle = .overCurrentContext,
        modalTransitionStyle: UIModalTransitionStyle = .crossDissolve,
        _ content: () -> Content
    ) -> some View  where Content: View {
        func findValidPresentViewController(from vc: UIViewController) -> UIViewController? {
            if let presentedViewController = vc.presentedViewController {
                return findValidPresentViewController(from: presentedViewController)
            }
            return vc
        }
        if isPresented.wrappedValue && currentOverCurrentContextUIHost == nil {
            let contentController = UIHostingController(rootView: AnyView(content()))
            contentController.view.backgroundColor = .clear
            currentOverCurrentContextUIHost = contentController
            
            contentController.modalPresentationStyle = modalPresentationStyle
            contentController.modalTransitionStyle = modalTransitionStyle
            
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                findValidPresentViewController(from: rootVC)?.present(contentController, animated: animated, completion: nil)
            }
        } else {
            if let contentController = currentOverCurrentContextUIHost {
                contentController.dismiss(animated: dismissAnimate, completion: {})
                currentOverCurrentContextUIHost = nil
            }
        }
        return self
    }
}
#endif

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
