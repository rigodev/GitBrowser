//
//  UIViewController+Ext.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

extension UIViewController {
    func startActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.backgroundColor = UIColor(white: 0.4, alpha: 0.5)
        activityIndicator.layer.cornerRadius = 12
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.center.equalToSuperview()
        }
    }
    
    func stopActivityIndicator() {
        view.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
    }
}

extension Reactive where Base: UIViewController {
    var isActivityIndicatorRunning: Binder<Bool> {
        Binder(base, scheduler: MainScheduler.instance) { (base: UIViewController, isActivityIndicatorRunning: Bool) -> Void in
            isActivityIndicatorRunning ? base.startActivityIndicator() : base.stopActivityIndicator()
        }
    }
}
