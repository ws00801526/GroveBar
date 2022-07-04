//
//  GroveBar+BarView.swift
//  GroveBar
//
//  Created by XMFraker on 2022/6/28.
//

import Foundation

extension GroveBar {
    public class BarView: UIView, StyleBarViewProtocol {
        
        static let specialViewTag = 10203040
        
        public var style: GroveBar.Style { didSet { updateStyle() } }
        private(set) var leftView: UIView? { didSet { updateLeftView() } }
        private(set) var customView: UIView? { didSet { updateCustomView() } }
        private(set) var progressPercent: Float = .zero
        
        private lazy var contentView: UIView = .init()
        private lazy var pillView: UIView = .init()
        private lazy var titleLabel: UILabel = .init()
        private lazy var subtitleLabel: UILabel = .init()
        private lazy var progressView: UIView = .init()
        private lazy var indicatorView: UIActivityIndicatorView = .init(style: .white)
                
        private lazy var hstackView: UIStackView = .init()
        private lazy var vstackView: UIStackView = .init()

        private(set) lazy var longPress: UILongPressGestureRecognizer = {
            let press = UILongPressGestureRecognizer.init()
            press.minimumPressDuration = .zero
            press.isEnabled = true
            press.delegate = self
            return press
        }()
        
        private(set) lazy var pan: UIPanGestureRecognizer = {
            let pan = UIPanGestureRecognizer.init()
            pan.isEnabled = true
            pan.delegate = self
            return pan
        }()
        
        @available (*, deprecated, renamed: "init(style:)", message: "using init(style:) insteaded")
        override init(frame: CGRect) { fatalError() }
        
        @available (*, deprecated, renamed: "init(style:)", message: "using init(style:) insteaded")
        required init?(coder: NSCoder) { fatalError() }
        
        public required init() {
            self.style = .init()
            super.init(frame: .zero)
            makeUI()
            makeUIConstraints()
        }
        
        public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard isUserInteractionEnabled else { return nil }
            return contentView.hitTest(convert(point, to: contentView), with: event)
        }
        
        public override func updateConstraints() {
            super.updateConstraints()
            
            removeConstraintsOf(targetView: contentView, and: [.width, .height])
            removeConstraintsOf(targetView: hstackView)
            if let view = leftView { removeConstraintsOf(targetView: view, and: [.width, .height]) }
            if let view = customView { removeConstraintsOf(targetView: view, and: [.width, .height]) }

            updateContentViewConstraints()
            updateHStackViewConstraints()
            updateCustomViewConstraints()
            updateLeftViewConstraints()
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            guard style.background.style == .pill else { return }
            pillView.layer.cornerRadius = contentView.frame.height / 2.0

            if let customView = customView {
                let mask: CAShapeLayer = .init()
                mask.backgroundColor = UIColor.red.cgColor
                let path: UIBezierPath = .init(roundedRect: contentView.bounds, cornerRadius: contentView.frame.height / 2.0)
                mask.path = path.cgPath
                customView.layer.mask = mask
            }
        }
    }
}

// MARK: - Update Methods

public extension GroveBar.BarView {
    
    var title: String? {
        set {
            titleLabel.text = newValue
            titleLabel.isHidden = newValue?.isEmpty ?? true
            titleLabel.sizeToFit()
            vstackView.isHidden = vstackView.arrangedSubviews.allSatisfy(\.isHidden)
        }
        get { titleLabel.text }
    }
    
    var subtitle: String? {
        set {
            subtitleLabel.text = newValue
            subtitleLabel.isHidden = newValue?.isEmpty ?? true
            subtitleLabel.sizeToFit()
            vstackView.isHidden = vstackView.arrangedSubviews.allSatisfy(\.isHidden)
        }
        get { subtitleLabel.text }
    }
    
    var displayIndicatorView: Bool {
        set {
            leftView = newValue ? indicatorView : nil
            if newValue { indicatorView.startAnimating() }
            else { indicatorView.stopAnimating() }
        }
        get { leftView == indicatorView }
    }
    
