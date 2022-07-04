//
//

import UIKit
import Combine
import GroveBar

@available (iOS 13.0, *)
class CustomTextStyle: ObservableObject, Equatable {
    @Published var font: UIFont
    @Published var textColor: UIColor?
    @Published var textOffsetY: Double
    @Published var shadowColor: UIColor?
    @Published var shadowOffset: CGPoint
    
    init(_ textStyle: GroveBar.Style.TextStyle) {
        font = textStyle.font
        textColor = textStyle.color
        textOffsetY = .zero
        shadowColor = textStyle.shadowColor
        shadowOffset = .init(x: textStyle.shadowOffset.width, y: textStyle.shadowOffset.height)
    }
    
    static func == (lhs: CustomTextStyle, rhs: CustomTextStyle) -> Bool {
        return false // a hack to trigger .onChange(of: style) on every change
    }
    
    func computedStyle() -> GroveBar.Style.TextStyle {
        var style = GroveBar.Style.TextStyle()
        style.color = textColor
        style.font = font
        style.shadowColor = shadowColor
        style.shadowOffset = .init(width: shadowOffset.x, height: shadowOffset.y)
        return style
    }
    
    @SimpleStringBuilder
    func styleConfigurationString(propertyName: String) -> String {
    """
    style.\(propertyName).textColor = \(textColor?.initString ?? "nil")
    style.\(propertyName).font = \(font.initString)
    style.\(propertyName).textOffsetY = \(textOffsetY)
    """
        
        if let textShadowColor = shadowColor {
      """
      style.\(propertyName).shadowColor = \(textShadowColor.initString)
      style.\(propertyName).shadowOffset = \(shadowOffset.initString)
      """
        }
    }
}

@available (iOS 13.0, *)
class ObservableCustomStyle: ObservableObject, Equatable {
    @Published var textStyle: CustomTextStyle
    @Published var subtitleStyle: CustomTextStyle
    
    @Published var backgroundColor: UIColor?
    @Published var backgroundType: GroveBar.Style.BackgroundStyle.Style
    
    @Published var minimumPillWidth: Double
    @Published var pillHeight: Double
    @Published var pillSpacingY: Double
    @Published var pillBorderColor: UIColor?
    @Published var pillBorderWidth: Double
    @Published var pillShadowColor: UIColor?
    @Published var pillShadowRadius: Double
    @Published var pillShadowOffset: CGPoint
    
    @Published var animationType: GroveBar.Style.AnimationStyle
    @Published var systemStatusBarStyle: GroveBar.Style.SystemBarStyle
    @Published var canSwipeToDismiss: Bool
    @Published var canTapToHold: Bool
    @Published var canDismissDuringUserInteraction: Bool
    
    @Published var leftViewSpacing: Double
    @Published var leftViewSize: CGSize?
    @Published var leftViewAlignment: GroveBar.Style.ViewStyle.Alignment
    
    @Published var pbBarColor: UIColor?
    @Published var pbBarHeight: Double
    @Published var pbPosition: GroveBar.Style.ProgressBarStyle.Position
    @Published var pbHorizontalInsets: Double
    @Published var pbCornerRadius: Double
    @Published var pbBarOffset: Double
    
    init(_ defaultStyle: GroveBar.Style) {
        // text
        textStyle = CustomTextStyle(defaultStyle.title)
        subtitleStyle = CustomTextStyle(defaultStyle.subtitle)
        
        // background
        backgroundColor = defaultStyle.background.color
        backgroundType = defaultStyle.background.style
        minimumPillWidth = defaultStyle.background.minimumWidth
        
        // pill
        pillHeight = defaultStyle.background.minimumHeight
        pillSpacingY = defaultStyle.background.topSpacing
        pillBorderColor = defaultStyle.background.borderColor
        pillBorderWidth = defaultStyle.background.borderWidth
        pillShadowColor = defaultStyle.background.shadowColor
        pillShadowRadius = defaultStyle.background.shadowRadius
        pillShadowOffset = .init(x: defaultStyle.background.shadowOffset.width, y: defaultStyle.background.shadowOffset.height)
        
        // bar
        animationType = .bounce
        systemStatusBarStyle = .darkContent
        canSwipeToDismiss = defaultStyle.canSwipeToDismiss
        canTapToHold = defaultStyle.canTapToHold
        canDismissDuringUserInteraction = defaultStyle.canDismissDuringUserInteraction
        
        // left view
        leftViewSpacing = defaultStyle.leftView.spacing
        leftViewSize = defaultStyle.leftView.size
        leftViewAlignment = defaultStyle.leftView.alignment
        
        // progress bar
        pbBarColor = defaultStyle.progressBar.color
        pbBarHeight = defaultStyle.progressBar.height
        pbPosition = defaultStyle.progressBar.position
        pbHorizontalInsets = defaultStyle.progressBar.horizontalInsets
        pbCornerRadius = defaultStyle.progressBar.cornerRadius
        pbBarOffset = defaultStyle.progressBar.yOffset
    }
    
