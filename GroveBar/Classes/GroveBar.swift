//
//  GroveBar.swift
//  GroveBar
//
//  Created by XMFraker on 2022/6/28.
//

import Foundation

public final class GroveBar {

    public typealias Completion = (GroveBar?) -> Void
    public static let shared: GroveBar = .init()
    private var window: Window? = nil
    internal let styleCache: StyleCache = .init()
}

// MARK: - Private Methods

fileprivate extension GroveBar {
        
    private func dismissStatusBar() {
        guard let _ = self.window else { return }
        self.window?.removeFromSuperview()
        self.window?.isHidden = true
        self.window?.rootViewController = nil
        self.window = nil
    }
    
    func dismiss(after delay: Double, animated: Bool, completion: Completion? = nil) {
        guard let window = self.window else { return }
        let rcompletion = { [weak self] in if let completion = completion { completion(self) } }
        if delay > 0 {
            window.barViewController.dismiss(after: delay, completion: rcompletion)
        } else {
            window.barViewController.dismiss(with: animated ? 0.4 : .zero, completion: rcompletion)
        }
    }
}

// MARK: - Present Methods

public extension GroveBar {

    /// Present a notification using a specified ``GroveBar.Style``.
    /// - Parameters:
    ///   - stylable:
    ///   The name of the style. You can use styles previously added using e.g. ``addStyle(for:with:):``.
    ///   If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
    ///   Or you can provide  the ``GroveBar.Style.BuiltInStyle``.
    ///   Or you can just provide ``GroveBar.Style`` instance..
    ///
    ///   - title: The title to display
    ///   - subtitle: The subtitle to display
    ///   - leftView: The leftView to display
    ///   - customView: The customView to display
    ///   - delay: The notification should be dismissAfter delay.
    ///   - completion: The handler which will be called after notificaiton displayed.
    /// - Returns: The `GroveBar.BarView` instance.
    @discardableResult
    func present(stylable: GroveBarStyable = GroveBar.Style.BuiltInStyle.default,
                 title: String? = nil,
                 subtitle: String? = nil,
                 leftView: UIView? = nil,
                 customView: UIView? = nil,
                 dismissAfter delay: Double = .zero,
                 completion: Completion? = nil) -> UIView? {

        if self.window == nil {
            self.window = .init(style: stylable.style)
            self.window?.handler = { [weak self] in self?.dismissStatusBar() }
        }
        guard let window = self.window else { return nil }
        let barView = window.barViewController.present(with: title, subtitle: subtitle, style: stylable.style) { [weak self] in
            if let completion = completion { completion(self) }
        } as? GroveBar.BarView

        if let view = leftView { barView?.display(leftView: view) }
        if let view = customView { barView?.display(customView: view) }

        window.isHidden = false
        window.barViewController.setNeedsStatusBarAppearanceUpdate()
        if delay > 0 { window.barViewController.dismiss(after: delay) }
        return barView
    }
}

// MARK: - Dismissal Methods

public extension GroveBar {
    
    /// Dismisses any currently displayed notification bar immediately using an animation.
    /// - Parameters:
    ///   - animated: The value should display animation. Default is true.
    ///   - completion: The handle that gets called once the dismiss animation finishes.
    func dismiss(animated: Bool = true, completion: Completion? = nil) {
        dismiss(after: .zero, animated: animated, completion: completion)
    }
    
    /// Dismisses any currently displayed notification bar after delay using an animation.
    /// - Parameters:
    ///   - delay: The delay in seconds, before the notification should be dismissed.
    ///   - completion: The handle that gets called once the dismiss animation finishes.
    func dismiss(after delay: Double, completion: Completion? = nil) {
        dismiss(after: delay, animated: true, completion: completion)
    }
}

// MARK: - Style Methods

public extension GroveBar {

