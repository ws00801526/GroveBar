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
            let label = UILabel.init(frame: .zero)
            label.text = "Demo 仅支持iOS 15+ 设备"
            label.textAlignment = .center
            if UITraitCollection.current.userInterfaceStyle == .dark {
                label.textColor = .darkText
            } else {
                label.textColor = .lightText
            }
            label.sizeToFit()
            self.view = label
        }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//
//        let barView = GroveBar.BarView.init(frame: .init(x: 0.0, y: 0.0, width: view.frame.width, height: 94.0))
//        barView.title = "萨达打卡数量的;卡哒哒么萨"
////        barView.subtitle = "萨达但是"
//        barView.displayIndicatorView = true
//
//        let leftview: UIView = .init(frame: .init(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
//        leftview.backgroundColor = .yellow
//        barView.display(leftView: leftview)
//
//        let customView: UIView = .init()
//        customView.frame = .init(x: 0, y: 0, width: 300, height: 100)
//        customView.backgroundColor = .brown
//        barView.display(customView: customView)
//
//        var style = GroveBar.Style.init()
//        style.background.shadowColor = .red
//        barView.update(style: style)
//
//        view.addSubview(barView)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func show() {
//        GroveBar.shared.present(title: "What", dismissAfter: 3.0)
//    }
}