    static func == (lhs: ObservableCustomStyle, rhs: ObservableCustomStyle) -> Bool {
        return false // a hack to trigger .onChange(of: style) on every change
    }
    
    func registerComputedStyle() -> String {
        let styleName = "custom"
        GroveBar.shared.addStyle(for: styleName, with: { _ in computedStyle() })
        return styleName
    }

    func computedStyle() -> GroveBar.Style {
        var style = GroveBar.Style.init()
        
        style.title = textStyle.computedStyle()
        style.subtitle = subtitleStyle.computedStyle()
        
        style.background.color = backgroundColor ?? .clear
        style.background.style = backgroundType
        style.background.minimumWidth = minimumPillWidth
        style.background.minimumHeight = pillHeight
        style.background.topSpacing = pillSpacingY
        style.background.borderColor = pillBorderColor ?? .clear
        style.background.borderWidth = pillBorderWidth
        style.background.shadowColor = pillShadowColor ?? .clear
        style.background.shadowRadius = pillShadowRadius
        style.background.shadowOffset = .init(width: pillShadowOffset.x, height: pillShadowOffset.y)
        
        style.animationStyle = animationType
        style.systemStatusBar = systemStatusBarStyle
        style.canSwipeToDismiss = canSwipeToDismiss
        style.canTapToHold = canTapToHold
        style.canDismissDuringUserInteraction = canDismissDuringUserInteraction
        
        style.leftView.spacing = leftViewSpacing
        style.leftView.alignment = leftViewAlignment
        
        style.progressBar.color = pbBarColor
        style.progressBar.height = pbBarHeight
        style.progressBar.position = pbPosition
        style.progressBar.horizontalInsets = pbHorizontalInsets
        style.progressBar.cornerRadius = pbCornerRadius
        style.progressBar.yOffset = pbBarOffset
        
        return style
    }
    
    @SimpleStringBuilder
    func styleConfigurationString() -> String {
        textStyle.styleConfigurationString(propertyName: "textStyle")
        ""
        subtitleStyle.styleConfigurationString(propertyName: "subtitleStyle")
        
    """
    \nstyle.background.color = \(backgroundColor?.initString ?? "nil")
    style.background.style = \(backgroundType.stringValue)
    """
        
        if backgroundType == .pill {
      """
      \nstyle.background.minimumWidth = \(minimumPillWidth)
      style.background.height = \(pillHeight)
      style.background.topSpacing = \(pillSpacingY)
      """
            
            if let pillBorderColor = pillBorderColor {
        """
        style.background.borderColor = \(pillBorderColor.initString)
        style.background.borderWidth = \(pillBorderWidth)
        """
            }
            
            if let pillShadowColor = pillShadowColor {
        """
        style.background.shadowColor = \(pillShadowColor.initString)
        style.background.shadowRadius = \(pillShadowRadius)
        style.background.shadowOffsetXY = \(pillShadowOffset.initString)
        """
            }
        }
        
    """
    \nstyle.animationType = \(animationType.stringValue)
    style.systemStatusBarStyle = \(systemStatusBarStyle.stringValue)
    style.canSwipeToDismiss = \(canSwipeToDismiss)
    style.canTapToHold = \(canTapToHold)
    style.canDismissDuringUserInteraction = \(canDismissDuringUserInteraction)
    
    style.leftView.spacing = \(leftViewSpacing)
    style.leftView.size = \((leftViewSize ?? .zero).initString)
    style.leftView.alignment = \(leftViewAlignment.stringValue)
    
    style.progressBar.height = \(pbBarHeight)
    style.progressBar.position = \(pbPosition.stringValue)
    style.progressBar.color = \(pbBarColor?.initString ?? "nil")
    style.progressBar.horizontalInsets = \(pbHorizontalInsets)
    style.progressBar.cornerRadius = \(pbCornerRadius)
    style.progressBar.offset = \(CGPoint.init(x: pbBarOffset, y: pbBarOffset))
    """
    }
}

@resultBuilder
enum SimpleStringBuilder {
    static func buildBlock(_ parts: String?...) -> String {
        parts.compactMap { $0 }.joined(separator: "\n")
    }
    
    static func buildOptional(_ component: String?) -> String? {
        return component
    }
}

extension UIColor {
    var initString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        if #available(iOS 14.0, *) {
            return "UIColor(red: \(red), green: \(green), blue: \(blue), alpha: \(alpha)) // \"\(self.accessibilityName)\""
        } else {
            return "??"
        }
    }
}

extension CGPoint {
    var initString: String {
        return "CGPoint(x: \(self.x), y: \(self.y))"
    }
}

extension CGSize {
    var initString: String { "CGSize(width: \(self.width), height: \(self.height))" }
}

extension UIFont {
    var initString: String {
        return "UIFont(name: \"\(self.familyName)\", size: \(self.pointSize))!"
    }
}
