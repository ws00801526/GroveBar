//
//

import GroveBar

struct NotificationContent {
  var title: String
  var subtitle: String? = nil
}

enum ExampleStyle: String, RawRepresentable, CaseIterable {
  case loveIt
  case levelUp
  case looksGood
  case smallPill
  case iconLeftView
  case editor
    
    case customAttribues

  var exampleContent: NotificationContent {
    switch self {
      case .loveIt:
        return NotificationContent(title: "Love it!")
      case .levelUp:
        return NotificationContent(title: "Level Up!")
      case .looksGood:
        return NotificationContent(title: "Presenting", subtitle: "This is looking good")
      case .smallPill:
        return NotificationContent(title: "Oh, hello there!")
      case .iconLeftView:
        return NotificationContent(title: "Icon Left View")
      case .editor:
        return NotificationContent(title: "Edit me", subtitle: "in the Style Editor")
        
    case .customAttribues:
        return .init(title: "Custom Attribues", subtitle: "some custom attribues of title")
    }
  }

    func register(for backgroundType: GroveBar.Style.BackgroundStyle.Style) {
        var style = buildStyle()
        style.background.style = backgroundType
        GroveBar.shared.addStyle(for: rawValue, with: { _ in style })
    }

  func buildStyle() -> GroveBar.Style {
    switch self {
      case .loveIt:
        var style = GroveBar.Style()
        style.background.color = UIColor(red: 0.797, green: 0.0, blue: 0.662, alpha: 1.0)
        style.title.color = .white
        style.animationStyle = .fade
        style.title.font = UIFont(name: "SnellRoundhand-Bold", size: 20.0)!
        style.progressBar.color = UIColor(red: 0.986, green: 0.062, blue: 0.598, alpha: 1.0)
        style.progressBar.height = 400.0
        style.progressBar.cornerRadius = 0.0
        style.progressBar.horizontalInsets = 0.0
        style.progressBar.yOffset = .zero
        return style

      case .levelUp:
        var style = GroveBar.Style()
        style.background.color = .cyan
        style.title.color = UIColor(red: 0.056, green: 0.478, blue: 0.998, alpha: 1.0)
        style.animationStyle = .bounce
        style.title.font = UIFont(name: "DINCondensed-Bold", size: 17.0)!
        style.progressBar.color = UIColor(white: 1.0, alpha: 0.66)
        style.progressBar.height = 6.0
        style.progressBar.cornerRadius = 3.0
        style.progressBar.horizontalInsets = 20.0
        style.progressBar.position = .center
        style.progressBar.yOffset = -2.0
        return style

      case .looksGood:
        var style = GroveBar.Style()
        style.background.color = UIColor(red: 0.9999999403953552, green: 0.3843138813972473, blue: 0.31372547149658203, alpha: 1.0) // "red"
        style.title.color = .black
        style.title.font = UIFont(name: "Noteworthy-Bold", size: 13.0)!
        style.subtitle.color = UIColor(red: 0.48235297203063965, green: 0.16078439354896545, blue: -6.016343867543128e-09, alpha: 1.0) // "dark red orange"
        style.subtitle.font = UIFont(name: "Noteworthy", size: 14.0)!
        style.systemStatusBar = .darkContent
        style.progressBar.position = .bottom
        style.progressBar.color = .white
        style.progressBar.height = 4.0
        style.progressBar.cornerRadius = 2.0
        style.progressBar.horizontalInsets = 40.0
        style.progressBar.yOffset = -2.0
        return style

      case .smallPill:
        var style = GroveBar.Style()
        style.title.color = UIColor(red: 0.003921307157725096, green: 0.11372547596693039, blue: 0.34117642045021057, alpha: 1.0) // "dark blue"
        style.title.font = UIFont(name: ".AppleSystemUIFont", size: 14.0)!

        style.subtitle.color = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.66) // "dark gray"
        style.subtitle.font = UIFont(name: ".AppleSystemUIFont", size: 11.0)!

        style.background.color = UIColor(red: 0.960784375667572, green: 0.9254902005195618, blue: -9.626150188069005e-08, alpha: 1.0) // "light vibrant yellow"

        style.background.minimumWidth = 0.0
        style.background.minimumHeight = 32.0
        style.background.topSpacing = 14.0
        style.background.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.33) // "black"
        style.background.shadowRadius = 4.0
        style.background.shadowOffset = .init(width: 0.0, height: 2.0)

        style.progressBar.height = 4.0
        style.progressBar.position = .bottom
        style.progressBar.color = UIColor(red: 0.3, green: 0.31, blue: 0.52, alpha: 1.0) // "dark blue"
        style.progressBar.horizontalInsets = 20.0
        style.progressBar.cornerRadius = 2.0
        style.progressBar.yOffset = -3.0
        return style

      case .iconLeftView:
        var style = GroveBar.Style()
        style.background.color = UIColor(white: 0.15, alpha: 1.0)
        style.background.minimumWidth = 200.0
        style.background.minimumHeight = 50.0
        style.systemStatusBar = .lightContent
        style.leftView.alignment = .left
        style.leftView.spacing = 10.0
        style.title.color = UIColor.white
        style.title.font = UIFont.boldSystemFont(ofSize: 13.0)

        style.subtitle.color = UIColor.lightGray
        style.subtitle.font = UIFont.systemFont(ofSize: 12.0)
        return style

      case .editor:
        var style = GroveBar.Style()

        style.title.color = UIColor(white: 0.1, alpha: 1.0)
        style.title.font = .systemFont(ofSize: 14.0)
        style.subtitle.color = UIColor(white: 0.1, alpha: 0.66)

        style.background.style = .pill
        style.background.color = UIColor(red: 0.7960, green: 0.9411, blue: 0.9999, alpha: 1.0) // "light cyan blue"
        style.background.shadowColor = UIColor(white: 0.0, alpha: 0.08)
        style.background.topSpacing = 2.0
        style.animationStyle = .bounce
        style.systemStatusBar = .darkContent

        style.progressBar.color = UIColor(red: 0.3, green: 0.31, blue: 0.52, alpha: 1.0) // "dark cyan blue"
        style.progressBar.height = 4.0
        style.progressBar.position = .bottom
        style.progressBar.horizontalInsets = 20.0
        style.progressBar.cornerRadius = 2.0
        style.progressBar.yOffset = -4.0

        return style
        
    case .customAttribues:
        var style = ExampleStyle.editor.buildStyle()
        style.title.attributes = [.font : UIFont.systemFont(ofSize: 17.0), .foregroundColor : UIColor.green]
        return style
    }
  }
}
