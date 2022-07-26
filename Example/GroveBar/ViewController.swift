//
//  BarViewController.swift
//  GroveBar
//
//  Created by ws00801526 on 06/28/2022.
//  Copyright (c) 2022 ws00801526. All rights reserved.
//

import UIKit
import GroveBar

class ViewController: UIViewController {
    
    var host: UIViewController?
    
    override func loadView() {
        if #available(iOS 15.0, *) {
            self.view = .init(frame: .zero)
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.backgroundColor = .systemGray

            let host = ExamplesScreenFactory.createExamplesScreen()
            host.willMove(toParent: self)
            addChild(host)
            view.addSubview(host.view)
            host.didMove(toParent: self)
            host.view.frame = view.bounds
            host.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.host = host
        } else {
            
            self.view = .init(frame: UIScreen.main.bounds)
            self.view.backgroundColor = .white
            
            let label = UILabel.init(frame: .zero)
            label.text = "Demo 仅支持iOS 15+ 设备"
            label.textAlignment = .center
            
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    label.textColor = .darkText
                } else {
                    label.textColor = .darkGray
                }
            } else {
                label.textColor = .darkGray
            }
            label.sizeToFit()
            
            label.frame = .init(origin: .init(x: (self.view.frame.width  - label.frame.width) / 2.0, y: 100.0), size: label.frame.size)
            self.view.addSubview(label)
            
            let btn = UIButton.init(frame: .zero)
            btn.setTitle("Tap It!!!", for: .normal)
            btn.sizeToFit()
            btn.setTitleColor(.darkText, for: .normal)
            btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
            btn.frame = .init(origin: .init(x: (self.view.frame.width  - btn.frame.width) / 2.0, y: 200.0), size: btn.frame.size)
            self.view.addSubview(btn)
        }
    }
    
    @objc func btnAction() {
        GroveBar.shared.updateDefaultStyle { style in
            style.background.topSpacing = 15.0
            return style
        }
        GroveBar.shared.present(title: "GorveBar", subtitle: "Simple Demo. Please check on iOS15+", dismissAfter: 5.0, completion: nil)
    }
}

