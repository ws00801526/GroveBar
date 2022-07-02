//
//  StyleCache.swift
//  GroveBar
//
//  Created by XMFraker on 2022/6/28.
//

import UIKit

internal class StyleCache {
    
    typealias StyleHandler = GroveBar.Style.StyleHandler
    typealias BuiltInStyle = GroveBar.Style.BuiltInStyle
    
    private(set) var defaultStyle: GroveBar.Style = .init()
    private var styles: [String : GroveBar.Style] = [:]

    func style(for name: String) -> GroveBar.Style {
        return styles[name] ?? defaultStyle
    }

    func style(for builtIn: BuiltInStyle) -> GroveBar.Style {
        return builtIn.style
    }

    func updateDefaultStyle(with handler: StyleHandler) {
        defaultStyle = handler(&defaultStyle)
    }
    
    func addStyle(for name: String, with handler: StyleHandler) {
        var style = style(for: name)
        styles[name] = handler(&style)
    }
    
    func addStyle(for name: String, baseOn builtIn: BuiltInStyle, with handler: StyleHandler) {
        var style = style(for: builtIn)
        styles[name] = handler(&style)
    }
}
