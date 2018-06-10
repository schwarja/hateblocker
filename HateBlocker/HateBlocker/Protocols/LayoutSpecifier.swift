//
//  LayoutSpecifier.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

protocol LayoutSpecifier {
    
    var layoutRelation: NSLayoutConstraint.Relation { get }
    var layoutConstant: CGFloat { get }
}

extension Double: LayoutSpecifier {
    
    var layoutRelation: NSLayoutConstraint.Relation {
        return .equal
    }
    
    var layoutConstant: CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat: LayoutSpecifier {
    
    var layoutRelation: NSLayoutConstraint.Relation {
        return .equal
    }
    
    var layoutConstant: CGFloat {
        return self
    }
}

extension Int: LayoutSpecifier {
    
    var layoutRelation: NSLayoutConstraint.Relation {
        return .equal
    }
    
    var layoutConstant: CGFloat {
        return CGFloat(self)
    }
}

extension String: LayoutSpecifier {
    
    var layoutConstant: CGFloat {
        let numberString: String
        
        if layoutRelation == .equal {
            numberString = self
        }
        else if self.count > 2 {
            numberString = String(self[self.index(self.startIndex, offsetBy: 2)...])
        }
        else {
            numberString = ""
        }
        
        if let number = NumberFormatter().number(from: numberString) {
            return CGFloat(number.floatValue)
        }
        else {
            return 0.0
        }
    }
    
    var layoutRelation: NSLayoutConstraint.Relation {
        if hasPrefix(">=") {
            return .greaterThanOrEqual
        }
        else if hasPrefix("<=") {
            return .lessThanOrEqual
        }
        else {
            return .equal
        }
    }
    
}
