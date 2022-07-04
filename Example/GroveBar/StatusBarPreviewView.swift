//
//  StatusBarPreviewView.swift
//  GroveBar_Example
//
//  Created by XMFraker on 2022/6/30.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import GroveBar

//struct StatusBarPreviewView: UIViewRepresentable {
//    var title: String?
//    var subtitle: String?
//    var displayActivity: Bool = false
//    var style: GroveBar.Style
//    var leftView: UIView?
//    var customView: UIView?
//
//    init(title: String? = nil,
//         subtitle: String? = nil,
//         displayActivity: Bool = false,
//         defaultStyle: GroveBar.Style = .init(),
//         leftView: UIView? = nil,
//         customView: UIView? = nil,
//         styleConfig: ((inout GroveBar.Style) -> Void)? = nil
//    ) {
//        self.title = title
//        self.subtitle = subtitle
//        self.displayActivity = displayActivity
//        self.style = defaultStyle
//        self.leftView = leftView
//        self.customView = customView
//        if let config = styleConfig { config(&self.style) }
//    }
//    
//    func makeUIView(context: Context) -> some UIView {
//        let barView = GroveBar.BarView.init()
//        barView.title = title
//        barView.subtitle = subtitle
//        if displayActivity { barView.displayIndicatorView = displayActivity }
//        else if let view = leftView { barView.display(leftView: view) }
//        if let view = customView { barView.display(customView: view) }
//        barView.update(style: style)
//        return barView
//    }
//    
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        
//    }
//}
//
//@available(iOS 15.0, *)
//struct StatusBarPreviewView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        ScrollView.init(.vertical, showsIndicators: true, content: {
//            VStack(alignment: .leading) {
//                
//                StatusBarPreviewView.init(title: "Full Style - Light",
//                                          styleConfig: { style in
//                    style.background.style = .fullWidth
//                    style.systemStatusBar = .lightContent
//                    style.background.color = .lightGray
//                })
//                .frame(height: 94)
//                                
//                StatusBarPreviewView.init(title: "Full Style-CustomView",
//                                          customView: {
//                    let view = UIView.init()
//                    view.backgroundColor = .yellow
//                    return view
//                }(),
//                                          styleConfig: { style in
//                    style.background.style = .fullWidth
//                    style.systemStatusBar = .lightContent
//                })
//                .frame(height: 94)
//                
//                StatusBarPreviewView.init(title: "Pill Style-CustomView",
//                                          customView: {
//                    let view = UIView.init()
//                    view.frame = .init(x: 0, y: 0, width: 150, height: 50)
//                    view.backgroundColor = .cyan
//                    return view
//                }(),
//                                          styleConfig: { style in
//                    style.background.style = .pill
//                    style.systemStatusBar = .lightContent
//                    style.background.shadowColor = .red
//                })
//                .frame(height: 94)
//
//                StatusBarPreviewView.init(title: "PillStyle-Success",
//                                          defaultStyle: GroveBar.shared.style(for: .success)
//                )
//                .frame(height: 94)
//                
//                StatusBarPreviewView.init(title: "PillStyle-Light",
//                                          subtitle: "Subtitle",
//                                          defaultStyle: GroveBar.shared.style(for: .light))
//                .frame(height: 94)
//                
//                StatusBarPreviewView.init(title: "PillStyle-Dark",
//                                          displayActivity: false,
//                                          defaultStyle: GroveBar.shared.style(for: .dark))
//                .frame(height: 94)
//                
//                StatusBarPreviewView.init(title: "PillStyle-Failture",
//                                          defaultStyle: GroveBar.shared.style(for: .failure))
//                .frame(height: 94)
//                
//                
//                StatusBarPreviewView.init(title: "PillStyle-Warning",
//                                          defaultStyle: GroveBar.shared.style(for: .warning))
//                .frame(height: 94)
//                
//                
//                StatusBarPreviewView.init(title: "Pill Style", subtitle: "i am subtitle", displayActivity: false)
//                    .frame(height: 94)
//
//                StatusBarPreviewView.init(title: "Pill Style - LeftView",
//                                          subtitle: "i am subtitle",
//                                          leftView: {
//                    let label = UILabel.init()
//                    label.backgroundColor = .red
//                    label.text = "What!!!!!!!"
//                    return label
//                }(),
//                                          styleConfig: { $0.leftView.size = .init(width: 30, height: 30) }
//                )
//                .frame(height: 94)
//
////                StatusBarPreviewView.init(title: "Pill Style -- DisplayIndicatorView", subtitle: "i am subtitle", displayActivity: true,
////                                          styleConfig: { style in
////                    style.background.borderColor = .yellow
////                    style.background.borderWidth = 0.5
////                    style.background.shadowColor = .green
////                })
////                .frame(height: 94)
//            }
//        })
//        .background(Color(uiColor: UIColor.systemGray5))
//        .ignoresSafeArea(.container, edges: [.top])
//        .statusBar(hidden: false)
//    }
//}
