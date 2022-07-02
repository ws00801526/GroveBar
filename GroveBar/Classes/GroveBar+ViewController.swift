//
//  GroveBar+BarViewController.swift
//  GroveBar
//
//  Created by XMFraker on 2022/6/28.
//

import Foundation
import UIKit

extension GroveBar {

    class BarViewController: UIViewController {
        typealias Completion = () -> Void

        private var panYOffset: CGFloat = .zero
        private var panInitialYOffset: CGFloat = .zero
        
        weak var delegate: BarViewControllerDelegate?
        private var forceDismissalOnTouchesEnded: Bool = false
        private var timer: Timer?
        private var dismissCompletion: Completion?
        private var animator: AnimatorProtocol?
        internal private(set) var barView: BarView
        
        required init() {
            self.barView = .init()
            self.animator = Animator.init(barView: barView)
            super.init(nibName: nil, bundle: nil)
        }
        
        @available (*, deprecated, renamed: "init()", message: "using init() methods insteaded")
        required init?(coder: NSCoder) { fatalError() }
        
        @available (*, deprecated, renamed: "init()", message: "using init() methods insteaded")
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) { fatalError() }

        override func loadView() {
            super.loadView()
            view.backgroundColor = .clear
            view.addSubview(barView)
            barView.pan.addTarget(self, action: #selector(handlePan(_:)))
            barView.longPress.addTarget(self, action: #selector(handleLongPress(_:)))
        }
    }
}

extension GroveBar.BarViewController {
        
    private var mainViewController: UIViewController? { GroveBar.mainViewController(ignoring: self) }
    
    override var shouldAutorotate: Bool { mainViewController?.shouldAutorotate ?? super.shouldAutorotate }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        mainViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        switch barView.style.background.style {
        case .fullWidth:
            switch barView.style.systemStatusBar {
            case .lightContent: return .lightContent
            case .darkContent:
                if #available(iOS 13.0, *) { return .darkContent }
                else { return .default }
            case .`default`: return mainViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
            }
        case .pill: return mainViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
        }
    }
    
    override var prefersStatusBarHidden: Bool { mainViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .fade }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        mainViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            if let delegate = self?.delegate { delegate.animationsForViewTransitionTo(size: size) }
        } completion: { _ in }
    }
}

protocol BarViewControllerDelegate: AnyObject {
    
    func didDismissBar()
    func didUpdateStyle()
    func animationsForViewTransitionTo(size: CGSize)
}

extension GroveBar.BarViewController {
    
    @objc private func timerFired() {
        self.dismiss(with: 0.4, completion: self.dismissCompletion)
    }
    
    private func canDismiss() -> Bool {
        
        // allow dismissal during interaction
        if barView.style.canDismissDuringUserInteraction { return true }
        
        // prevent dismiss during gesture is interaction
        let (pan, long) = (barView.pan, barView.longPress)
        if pan.state == .began || pan.state == .changed { return false }
        if long.state == .began || long.state == .changed { return false }
        
        return true
    }
    
    private func forceDismiss() {
        defer { self.dismissCompletion = nil; self.forceDismissalOnTouchesEnded = false }
        let completion = self.dismissCompletion
        self.dismiss(with: 0.25, completion: completion)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard gesture.isEnabled else { return }
        switch gesture.state {
        case .began:
            gesture.setTranslation(.zero, in: barView)
            (panYOffset, panInitialYOffset) = (.zero, gesture.location(in: barView).y)
        case .changed:
            let transition = gesture.translation(in: barView)
            panYOffset = max(panYOffset, transition.y)
            let canRubberBand = barView.style.background.style == .pill
            let rubberBandingLimit = barView.style.rubberBandingLimit
            let rubberBanding = (panYOffset > 0 && canRubberBand) ? (rubberBandingLimit * (1 + log10(panYOffset/rubberBandingLimit))) : .zero
            let yPostion = transition.y <= panYOffset ? transition.y - panYOffset + rubberBanding : rubberBanding
            barView.transform = .init(translationX: .zero, y: yPostion)
        case .ended, .cancelled, .failed:
            let movement = barView.transform.ty / panInitialYOffset
            if !forceDismissalOnTouchesEnded && -movement <= 0.25 {
                UIView.animate(withDuration: 0.25, animations: { self.barView.transform = .identity })
            } else { forceDismiss() }
        case .possible: break
        @unknown default: break
        }
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.isEnabled else { return }
        switch gesture.state {
        case .ended: if forceDismissalOnTouchesEnded { forceDismiss() }
        default: break
        }
    }
    
    func present(with title: String?, subtitle: String?, style: GroveBar.Style, completion: Completion?) -> UIView {
        
        if let generator = style.animatorGenerator { animator = generator(barView) }
        
        barView.title = title
        barView.subtitle = subtitle
        
        barView.animate(to: .zero)
        barView.displayIndicatorView = false
        barView.update(style: style)
        
        // Remove leftView and customView
        if let view = barView.leftView { view.removeFromSuperview() }
        if let view = barView.customView { view.removeFromSuperview() }
        barView.display(leftView: nil)
        barView.display(customView: nil)

        if let delegate = delegate { delegate.didUpdateStyle() }

        // Reset auto dismiss timer
        timer?.invalidate()
        timer = nil
        self.dismissCompletion = nil
                
        self.animator?.animateIn(with: 0.4, completion: completion)
                
        return barView
    }
    
    func dismiss(after delay: Double = .zero, completion: Completion? = nil) {
        timer?.invalidate()
        self.dismissCompletion = completion
        self.timer = .scheduledTimer(timeInterval: delay, target: self, selector: #selector(timerFired), userInfo: nil, repeats: false)
    }
    
    func dismiss(with duration: Double = .zero, completion: Completion? = nil) {
        
        timer?.invalidate()
        timer = nil
        
        if canDismiss() {
            barView.pan.isEnabled = false
            animator?.animateOut(with: duration, completion: { [weak self] in
                if let delegate = self?.delegate { delegate.didDismissBar() }
                if let completion = completion { completion() }
            })
        } else {
            self.dismissCompletion = completion
            self.forceDismissalOnTouchesEnded = true
        }
    }
}