    func display(leftView: UIView?) { self.leftView = leftView }
    
    func display(customView: UIView?) { self.customView = customView }
    
    func update(style: GroveBar.Style) { self.style = style }
}

// MARK: - Progress Methods

internal extension GroveBar.BarView {
    
    
    private func progressRect(of percent: Float) -> CGRect {
        
        let maxWidth: CGFloat = contentView.bounds.width
        let cSize = contentView.sizeThatFits(.init(width: maxWidth, height: -1.0))
        if cSize.width.isZero || cSize.height.isZero { return .zero }
        let height = min(cSize.height, max(0.5, style.progressBar.height))
        let width = (cSize.width - 2 * style.progressBar.horizontalInsets) * CGFloat(percent)
        let xOffset = style.progressBar.horizontalInsets
        var yOffset: CGFloat = style.progressBar.yOffset
        switch style.progressBar.position {
        case .top: break
        case .center: yOffset = ((cSize.height - height) / 2.0).rounded() + yOffset
        case .bottom: yOffset = cSize.height - height + yOffset
        }
        return .init(x: xOffset, y: yOffset, width: width, height: height)
    }
    
    func animate(to progress: Float, animateDuration duration: Double = 0.0, completion: (() -> Void)? = nil) {
     
        // clamp progress
        let percent = min(1.0, max(0.0, progress))
        progressView.layer.removeAllAnimations()
        defer { self.progressPercent = percent }

        // hide progressView if progress <= 0 && duration <= 0
        if percent <= 0 && duration <= 0 {
            progressView.isHidden = true
            progressView.frame = progressRect(of: .zero)
            return
        }
        
        progressView.isHidden = false
        progressView.frame = progressRect(of: self.progressPercent)

        // update progressView frame
        if duration.isZero {
            progressView.frame = progressRect(of: percent)
            if let completion = completion { completion() }
        } else {
            
            // Update progressView.layer.mask
            let rect = progressRect(of: percent)
            let mask: CAShapeLayer = .init()
            mask.path = UIBezierPath.init(roundedRect: .init(origin: .zero, size: rect.size), cornerRadius: rect.height / 2.0).cgPath
            progressView.layer.mask = mask

            UIView.animate(withDuration: duration) {
                self.progressView.frame = rect
                self.layoutIfNeeded()
            } completion: {
                if $0, let completion = completion { completion() }
            }
        }
    }
}

// MARK: - Private Methods

private extension GroveBar.BarView {
    
    func makeUI() {
        titleLabel.tag = GroveBar.BarView.specialViewTag
        titleLabel.backgroundColor = .clear
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.isHidden = true
        
        subtitleLabel.tag = GroveBar.BarView.specialViewTag
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.baselineAdjustment = .alignCenters
        subtitleLabel.adjustsFontSizeToFitWidth = false
        subtitleLabel.isHidden = true
                        
        pillView.tag = GroveBar.BarView.specialViewTag
        contentView.tag = GroveBar.BarView.specialViewTag
        progressView.tag = GroveBar.BarView.specialViewTag
        hstackView.tag = GroveBar.BarView.specialViewTag
        vstackView.tag = GroveBar.BarView.specialViewTag
        
        contentView.backgroundColor = .clear
        addSubview(contentView)
        contentView.addSubview(pillView)
        contentView.addSubview(progressView)
        contentView.addSubview(hstackView)

        vstackView.isHidden = true
        vstackView.axis = .vertical
        vstackView.spacing = .zero
        vstackView.addArrangedSubview(titleLabel)
        vstackView.addArrangedSubview(subtitleLabel)
        
        hstackView.axis = .horizontal
        hstackView.alignment = .center
        hstackView.addArrangedSubview(vstackView)
        
        addGestureRecognizer(pan)
        addGestureRecognizer(longPress)
    }
        
