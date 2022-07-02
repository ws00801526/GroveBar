//
//  GroveBar+Style.swift
//  GroveBar
//
//  Created by XMFraker on 2022/6/28.
//

import Foundation

// MARK: - GroveBar.Style

public extension GroveBar {
    
    struct Style {

        public var title: TextStyle = .init(color: .darkGray)
        public var subtitle: TextStyle = .init(color: .lightGray, font: .systemFont(ofSize: 12.0))
        public var leftView: ViewStyle = .init()
        public var background: BackgroundStyle = .init()
        public var progressBar: ProgressBarStyle = .init()
        public var systemStatusBar: SystemBarStyle = .default
        public var animationStyle: AnimationStyle = .bounce
        public var animatorGenerator: ((StyleBarViewProtocol) -> AnimatorProtocol)? = nil
        public var rubberBandingLimit: CGFloat = 20.0
        public var canTapToHold: Bool = true
        public var canSwipeToDismiss: Bool = true
        public var canDismissDuringUserInteraction: Bool = false
        
        public init(title: GroveBar.Style.TextStyle = .init(color: .darkGray),
                    subtitle: GroveBar.Style.TextStyle = .init(color: .lightGray, font: .systemFont(ofSize: 12.0)),
                    leftView: GroveBar.Style.ViewStyle = .init(),
                    background: GroveBar.Style.BackgroundStyle = .init(),
                    progressBar: GroveBar.Style.ProgressBarStyle = .init(),
                    systemStatusBar: GroveBar.Style.SystemBarStyle = .default,
                    animationStyle: GroveBar.Style.AnimationStyle = .bounce,
                    animatorGenerator: ((StyleBarViewProtocol) -> AnimatorProtocol)? = nil,
                    rubberBandingLimit: CGFloat = 40.0,
                    canSwipeToDismiss: Bool = true,
                    canTapToHold: Bool = true,
                    canDismissDuringUserInteraction: Bool = false) {
            self.title = title
            self.subtitle = subtitle
            self.leftView = leftView
            self.background = background
            self.progressBar = progressBar
            self.systemStatusBar = systemStatusBar
            self.animationStyle = animationStyle
            self.rubberBandingLimit = rubberBandingLimit
            self.animatorGenerator = animatorGenerator
            self.canSwipeToDismiss = canSwipeToDismiss
            self.canTapToHold = canTapToHold
            self.canDismissDuringUserInteraction = canDismissDuringUserInteraction
        }
    }
}

// MARK: - View Style
public extension GroveBar.Style {
    
    struct ViewStyle {
        
        public enum Alignment {
            case left
            case center
        }
        
        public var size: CGSize? = nil
        public var spacing: CGFloat = 5.0
        public var alignment: Alignment = .center
        
        public init(size: CGSize? = nil, spacing: CGFloat = 5.0, alignment: Alignment = .center) {
            self.size = size
            self.spacing = spacing
            self.alignment = alignment
        }
    }
}


// MARK: - Text Style
public extension GroveBar.Style {
    
    struct TextStyle {
        public var color: UIColor? = nil
        public var font: UIFont = .systemFont(ofSize: 14.0)
        public var shadowColor: UIColor? = nil
        public var shadowOffset: CGSize = .init(width: 1.0, height: 2.0)
        public var attributes: [NSAttributedString.Key : Any]?
        
        public init(color: UIColor? = nil,
                    font: UIFont = .systemFont(ofSize: 14.0),
                    shadowColor: UIColor? = nil,
                    shadowOffset: CGSize = .init(width: 1.0, height: 2.0),
                    attributes: [NSAttributedString.Key : Any]? = nil) {
            self.color = color
            self.font = font
            self.shadowColor = shadowColor
            self.shadowOffset = shadowOffset
            self.attributes = attributes
        }
    }
}

// MARK: - Background Style

public extension GroveBar.Style {
        
    struct BackgroundStyle {
        
        public enum Style {
            case pill
            case fullWidth
        }

        public var style: Style = .pill
        public var color: UIColor = .white
        public var height: CGFloat = 50.0
        public var topSpacing: CGFloat = .zero
        public var contentInsets: UIEdgeInsets = .init(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0)
        public var minimumWidth: CGFloat = 200.0
        public var borderColor: UIColor = .clear
        public var borderWidth: CGFloat = 0.5
        public var shadowColor: UIColor = .black.withAlphaComponent(0.3)
        public var shadowRadius: CGFloat = 4.0
        public var shadowOffset: CGSize = .init(width: 0.0, height: 2.0)
        
