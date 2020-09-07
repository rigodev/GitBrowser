//
//  UITableView+Ext.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(forType type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.description())
    }
    
    func dequeueReusableCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        return dequeueReusableCell(withIdentifier: T.description(), for: indexPath) as! T
    }
}