    func updateContentViewStyle() {

        pillView.backgroundColor = style.background.color
        if style.background.style == .pill {
            backgroundColor = .clear

            pillView.layer.cornerRadius = style.background.minimumHeight / 2.0
            pillView.layer.allowsEdgeAntialiasing = true
            if #available(iOS 13.0, *) { pillView.layer.cornerCurve = .continuous }
            pillView.layer.masksToBounds = false

            pillView.layer.borderWidth = style.background.borderWidth
            pillView.layer.borderColor = style.background.borderColor.cgColor
            
            pillView.layer.shadowColor = style.background.shadowColor.cgColor
            pillView.layer.shadowRadius = style.background.shadowRadius
            pillView.layer.shadowOffset = style.background.shadowOffset
            pillView.layer.shadowOpacity = 1.0
        } else {
            pillView.layer.cornerRadius = .zero
            pillView.layer.shadowOpacity = .zero
            pillView.layer.borderColor = UIColor.clear.cgColor
            pillView.layer.shadowColor = UIColor.clear.cgColor
            backgroundColor = style.background.color
        }
    }
    
    func updateLabelStyle(for label: UILabel, with style: GroveBar.Style.TextStyle, alignment: NSTextAlignment = .center) {
        if let attributes = style.attributes { label.attributedText = .init(string: label.text ?? "", attributes: attributes) }
        else { (label.font, label.textColor, label.textAlignment) = (style.font, style.color, alignment) }
        (label.shadowColor, label.shadowOffset) = (style.shadowColor, style.shadowOffset)
    }

    func updateStyle() {
        
        // enable/disable gesture recognizers
        pan.isEnabled = style.canSwipeToDismiss
        longPress.isEnabled = style.canTapToHold
        indicatorView.color = style.title.color
        
        updateProgressStyle()
        updateContentViewStyle()
        updateLabelStyle(for: titleLabel, with: style.title, alignment: style.leftView.alignment == .left ? .left : .center)
        updateLabelStyle(for: subtitleLabel, with: style.subtitle, alignment: style.leftView.alignment == .left ? .left : .center)
        if let _ = superview { setNeedsUpdateConstraints() }
    }
    
    func updateProgressStyle() {
        progressView.backgroundColor = style.progressBar.color
        progressView.layer.cornerRadius = style.progressBar.cornerRadius
        progressView.frame = progressRect(of: progressPercent)
    }
    
    func updateLeftView() {
        removeUnnecessarySubviews()
        if let leftView = leftView { contentView.addSubview(leftView) }
        if let _ = superview { setNeedsUpdateConstraints() }
    }
    
    func updateCustomView() {
        removeUnnecessarySubviews()
        if let customView = customView { contentView.addSubview(customView) }
        if let _ = superview { setNeedsUpdateConstraints() }
    }
    
    /// remove all views added from outside.
    func removeUnnecessarySubviews() {
        for subview in contentView.subviews {
            if subview.tag != GroveBar.BarView.specialViewTag { subview.removeFromSuperview() }
        }

        for subview in hstackView.arrangedSubviews {
            if subview.tag != GroveBar.BarView.specialViewTag { hstackView.removeArrangedSubview(subview) }
        }
    }
}


// MARK: - Private Constriant Methods

private extension GroveBar.BarView {
    