        public init(style: GroveBar.Style.BackgroundStyle.Style = .pill,
                    color: UIColor = .white,
                    height: CGFloat = 50.0,
                    topSpacing: CGFloat = .zero,
                    contentInsets: UIEdgeInsets = .init(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0),
                    minimumWidth: CGFloat = 200.0,
                    borderColor: UIColor = .clear,
                    borderWidth: CGFloat = 2.0,
                    shadowColor: UIColor = .black.withAlphaComponent(0.3),
                    shadowRadius: CGFloat = 4.0,
                    shadowOffset: CGSize = .init(width: 0.0, height: 2.0)) {
            self.style = style
            self.color = color
            self.height = height
            self.topSpacing = topSpacing
            self.contentInsets = contentInsets
            self.minimumWidth = minimumWidth
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.shadowColor = shadowColor
            self.shadowRadius = shadowRadius
            self.shadowOffset = shadowOffset
        }
    }
}

// MARK: - ProgressBar Style

public extension GroveBar.Style {
        
    struct ProgressBarStyle {
        
        public enum Position {
            case top
            case center
            case bottom
        }
        
        public var color: UIColor?
        public var height: CGFloat = 2.0
        public var position: Position = .bottom
        public var cornerRadius: CGFloat = 1.0
        public var horizontalInsets: CGFloat = 20.0
        public var yOffset: CGFloat = -5.0
        
        public init(color: UIColor? = .init(red: 36.0 / 255.0, green: 159.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0),
                    height: CGFloat = 2.0,
                    horizontalInsets: CGFloat = 20.0,
                    position: Position = .bottom,
                    cornerRadius: CGFloat = 1.0,
                    yOffset: CGFloat = -5.0) {
            self.color = color
            self.height = height
            self.position = position
            self.cornerRadius = cornerRadius
            self.horizontalInsets = horizontalInsets
            self.yOffset = yOffset
        }
    }

}

// MARK: - Other Style

public extension GroveBar.Style {
    enum AnimationStyle {
        case bounce
        case move
        case fade
    }
        
    enum SystemBarStyle {
        case `default`
        case lightContent
        case darkContent
    }
    
    enum BuiltInStyle {
        case `default`
        case light
        case dark
        case success
        case `failure`
        case warning
        case matrix
    }
    
    typealias StyleHandler = (inout GroveBar.Style) -> GroveBar.Style
}

// MARK: Helpers

public protocol GroveBarStyable {
     var style: GroveBar.Style { get }
}

extension String: GroveBarStyable {
    public var style: GroveBar.Style { GroveBar.shared.styleCache.style(for: self) }
}

extension GroveBar.Style: GroveBarStyable {
    public var style: GroveBar.Style { self }
}

extension GroveBar.Style.BuiltInStyle: GroveBarStyable {
    public var style: GroveBar.Style {
        var style = GroveBar.Style.init()

        switch self {
        case .`default`: return style
        case .light:
            style.title.color = .gray
            style.background.color = .white
            style.systemStatusBar = .darkContent
        case .dark:
            style.title.color = .init(white: 0.95, alpha: 1.0)
            style.background.color = .init(red: 0.05, green: 0.078, blue: 0.12, alpha: 1.0)
            style.systemStatusBar = .lightContent
        case .failure:
            style.background.color = .init(red: 0.588, green: 0.118, blue: .zero, alpha: 1.0)
            style.title.color = .white
            style.subtitle.color = .white.withAlphaComponent(0.6)
            style.progressBar.color = .red
        case .warning:
            style.background.color = .init(red: 0.900, green: 0.734, blue: 0.034, alpha: 1.0)
            style.title.color = .darkGray
            style.subtitle.color = .darkGray.withAlphaComponent(0.75)
            style.progressBar.color = style.title.color;
        case .success:
            style.background.color = .init(red: 0.588, green: 0.797, blue: 0.0, alpha: 1.0)
            style.title.color = .white
            style.subtitle.color = .init(red: 0.2, green: 0.5, blue: 0.2, alpha: 1.0)
            style.progressBar.color = .init(red: 0.106, green: 0.594, blue: 0.319, alpha: 1.0)
        case .matrix:
            style.background.color = .black
            style.title.color = .green
            style.title.font = .init(name: "Courier-Bold", size: 14.0) ?? .systemFont(ofSize: 14.0)
            style.subtitle.color = .white
            style.subtitle.font = .init(name: "Courier", size: 12.0) ?? .systemFont(ofSize: 12.0)
            style.progressBar.color = .green
            style.systemStatusBar = .lightContent
        }
        return style
    }
}

