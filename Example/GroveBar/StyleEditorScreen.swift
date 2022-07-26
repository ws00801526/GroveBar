//
//

import SwiftUI
import GroveBar

@available(iOS 15.0, *)
struct StyleEditorScreen: View {
    @State var text: String = "You're great!"
    @State var subtitle: String = "I mean it"
    @State var showActivity: Bool = false
    @State var progress: Float = 0.5
    @StateObject var style: ObservableCustomStyle = .init(ExampleStyle.editor.buildStyle())
    @State var editingTitle: Bool = true
    
    weak static var statusBarView: StyleBarViewProtocol? = nil
    
    func presentDefault(allowActivity: Bool = true, allowProgress: Bool = true, completion: @escaping () -> Void) {
        
        StyleEditorScreen.statusBarView = GroveBar.shared.present(stylable: style.registerComputedStyle(), title: text, subtitle: subtitle, completion: { _ in
            completion()
        }) as? StyleBarViewProtocol
        if allowActivity && showActivity { GroveBar.shared.displayIndicatorView = showActivity }
        if allowProgress && progress > 0.0 { GroveBar.shared.update(progress: Float(progress)) }
    }
    
    func updateStyleOfPresentedView() {
        StyleEditorScreen.statusBarView?.update(style: style.computedStyle())
        StyleEditorScreen.statusBarView?.window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    var body: some View {
        Form {
            // a hack to trigger live updates
            EmptyView()
                .onChange(of: style) { _ in
                    updateStyleOfPresentedView()
                }
                .onChange(of: style.animationType) { _ in
                    presentDefault {}
                }
                .onChange(of: text) { _ in
                    GroveBar.shared.update(text: text)
                }
                .onChange(of: subtitle) { _ in
                    GroveBar.shared.update(subtitle: subtitle)
                }
            
            Section {
                buttonRow(title: "Present / Dismiss", subtitle: "Don't autohide.") {
                    if GroveBar.shared.isVisible {
                        GroveBar.shared.dismiss()
                    } else {
                        presentDefault {}
                    }
                }
                
                buttonRow(title: "Animate progress (0% to 100%)", subtitle: "Hides at 100%") {
                    if GroveBar.shared.isVisible {
                        GroveBar.shared.update(progress: .zero)
                        GroveBar.shared.update(progress: 1.0, animationDuration: style.backgroundType == .pill ? 0.66 : 1.2, completion: { $0?.dismiss() })
                    } else {
                        presentDefault(allowProgress: false) {
                            GroveBar.shared.update(progress: 1.0, animationDuration: style.backgroundType == .pill ? 0.66 : 1.2, completion: { $0?.dismiss() })
                        }
                    }
                }
                
#if targetEnvironment(simulator)
                buttonRow(title: "Print style config", subtitle: "Print code to configure style to the console & copy it to the pasteboard.") {
                    print(style.styleConfigurationString())
                    UIPasteboard.general.string = style.styleConfigurationString()
                }
#else
                buttonRow(title: "Copy style", subtitle: "Copy current style config to pasteboard") {
                    UIPasteboard.general.string = style.styleConfigurationString()
                }
#endif
                
                InfoLabel(text: "Keep the notification presented to see any changes live!")
            }
            
            Section("State") {
                VStack(alignment: .leading, spacing: 3.0) {
                    Text("Title".uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Empty", text: $text)
                        .font(.subheadline)
                }
                
                VStack(alignment: .leading, spacing: 3.0) {
                    Text("Subtitle".uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Empty", text: $subtitle)
                        .font(.subheadline)
                }
                
                Toggle("Activity Indicator", isOn: $showActivity)
                    .onChange(of: showActivity) { _ in
                        if !GroveBar.shared.isVisible {
                            presentDefault {}
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
                        presentDefault {}
                    } else {
                        GroveBar.shared.update(progress: progress)
                    }
                }.font(.subheadline)
            }
            
            Section("Bar Style") {
                OptionalColorPicker(title: "Background Color", color: $style.backgroundColor)
                
                SegmentedPicker(title: "Background Type", value: $style.backgroundType) {
                    EnumPickerOptionView(GroveBar.Style.BackgroundStyle.Style.pill)
                    EnumPickerOptionView(GroveBar.Style.BackgroundStyle.Style.fullWidth)
                }
                
                if style.backgroundType != .pill {
                    SegmentedPicker(title: "StatusBar System Style", value: $style.systemStatusBarStyle) {
                        EnumPickerOptionView(GroveBar.Style.SystemBarStyle.`default`)
                        EnumPickerOptionView(GroveBar.Style.SystemBarStyle.lightContent)
                        EnumPickerOptionView(GroveBar.Style.SystemBarStyle.darkContent)
                    }
                }
                
                SegmentedPicker(title: "Animation Type", value: $style.animationType) {
                    EnumPickerOptionView(GroveBar.Style.AnimationStyle.bounce)
                    EnumPickerOptionView(GroveBar.Style.AnimationStyle.move)
                    EnumPickerOptionView(GroveBar.Style.AnimationStyle.fade)
                }
                
                Toggle("Allow Swipe-To-Dismiss", isOn: $style.canSwipeToDismiss)
                    .font(.subheadline)
                
                Toggle("Allow Tap-To-Hold", isOn: $style.canTapToHold)
                    .font(.subheadline)
                
                Toggle("Allow dismissal during taps/pans", isOn: $style.canDismissDuringUserInteraction)
                    .font(.subheadline)
            }
            
            Section("Text Style") {
                SegmentedPicker(title: "", value: $editingTitle) {
                    Text("Title").tag(true)
                    Text("Subtitle").tag(false)
                }
                if editingTitle {
                    let info = "The title's \"Offset Y\" affects both the title, the subtitle and the left view. And also the progressBar when using .center positioning."
                    TextStyleEditorView(title: "Title", offsetInfo: info, style: style.textStyle, defaultShadowColor: style.backgroundColor) {
                        updateStyleOfPresentedView()
                    }
                } else {
                    let info = "The subtitle's \"Offset Y\" affects only the subtitle."
                    TextStyleEditorView(title: "Subtitle", offsetInfo: info, style: style.subtitleStyle, defaultShadowColor: style.backgroundColor) {
                        updateStyleOfPresentedView()
                    }
                }
            }
            
            if style.backgroundType == .pill {
                Section("Pill Style") {
                    TextFieldStepper(title: "Pill Height", binding: $style.pillHeight, range: 20...80)
                    TextFieldStepper(title: "Pill Spacing Y", binding: $style.pillSpacingY, range: 0...99)
                    TextFieldStepper(title: "Min Pill Width", binding: $style.minimumPillWidth, range: 0...999)
                    
                    OptionalColorToggle(title: "Pill Border", color: $style.pillBorderColor, defaultColor: .black) {
                        OptionalColorPicker(title: "Color", color: $style.pillBorderColor)
                        TextFieldStepper(title: "Width", binding: $style.pillBorderWidth, range: 0...20)
                    }
                    
                    OptionalColorToggle(title: "Pill Shadow", color: $style.pillShadowColor, defaultColor: UIColor(white: 0.0, alpha: 0.33)) {
                        OptionalColorPicker(title: "Color", color: $style.pillShadowColor)
                        TextFieldStepper(title: "Radius", binding: $style.pillShadowRadius, range: 0...99)
                        CGPointStepper(title: "Offset", point: $style.pillShadowOffset)
                    }
                }
            }
            
            Section("Left View Style") {
                //        OptionalColorPicker(title: "Tint Color", color: $style.leftViewTintColor)
                
                SegmentedPicker(title: "Alignment", value: $style.leftViewAlignment) {
                    EnumPickerOptionView(GroveBar.Style.ViewStyle.Alignment.left)
                    EnumPickerOptionView(GroveBar.Style.ViewStyle.Alignment.center)
                }
                
                TextFieldStepper(title: "Spacing", binding: $style.leftViewSpacing, range: 0...99)
                
                //        CGPointStepper(title: "Offset", point: $style.leftViewOffset)
                
                InfoLabel(text: "The activity indicator is also considered a \"left view\" and thus also affected by these settings.")
            }
            
            Section("Progress Bar Style") {
                OptionalColorPicker(title: "Bar Color", color: $style.pbBarColor)
                
                TextFieldStepper(title: "Bar Height", binding: $style.pbBarHeight, range: 1...99)
                    .onChange(of: style.pbBarHeight) { val in
                        if style.pbCornerRadius > 0.0 {
                            style.pbCornerRadius = floor(val / 2.0)
                        }
                    }
                
                TextFieldStepper(title: "Corner Radius", binding: $style.pbCornerRadius, range: 0...99)
                TextFieldStepper(title: "Bar Offset Y", binding: $style.pbBarOffset, range: -99...99)
                TextFieldStepper(title: "Horizontal Insets", binding: $style.pbHorizontalInsets, range: 0...99)
                
                SegmentedPicker(title: "Bar Position", value: $style.pbPosition) {
                    EnumPickerOptionView(GroveBar.Style.ProgressBarStyle.Position.top)
                    EnumPickerOptionView(GroveBar.Style.ProgressBarStyle.Position.center)
                    EnumPickerOptionView(GroveBar.Style.ProgressBarStyle.Position.bottom)
                }
            }
        }
        .navigationBarTitle("Style Editor")
        .onAppear {
            presentDefault {}
        }
    }
    
    func buttonRow(title: String, subtitle: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action, label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.subheadline)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                }
                Spacer()
                NavigationLink.empty
                    .frame(width: 30.0)
            }
        })
    }
}

@available(iOS 15.0, *)
struct StyleEditorView_Previews: PreviewProvider {
    static var previews: some View {
        StyleEditorScreen()
    }
}
