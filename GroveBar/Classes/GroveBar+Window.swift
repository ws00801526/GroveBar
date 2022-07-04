//
//  GroveBar+Window.swift
//  GroveBar
//
//  Created by XMFraker on 2022/6/28.
//

import UIKit

extension GroveBar {
    
    class Window: UIWindow {
  
        var handler: (() -> Void)?
        var style: GroveBar.Style { barViewController.barView.style }
        var barViewController: BarViewController
        
        required init(style: GroveBar.Style) {
            self.barViewController = .init()
            super.init(frame: UIScreen.main.bounds)
            self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.backgroundColor = .clear
            self.isUserInteractionEnabled = true
            self.windowLevel = UIWindow.Level.statusBar
            self.barViewController.delegate = self
            self.rootViewController = self.barViewController
        }
        
        @available (iOS 13.0, *)
        required init(windowScene: UIWindowScene, style: GroveBar.Style) {
            self.barViewController = .init()
            super.init(windowScene: windowScene)
            self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.backgroundColor = .clear
            self.isUserInteractionEnabled = true
            self.windowLevel = UIWindow.Level.statusBar
            self.barViewController.delegate = self
            self.rootViewController = self.barViewController
        }
    
        @available(*, deprecated, renamed: "init(style:)", message: "using init(style:) insteaded")
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @available(*, deprecated, message: "using init(style:) insteaded")
        public override init(frame: CGRect) {
            fatalError("init(frame: CGRect) has not been implemented")
        }
        
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            if barViewController.barView.isUserInteractionEnabled { return barViewController.barView.hitTest(point, with: event) }
            return nil
        }
    }
}

extension GroveBar.Window: BarViewControllerDelegate {
    
    private func contentHeight() -> CGFloat {
        switch style.background.style {
        case .fullWidth:
            if UIDevice.current.userInterfaceIdiom == .phone {
                var orientation: UIInterfaceOrientation = .portrait
                if #available(iOS 13.0, *) {
                    orientation = windowScene?.interfaceOrientation ?? .portrait
                } else {
                    orientation = UIApplication.shared.statusBarOrientation
                }
                if orientation.isLandscape { return 32.0 }
            }
            return 44.0
        case .pill:
            return style.background.minimumHeight + style.background.topSpacing
        }
    }
    
    private func statusBarRect() -> CGRect {
        if #available(iOS 13.0, *) {
            if let scene = windowScene { return scene.statusBarManager?.statusBarFrame ?? UIApplication.shared.statusBarFrame }
            return UIApplication.shared.statusBarFrame
        } else {
            return UIApplication.shared.statusBarFrame
        }
    }
    
    private func updateContentViewFrame(for size: CGSize) {
        
        // Update Self.transform\frame
        if let window = GroveBar.mainWindow(ignoring: self) { (self.transform, self.frame) = (window.transform, window.frame) }
       
        // Update barView.frame
        let barView = barViewController.barView
        (barView.transform, barView.frame) = (.identity, .zero)
        barView.frame = .init(origin: .zero, size: .init(width: max(size.width, UIScreen.main.bounds.width), height:  size.height + contentHeight()))

        barView.setNeedsUpdateConstraints()
        
        // Update barView.progress
        barView.animate(to: barView.progressPercent)
    }
    
    func didDismissBar() {
        if let handler = handler { handler() }
    }
    
    func didUpdateStyle() {
        updateContentViewFrame(for: GroveBar.statusBarFrame(of: self).size)
    }
    
    func animationsForViewTransitionTo(size: CGSize) {
        updateContentViewFrame(for: .init(width: size.width, height: GroveBar.statusBarFrame(of: self).height))
    }
}


// MARK: - Helpers

internal extension GroveBar {
    
    static func mainWindow(ignoring window: UIWindow? = nil) -> UIWindow? {
        var allWindows: [UIWindow]
        if #available(iOS 13.0, *) {
            if let scene = window?.windowScene { allWindows = scene.windows }
            else if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene { allWindows = scene.windows }
            else { allWindows = UIApplication.shared.windows }
        } else { allWindows = UIApplication.shared.windows }
        return allWindows.first(where: { !$0.isHidden && $0 != window })
    }
    
    static func mainViewController(ignoring viewController: UIViewController? = nil) -> UIViewController? {
        let window = mainWindow(ignoring: viewController?.view.window)
        var visibleVC = window?.rootViewController
        if let tabBar = visibleVC as? UITabBarController { visibleVC = tabBar.selectedViewController }
        while let vc = visibleVC?.presentedViewController { visibleVC = vc }
        if let nav = visibleVC as? UINavigationController { visibleVC = nav.topViewController }
        if visibleVC == viewController { return nil }
        return visibleVC
    }
    
    static func statusBarFrame(of window: UIWindow? = mainWindow()) -> CGRect {
        if #available(iOS 13.0, *) {
            if let frame = window?.windowScene?.statusBarManager?.statusBarFrame { return frame }
        }
        return UIApplication.shared.statusBarFrame
    }
}
