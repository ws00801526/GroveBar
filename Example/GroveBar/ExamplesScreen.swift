//
//

import Foundation
import SwiftUI
import GroveBar

@available(iOS 15.0, *)
class ExamplesScreenFactory: NSObject {
    @objc static func createExamplesScreen() -> UIViewController {
        let text = "👋 Hello World!"
        GroveBar.shared.present(stylable: GroveBar.Style.BuiltInStyle.matrix, title: text, dismissAfter: 2.0)
        return UIHostingController(rootView: NavigationView { ExamplesScreen() } )
    }
}

@available(iOS 15.0, *)
struct ExamplesScreen: View {
    @State var progress = 0.0
    @State var showActivity = false
    @State var showSubtitle = false
    @State var backgroundType: GroveBar.Style.BackgroundStyle.Style = .pill
    
    func showDefaultNotification(_ text: String, completion: @escaping GroveBar.Completion) {
        
        let name = GroveBar.shared.addStyle(for: "tmp", baseOn: .default) { style in
            style.background.style = backgroundType
            return style
        }
        
        GroveBar.shared.present(stylable: name,
                                title: text,
                                subtitle: showSubtitle ? "{subtitle}" : nil,
                                completion: completion)
        
        if showActivity { GroveBar.shared.displayIndicatorView = true }
        if progress > 0.0 { GroveBar.shared.update(progress: Float(progress)) }
    }

    func showIncludedStyle(_ text: String, style: GroveBar.Style.BuiltInStyle) {
        
        let name = GroveBar.shared.addStyle(for: "tmp", baseOn: style) {
            $0.background.style = backgroundType
            return $0
        }
        
        GroveBar.shared.present(stylable: name, title: text, subtitle: showSubtitle ? "{subtitle}" : nil)
        
        GroveBar.shared.dismiss(after: 3.0)

        if showActivity { GroveBar.shared.displayIndicatorView = true }
        if progress > 0.0 { GroveBar.shared.update(progress: Float(progress)) }
  }

  var body: some View {
    List {
      Section {
        NavigationLink {
          StyleEditorScreen()
        } label: {
          VStack(alignment: .leading) {
            Text("Style Editor")
              .font(.subheadline)
              .foregroundColor(.accentColor)
            Text("Get creative & create your own style!")
              .font(.caption2)
              .foregroundColor(.secondary)
          }
        }.foregroundColor(.accentColor)
      }

        Section("Default Style") {
            cell(title: "Present / dismiss", subtitle: "Default style, don't autohide", useAccentColor: true) {
                if GroveBar.shared.isVisible {
                    GroveBar.shared.dismiss()
                } else {
                    showDefaultNotification("Better call Saul!") { _ in }
                }
            }
            cell(title: "Animate progress bar & hide", subtitle: "Hide bar at 100%", useAccentColor: true) {
                if !GroveBar.shared.isVisible {
                    showDefaultNotification("Animating Progress…") {
                        $0?.update(progress: .zero)
                        $0?.update(progress: 1.0, animationDuration: animationDurationForCurrentStyle(), completion: { $0?.dismiss() })
                    }
                } else {
                    GroveBar.shared.update(progress: .zero)
                    GroveBar.shared.update(progress: 1.0, animationDuration: animationDurationForCurrentStyle(), completion: { $0?.dismiss() })
                }
            }
        }

      Section("Settings") {
        Toggle("Show subtitle", isOn: $showSubtitle)
          .onChange(of: showSubtitle) { on in
            if on, !GroveBar.shared.isVisible {
              showDefaultNotification("Look!") { _ in }
                GroveBar.shared.dismiss(after: 2.0)
            }
              
            GroveBar.shared.update(subtitle: on ? "I am a subtitle" : nil)
          }.font(.subheadline)

          Toggle("Activity Indicator", isOn: $showActivity)
              .onChange(of: showActivity) { _ in
                  if !GroveBar.shared.isVisible {
                      if showActivity {
                          let name = GroveBar.shared.addStyle(for: "tmp", baseOn: .default, with: {
                              $0.background.style = backgroundType
                              $0.background.minimumWidth = .zero
                              return $0
                          })
                          GroveBar.shared.present(stylable: name, title: "", dismissAfter: 2.0)
                          GroveBar.shared.displayIndicatorView = true
                      }
                  } else {
                      GroveBar.shared.displayIndicatorView = showActivity
                  }
              }.font(.subheadline)

        HStack {
          Text("Progress Bar (\(Int(round(progress * 100)))%)")
          Spacer()
          Slider(value: $progress)
            .frame(width: 150)
        }
        .onChange(of: progress) { _ in
          if !GroveBar.shared.isVisible {
            if progress > 0.0 {
              showDefaultNotification("Making progress…") { _ in }
                GroveBar.shared.dismiss(after: 2.0)
            }
          } else {
              
            GroveBar.shared.update(progress: Float(progress))
          }
        }.font(.subheadline)

        VStack(alignment: .leading, spacing: 6.0) {
          Text("BarBackgroundType").font(.subheadline)
          Picker("", selection: $backgroundType) {
              EnumPickerOptionView(GroveBar.Style.BackgroundStyle.Style.pill)
              EnumPickerOptionView(GroveBar.Style.BackgroundStyle.Style.fullWidth)
          }.font(.subheadline).pickerStyle(.segmented)
        }
        .onChange(of: backgroundType) { _ in
          showDefaultNotification(backgroundType == .pill ? "Ohhh so shiny!" : "I prefer classic…") { _ in }
            GroveBar.shared.dismiss(after: 2.0)
        }
      }
        
        Section("Included Styles") {
            includedStyleCell("Uh huh.", style: .default)
            includedStyleCell("It's time.", style: .light)
            includedStyleCell("Don't mess with me!", style: .dark)
            includedStyleCell("That's how we roll!", style: .success)
            includedStyleCell("You know who I am!", style: .warning)
            includedStyleCell("Uh oh, that didn't work..", style: .failure)
            includedStyleCell("Wake up Neo…", style: .matrix)
        }

      Section("Custom Style Examples") {
        customStyleCell("Love it!", subtitle: "AnimationType.fade + Progress", style: .loveIt)
        customStyleCell("Level Up!", subtitle: "AnimationType.bounce + Progress", style: .levelUp)
        customStyleCell("Looks good", subtitle: "Subtitle + Activity", style: .looksGood)
        customStyleCell("Small Pill", subtitle: "Modified pill size + Progress", style: .smallPill)
        customStyleCell("Style Editor Style", subtitle: "Subtitle + Progress", style: .editor)
      }

      Section("Custom View Examples") {
        cell(title: "Present a button", subtitle: "A custom notification view") {
          // create button
          let button = UIButton(type: .system, primaryAction: UIAction { _ in
            GroveBar.shared.dismiss()
          })
          button.setTitle("Dismiss!", for: .normal)
            let name = GroveBar.shared.addStyle(for: "tmp", baseOn: .default, with: {
                $0.background.style = backgroundType
                $0.canTapToHold = false
                return $0
            })
            GroveBar.shared.present(stylable: name, customView: button)
        }

        cell(title: "Present with icon", subtitle: "A custom left view") {
          // create icon
          let imageView = UIImageView(image: UIImage(systemName: "gamecontroller.fill"))

          // present
            ExampleStyle.iconLeftView.register(for: backgroundType)
            GroveBar.shared.addStyle(for: ExampleStyle.iconLeftView.rawValue, with: {
                $0.leftView.size = imageView.frame.size
                return $0
            })
            GroveBar.shared.present(stylable: ExampleStyle.iconLeftView.rawValue, title: "Player II", subtitle: "Connected", leftView: imageView, dismissAfter: 3.0)
        }
      }

      Section("Sequencing Example") {
        cell(title: "2 notifications in sequence", subtitle: "Utilizing the completion block") {
          showIncludedStyle("This is 1/2!", style: .dark)
          GroveBar.shared.displayIndicatorView = true
            GroveBar.shared.update(progress: .zero)
            GroveBar.shared.dismiss(after: 1.0) {
                showIncludedStyle("✅ This is 2/2!", style: .dark)
                GroveBar.shared.displayIndicatorView = false
                GroveBar.shared.update(progress: .zero)
                $0?.dismiss(after: 1.0)
            }
        }
      }
    }
    .navigationTitle(Bundle.main.object(forInfoDictionaryKey: "ExampleViewControllerTitle") as? String ?? "")
    .navigationBarTitleDisplayMode(.inline)
  }

