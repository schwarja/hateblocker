//
//  ReuseIdentifierProtocol.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class var reuseIdentifier: String {
        return NSStringFromClass(self) + "Identifier"
    }
}

extension UITableViewHeaderFooterView {
    class var reuseIdentifier: String {
        return NSStringFromClass(self) + "Identifier"
    }
}

extension UICollectionViewCell {
    class var staticReuseIdentifier: String {
        return NSStringFromClass(self) + "Identifier"
    }
}

extension UICollectionReusableView {
    class var reuseIdentifier: String {
        return NSStringFromClass(self) + "Identifier"
    }
}
