//
//  GroveBar+Animator.swift
//  GroveBar
//
//  Created by XMFraker on 2022/6/28.
//

import Foundation
import QuartzCore

public protocol StyleBarViewProtocol: UIView {
    
    var style: GroveBar.Style { get }
    
    var title: String? { set get }
    var subtitle: String? { set get }
    var displayIndicatorView: Bool { set get }
    func display(leftView: UIView?)
    func display(customView: UIView?)
#if DEBUG
    func update(style: GroveBar.Style)
#endif
}

public protocol AnimatorProtocol: AnyObject {
    
    typealias Completion = () -> Void
    var completion: Completion? { get set }
    var barView: StyleBarViewProtocol { get }
    func animateIn(with duration: Double, completion: AnimatorProtocol.Completion?)
    func animateOut(with duration: Double, completion: AnimatorProtocol.Completion?)
    init(barView: StyleBarViewProtocol)
}

extension GroveBar {
    
    class Animator: NSObject, AnimatorProtocol {
        
        var barView: StyleBarViewProtocol
        
        required init(barView: StyleBarViewProtocol) {
            self.barView = barView
        }
        
        static func animator(with barView: StyleBarViewProtocol) -> AnimatorProtocol {
            return Animator.init(barView: barView)
        }
        
        var completion: AnimatorProtocol.Completion?
        
        func animateIn(with duration: Double, completion: AnimatorProtocol.Completion? = nil) {

            let (style, barView) = (barView.style, self.barView)
            
            // Reset old animation & completion
            self.completion = nil
            barView.layer.removeAllAnimations()
            
            // Reset to initial state
            if style.animationStyle == .fade {
                (barView.alpha, barView.transform) = (.zero, .identity)
            } else {
                (barView.alpha, barView.transform) = (1.0, barView.transform.translatedBy(x: .zero, y: -barView.frame.height))
            }
            
            // Perform new animation
            if style.animationStyle == .bounce {
                self.completion = completion
                self.animateBounceAnimation()
            } else {
                UIView.animate(withDuration: duration) {
                    (barView.alpha, barView.transform) = (1.0, .identity)
                } completion: {
                    if $0, let completion = completion { completion() }
                }
            }
        }
        
        func animateOut(with duration: Double, completion: AnimatorProtocol.Completion? = nil) {

            let (barView, animationStyle) = (self.barView, barView.style.animationStyle)
            UIView.animate(withDuration: duration) {
                if animationStyle == .fade {
                    barView.alpha = .zero
                } else {
                    barView.transform = .identity.translatedBy(x: .zero, y: -barView.frame.height)
                }
            } completion: {
                if $0, let completion = completion { completion() }
            }
        }
    }
}

extension GroveBar.Animator: CAAnimationDelegate {
    
    func animateBounceAnimation() {
        let easyOutBounce: ((CGFloat) -> CGFloat) = { t in
            if (t < 4.0 / 11.0) { return pow(11.0 / 4.0, 2.0) * pow(t, 2.0) }
            if (t < 8.0 / 11.0) { return 3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(t - 6.0 / 11.0, 2) }
            if (t < 10.0 / 11.0) { return 15.0 / 16.0 + pow(11.0 / 4.0, 2) * pow(t - 9.0 / 11.0, 2) }
            return 63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(t - 21.0 / 22.0, 2)
        }
        
        let (fromCenterY, toCenterY, steps) = (-barView.bounds.height, CGFloat.zero, 200)
        var values: [NSValue] = []
        for t in 1...steps {
            let easedTime = easyOutBounce((CGFloat(t) * 1.0)/CGFloat(steps))
            let easedValue = fromCenterY + easedTime * (toCenterY - fromCenterY)
            values.append(.init(caTransform3D: CATransform3DMakeTranslation(.zero, easedValue, .zero)))
        }
    
        let animation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.timingFunction = .init(name: .linear)
        animation.duration = 0.75
        animation.values = values
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.delegate = self
        barView.layer.setValue(toCenterY, forKeyPath: "transform")
        barView.layer.add(animation, forKey: "GroveBounceAnimation")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }
        barView.transform = .identity
        barView.layer.removeAllAnimations()
        if let completion = self.completion { completion() }
    }
}