  func cell(title: String, subtitle: String? = nil, useAccentColor: Bool = false, action: @escaping () -> ()) -> some View {
    Button(action: action, label: {
      HStack {
        VStack(alignment: .leading) {
          Text(title)
            .font(.subheadline)
            .foregroundColor(useAccentColor ? .accentColor : .primary)
          if let subtitle = subtitle {
            Text(subtitle)
              .font(.caption2)
              .foregroundColor(.secondary)
          }
        }
        Spacer()

        // a hack to get disclosure icons on these table rows
        NavigationLink.empty
          .frame(width: 30.0)
          .foregroundColor(useAccentColor ? .accentColor : .secondary)
      }
    })
  }

    func includedStyleCell(_ text: String, style: GroveBar.Style.BuiltInStyle) -> some View {
        cell(title: "Present \(style.stringValue)", subtitle: "Duration: 3s") {
            showIncludedStyle(text, style: style)
        }
    }
    
    func customStyleCell(_ title:String, subtitle:String? = nil, style: ExampleStyle) -> some View {
        let content = style.exampleContent
        return cell(title: "Present: \(title)", subtitle: subtitle) {
            style.register(for: backgroundType)
            GroveBar.shared.present(stylable: style.rawValue, title: content.title, subtitle: content.subtitle) {
                $0?.update(progress: 1.0, animationDuration: animationDurationForCurrentStyle(), completion: { bar in bar?.dismiss() })
            }
            GroveBar.shared.displayIndicatorView = showActivity
        }
    }

  func animationDurationForCurrentStyle() -> Double {
    switch backgroundType {
      case .pill:
        return 3.75
      case .fullWidth:
        fallthrough
      default:
        return 1.25
    }
  }
}

extension NavigationLink where Label == EmptyView, Destination == EmptyView {
  static var empty: NavigationLink {
    self.init(destination: EmptyView(), label: { EmptyView() })
  }
}

@available(iOS 15.0, *)
struct ExamplesScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ExamplesScreen()
    }
  }
}