    func contentRect() -> CGRect {
        var yOffset = superview?.layoutMargins.top ?? .zero
        if yOffset <= 8 {
            if #available(iOS 13.0, *) {
                yOffset = window?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? .zero
            } else {
                yOffset = UIApplication.shared.statusBarFrame.height
            }
        }
        return .init(x: .zero, y: yOffset, width: frame.width, height: frame.height - yOffset)
    }
    
    func makeUIConstraints() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        pillView.translatesAutoresizingMaskIntoConstraints = false
        pillView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        pillView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        pillView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        pillView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        hstackView.translatesAutoresizingMaskIntoConstraints = false
    }

    func updateLeftViewConstraints() {
        if let leftView = leftView, leftView.superview == contentView {
            
            // Remove all constraints added to hstackView
            let constraints = contentView.constraints.filter({
                if let view = $0.firstItem as? UIView, view == leftView { return true }
                if let view = $0.secondItem as? UIView, view == leftView { return true }
                return false
            })
            contentView.removeConstraints(constraints)
            
            leftView.translatesAutoresizingMaskIntoConstraints = false
            leftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: style.background.contentInsets.left).isActive = true
            leftView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            let size: CGSize? = leftView == indicatorView ? .init(width: 24.0, height: 24.0) : style.leftView.size
            if let size = size, size.width.isNormal, size.height.isNormal {
                leftView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                leftView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            } else {
                leftView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: style.background.contentInsets.top).isActive = true
                leftView.widthAnchor.constraint(greaterThanOrEqualTo: leftView.heightAnchor).isActive = true
            }
            
            contentView.removeConstraints(contentView.constraints.filter({
                if let view = $0.firstItem as? UIView, view == self.hstackView, ($0.firstAttribute == .leading || $0.secondAttribute == .leading) { return true }
                if let view = $0.secondItem as? UIView, view == self.hstackView, ($0.firstAttribute == .leading || $0.secondAttribute == .leading) { return true }
                return false
            }))
            hstackView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: style.leftView.spacing).isActive = true
        } else {
            hstackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: style.background.contentInsets.left).isActive = true
        }
    }
    
    private func removeConstraintsOf(targetView: UIView, and attributes: [NSLayoutConstraint.Attribute] = []) {
        
        if !attributes.isEmpty {
            let constraints = targetView.constraints.filter({ attributes.contains($0.firstAttribute) || attributes.contains($0.secondAttribute) })
            targetView.removeConstraints(constraints)
        }
        
        guard let superview = targetView.superview else { return }
        let constraints = superview.constraints.filter({
            if let view = $0.firstItem as? UIView, view == targetView { return true }
            if let view = $0.secondItem as? UIView, view == targetView { return true }
            return false
        })
        superview.removeConstraints(constraints)
    }
    
    func updateContentViewConstraints() {
        
        // Remove all constriants added to contentView
        let attributes: [NSLayoutConstraint.Attribute] = [.width, .height]
        let constraints = contentView.constraints.filter({ attributes.contains($0.firstAttribute) || attributes.contains($0.secondAttribute) })
        contentView.removeConstraints(constraints)
        
        let contentRect = contentRect()
        if style.background.style == .fullWidth {
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: contentRect.origin.y).isActive = true
            contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        } else {
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: contentRect.origin.y + style.background.topSpacing).isActive = true
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20.0).isActive = true
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: style.background.minimumHeight).isActive = true
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: style.background.minimumWidth).isActive = true
        }
    }
    
    func updateHStackViewConstraints() {
        
        let insets: UIEdgeInsets = style.background.contentInsets
        if style.background.style == .fullWidth {
            NSLayoutConstraint.activate([
                hstackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: insets.left),
                hstackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: insets.top),
                hstackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                hstackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                hstackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: insets.left),
                hstackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -insets.right),
                hstackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: insets.top),
                hstackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
        }
    }
    
    func updateCustomViewConstraints() {
        hstackView.isHidden = customView != nil
        guard let customView = customView, customView.superview == contentView else { return }

        customView.translatesAutoresizingMaskIntoConstraints = false
        if customView.frame.width.isZero || customView.frame.height.isZero {
            NSLayoutConstraint.activate([
                customView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                customView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                customView.topAnchor.constraint(equalTo: contentView.topAnchor),
                customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                customView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                customView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                customView.topAnchor.constraint(equalTo: contentView.topAnchor),
                customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                customView.widthAnchor.constraint(equalToConstant: max(customView.frame.width, style.background.minimumWidth)),
                customView.heightAnchor.constraint(equalToConstant: customView.frame.height),
            ])
        }
    }
}


// MARK: - UIGestureRecognizerDelegate

extension GroveBar.BarView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer == longPress
    }
}