    /// Defines a new default style.
    ///
    /// The new style will be used in all future presentations that have no specific style specified.
    ///
    /// - Parameter handler:  Provides the current default ``GroveBar.Style`` instance for further customization.
    func updateDefaultStyle(with handler: Style.StyleHandler) {
        styleCache.updateDefaultStyle(with: handler)
    }
    
    
    /// Adds a new custom style. This can be used by referencing it using the `styleName`.
    ///
    /// The added style can be used in future presentations by utilizing the same `styleName` in e.g. ``present(stylable:)``.
    /// If a style with the same name already exists,  it will be replaced.
    /// - Parameters:
    ///   - name:  The styleName which will later be used to reference the added style.
    ///   - handler:  Provides the  ``GroveBar.Style``  instance for further customization.
    /// - Returns: Returns the `styleName`, so that this call can be used directly within a presentation call.
    @discardableResult
    func addStyle(for name: String, with handler: Style.StyleHandler) -> String {
        styleCache.addStyle(for: name, with: handler)
        return name
    }
    
    /// Adds a new custom style. This can be used by referencing it using the `styleName`.
    ///
    /// The added style can be used in future presentations by utilizing the same `styleName` in e.g. ``present(stylable:)``.
    /// If a style with the same name already exists,  it will be replaced.
    /// - Parameters:
    ///   - name:  The styleName which will later be used to reference the added style.
    ///   - builtIn: The ``GroveBar.Style.BuiltInStyle``, which you want to base your style on.
    ///   - handler:  Provides the  ``GroveBar.Style``  instance for further customization.
    /// - Returns: Returns the `styleName`, so that this call can be used directly within a presentation call.
    @discardableResult
    func addStyle(for name: String, baseOn builtIn: Style.BuiltInStyle, with handler: Style.StyleHandler) -> String {
        styleCache.addStyle(for: name, baseOn: builtIn, with: handler)
        return name
    }
    
    /// Gets the ``GroveBar.Style`` of styleName.
    ///
    /// - Parameter name: The styleName which you wanted.
    /// - Returns: The ``GroveBar.Style`` of styleName  or  default   ``GroveBar.Style``.
    func style(for name: String) -> GroveBar.Style { styleCache.style(for: name) }

    /// Gets the ``GroveBar.Style`` of builtIn.
    ///
    /// - Parameter name: The builtInStyle which you wanted.
    /// - Returns: The builtIn ``GroveBar.Style``.
    func style(for builtIn: GroveBar.Style.BuiltInStyle) -> GroveBar.Style { styleCache.style(for: builtIn) }
}

// MARK: - Update Methods

public extension GroveBar {
    
    /// Check if a notification is currently displayed.
    var isVisible: Bool { window != nil }
    
    var displayIndicatorView: Bool {
        set { window?.barViewController.barView.displayIndicatorView = newValue }
        get { window?.barViewController.barView.displayIndicatorView ?? false }
    }
    
    /// Updates the title of an existing notification without animation.
    /// - Parameter text: The new text to display as title.
    func update(text: String?) {
        guard let window = window else { return }
        window.barViewController.barView.title = text
    }
    
    /// Updates the subtitle of an existing notification without animation.
    /// - Parameter subtitle: The new subtitle to display as subtitle.
    func update(subtitle: String?) {
        guard let window = window else { return }
        window.barViewController.barView.subtitle = subtitle
    }

    /// Updates the progress of an existing notification.
    /// - Parameters:
    ///   - progress: The  relative progress from 0.0 to 1.0.
    ///   - duration: The duration of the animation from the current percentage to the provided percentage.
    ///   - completion: The handler will be called after animation finished.
    func update(progress: Float, animationDuration duration: Double = .zero, completion: Completion? = nil) {
        guard let window = window else { return }
        DispatchQueue.main.async {
            window.barViewController.barView.animate(to: progress, animateDuration: duration) { [weak self] in
                if let completion = completion { completion(self) }
            }
        }
    }
}
