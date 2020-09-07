//
//  ColorTheme.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 07.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import UIKit

enum ColorTheme {
    static var backgroundColor: UIColor {
        let defaultColor = UIColor.white
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return .black
                default:
                    return defaultColor
                }
            }
        } else {
            return defaultColor
        }
    }
}
