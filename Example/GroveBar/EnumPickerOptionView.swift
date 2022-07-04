//
//

import SwiftUI
import GroveBar

protocol StringRepresentable {
  var stringValue: String { get }
}

extension GroveBar.Style.BuiltInStyle: StringRepresentable {
    var stringValue: String {
        switch self {
        case .`default`: return ".defaultStyle"
        case .light: return ".light"
        case .dark: return ".dark"
        case .success: return ".success"
        case .warning: return ".warning"
        case .failure: return ".error"
        case .matrix: return ".matrix"
      }
    }
}

extension GroveBar.Style.AnimationStyle: StringRepresentable {
  var stringValue: String {
    switch self {
      case .move: return ".move"
      case .fade: return ".fade"
      case .bounce: return ".bounce"
    }
  }
}

extension GroveBar.Style.BackgroundStyle.Style: StringRepresentable {
  var stringValue: String {
    switch self {
      case .fullWidth: return ".fullWidth"
      case .pill: return ".pill"
    }
  }
}

extension GroveBar.Style.SystemBarStyle: StringRepresentable {
  var stringValue: String {
    switch self {
      case .`default`: return ".defaultStyle"
      case .lightContent: return ".lightContent"
      case .darkContent: return ".darkContent"
    }
  }
}

extension GroveBar.Style.ViewStyle.Alignment: StringRepresentable {
  var stringValue: String {
    switch self {
      case .left: return ".left"
      case .center: return ".centerWithText"
    }
  }
}

extension GroveBar.Style.ProgressBarStyle.Position: StringRepresentable {
  var stringValue: String {
    switch self {
      case .top: return ".top"
      case .center: return ".center"
      case .bottom: return ".bottom"
    }
  }
}

@available (iOS 13.0, *)
struct EnumPickerOptionView<T: StringRepresentable>: View where T: Hashable {
  var representable: T

  init(_ representable: T) {
    self.representable = representable
  }

  var body: some View {
    Text(representable.stringValue).tag(representable)
  }
}

@available(iOS 15.0, *)
struct EnumPickerOptionView_Previews: PreviewProvider {
  static var previews: some View {
    Form {
        SegmentedPicker(title: "Test", value: .constant(GroveBar.Style.BuiltInStyle.dark)) {
        EnumPickerOptionView(GroveBar.Style.BuiltInStyle.light)
        EnumPickerOptionView(GroveBar.Style.BuiltInStyle.dark)
      }
    }
  }
}
