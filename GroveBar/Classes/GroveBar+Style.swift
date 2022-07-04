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
        
        /// The style of title.
        public var title: TextStyle
        /// The style of subtitle.
        public var subtitle: TextStyle
        /// The style of leftView.
        public var leftView: ViewStyle
        /// The style of background.
        public var background: BackgroundStyle
        /// The style of progress bar.
        public var progressBar: ProgressBarStyle
        /// The style of system status bar. Default is `default`
        public var systemStatusBar: SystemBarStyle
        /// The animation of `BarView`. Default is `.bounce`
        ///
        /// It will be ignored if you provide
        public var animationStyle: AnimationStyle
        /// The generator of animator.
        ///
        /// Can provide your customized animator for `BarView`
        public var animatorGenerator: ((StyleBarViewProtocol) -> AnimatorProtocol)?
        /// The value can swipe limit. Default is 20
        public var rubberBandingLimit: CGFloat
        /// Defines if the bar can be dismissed by the user swiping up. Default is `true`.
        ///
        /// Under the hood this enables/disables the internal `PanGestureRecognizer`.
        public var canTapToHold: Bool
        /// Defines if the bar can be touched to prevent a dismissal until the tap is released. Default is `true`.
        ///
        /// If ``canTapToHold`` is `true`
        /// and ``canDismissDuringUserInteraction`` is `false`,
        /// the user can tap the notification to prevent it from being dismissed until the tap is released.
        ///
        /// If you are utilizing a custom view and need custom touch handling (e.g. for a button), you should set this to `false`.
        /// Under the hood this enables/disables the internal `LongPressGestureRecognizer`.
        public var canSwipeToDismiss: Bool
        /// Defines if the bar is allowed to be dismissed while the user touches or pans the view.
        ///
        /// The default is `false`, meaning that a notification stays presented as long as a touch or pan is active.
        /// Once the touch is released, the view will be dismised (if a dismiss call was made during the interaction).
        /// Any passed-in dismiss completion block will still be executed, once the actual dismissal happened.
        public var canDismissDuringUserInteraction: Bool
        
        public init(title: GroveBar.Style.TextStyle = .init(color: .darkGray),
                    subtitle: GroveBar.Style.TextStyle = .init(color: .lightGray, font: .systemFont(ofSize: 12.0)),
                    leftView: GroveBar.Style.ViewStyle = .init(),
                    background: GroveBar.Style.BackgroundStyle = .init(),
                    progressBar: GroveBar.Style.ProgressBarStyle = .init(),
                    systemStatusBar: GroveBar.Style.SystemBarStyle = .default,
                    animationStyle: GroveBar.Style.AnimationStyle = .bounce,
                    animatorGenerator: ((StyleBarViewProtocol) -> AnimatorProtocol)? = nil,
                    rubberBandingLimit: CGFloat = 20.0,
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
        
        /// The size of leftView. Default is nil.
        ///
        /// If size is nil or `.zero`. LeftView will actived widthAnchor == heightAnchor constraints.
        public var size: CGSize?
        /// The space between leftView & titleLabel
        public var spacing: CGFloat
        /// The alignment of titleLabel, only used while leftView != nil. Default is ``Alignment/center``
        public var alignment: Alignment
        
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
        /// The color of text
        public var color: UIColor? = nil
        /// The font of text. Default is `.systemFont(ofSize: 14.0)`
        public var font: UIFont = .systemFont(ofSize: 14.0)
        /// The shadowColor of text. Default is nil
        public var shadowColor: UIColor? = nil
        /// The shadowOffset of text, it will be ignored while shadowColor == nil. Default is size(1.0, 2.0)
        public var shadowOffset: CGSize = .init(width: 1.0, height: 2.0)
        /// The custom attribues of text.
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
        
        /// The style of background. Default is ``Style/pill``
        public var style: Style
        /// The color of background. Default is .white
        public var color: UIColor
        /// The top space of background only used while style == .pill. Default is 5.0
        public var topSpacing: CGFloat
        /// The content insets of background. Default is (5.0, 20.0, 5.0, 20.0)
        public var contentInsets: UIEdgeInsets
        /// The minimum height of background only used while style == .pill. Default is 50
        public var minimumHeight: CGFloat
        /// The minimum width of background only used while style == .pill. Default is 200
        public var minimumWidth: CGFloat
        /// The border color of background only used while style == .pill. Default is .clear
        public var borderColor: UIColor
        /// The border width of background only used while style == .pill. Default is .0.5
        public var borderWidth: CGFloat
        /// The shadow color of background only used while style == .pill. Default is .black(0.3)
        public var shadowColor: UIColor
        /// The shadow radius of background only used while style == .pill. Default is 4.0
        public var shadowRadius: CGFloat
        /// The shadow offset of background only used while style == .pill. Default is (0.0, 2.0)
        public var shadowOffset: CGSize
        
        public init(style: GroveBar.Style.BackgroundStyle.Style = .pill,
                    color: UIColor = .white,
                    height: CGFloat = 50.0,
                    topSpacing: CGFloat = 5.0,
                    contentInsets: UIEdgeInsets = .init(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0),
                    minimumWidth: CGFloat = 200.0,
                    borderColor: UIColor = .clear,
                    borderWidth: CGFloat = 2.0,
                    shadowColor: UIColor = .black.withAlphaComponent(0.3),
                    shadowRadius: CGFloat = 4.0,
                    shadowOffset: CGSize = .init(width: 0.0, height: 2.0)) {
            self.style = style
            self.color = color
            self.minimumHeight = height
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
        
        /// The color of progress bar. Default is RGB(36, 159, 230)
        public var color: UIColor?
        /// The height of progress bar. Default is 2.0
        public var height: CGFloat
        /// The position of progress bar. Default is ``Position/bottom``
        public var position: Position
        /// The cornerRadius of progress bar. Default is 1.0
        public var cornerRadius: CGFloat
        /// The horizontalInsets of progress bar. Default is 20.0
        public var horizontalInsets: CGFloat
        /// The yOffset of progress bar. Default is -3.0
        public var yOffset: CGFloat
        
        public init(color: UIColor? = .init(red: 36.0 / 255.0, green: 159.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0),
                    height: CGFloat = 2.0,
                    horizontalInsets: CGFloat = 20.0,
                    position: Position = .bottom,
                    cornerRadius: CGFloat = 1.0,
                    yOffset: CGFloat = -3.0) {
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

