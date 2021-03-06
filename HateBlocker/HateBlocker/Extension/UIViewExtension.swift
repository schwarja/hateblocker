//
//  UIViewExtension.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

extension UIView {
    private var viewController: UIViewController? {
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            if let controller = nextResponder as? UIViewController {
                return controller
            }
        } while (nextResponder != nil)
        
        return nil
    }
    
    func findTopConstraint() -> NSLayoutConstraint? {
        for constraint in superview?.constraints ?? [] {
            if isTopConstraint(constraint) {
                return constraint
            }
        }
        
        return nil
    }
    
    func isTopConstraint(_ constraint: NSLayoutConstraint) -> Bool {
        if constraint.firstItem as? UIView == self && constraint.firstAttribute == .top {
            return true
        }
        else if constraint.secondItem as? UIView == self && constraint.secondAttribute == .top {
            return true
        }
        else {
            return false
        }
    }
    
    @discardableResult
    func constraint(toWidth width: LayoutSpecifier? = nil, toHeight height: LayoutSpecifier? = nil, priority: Float = 1000) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: width.layoutRelation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            addConstraint(constraint)
            constraints.append(constraint)
        }
        
        if let height = height {
            let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: height.layoutRelation, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            addConstraint(constraint)
            constraints.append(constraint)
        }
        
        return constraints
    }
    
    func constraint(width: LayoutSpecifier? = nil, height: LayoutSpecifier? = nil, toView view: UIView, priority: Float = 1000) {
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width {
            let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: width.layoutRelation, toItem: view, attribute: .width, multiplier: 1, constant: width.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
        }
        
        if let height = height {
            let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: height.layoutRelation, toItem: view, attribute: .height, multiplier: 1, constant: height.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
        }
    }
    
    func constraint(toAspectRatio ratio: CGFloat, priority: Float = 1000) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: ratio, constant: 0)
        constraint.priority = UILayoutPriority(priority)
        addConstraint(constraint)
    }
    
    @discardableResult
    func attach(toView view: UIView? = nil, left: LayoutSpecifier? = nil, top: LayoutSpecifier? = nil, right: LayoutSpecifier? = nil, bottom: LayoutSpecifier? = nil, priority: Float = 1000) -> [NSLayoutConstraint] {
        guard let view = view ?? self.superview else {
            return []
        }
        
        guard let superview = self.superview else {
            return []
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var result = [NSLayoutConstraint]()
        
        if let left = left {
            let constraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: left.layoutRelation, toItem: view, attribute: .left, multiplier: 1, constant: left.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
            result.append(constraint)
        }
        
        if let top = top {
            let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: top.layoutRelation, toItem: view, attribute: .top, multiplier: 1, constant: top.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
            result.append(constraint)
        }
        
        if let right = right {
            let constraint = NSLayoutConstraint(item: view, attribute: .right, relatedBy: right.layoutRelation, toItem: self, attribute: .right, multiplier: 1, constant: right.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
            result.append(constraint)
        }
        
        if let bottom = bottom {
            let constraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: bottom.layoutRelation, toItem: self, attribute: .bottom, multiplier: 1, constant: bottom.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
            result.append(constraint)
        }
        
        return result
    }
    
    func attachToSafeArea(toView view: UIView? = nil, left: LayoutSpecifier? = nil, top: LayoutSpecifier? = nil, right: LayoutSpecifier? = nil, bottom: LayoutSpecifier? = nil) {
        guard let view = view ?? self.superview else {
            return
        }
        
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let left = left {
            if #available(iOS 11, *) {
                let guide = view.safeAreaLayoutGuide
                superview.addConstraint(self.leadingAnchor.constraint(to: guide.leadingAnchor, relation: left.layoutRelation, constant: left.layoutConstant))
            } else {
                superview.addConstraint(self.leadingAnchor.constraint(to: view.leadingAnchor, relation: left.layoutRelation, constant: left.layoutConstant))
            }
        }
        
        if let top = top {
            if #available(iOS 11, *) {
                let guide = view.safeAreaLayoutGuide
                superview.addConstraint(self.topAnchor.constraint(to: guide.topAnchor, relation: top.layoutRelation, constant: top.layoutConstant))
            }
            else if let controller = view.viewController, controller.view === view {
                let guide = controller.topLayoutGuide
                superview.addConstraint(self.topAnchor.constraint(to: guide.bottomAnchor, relation: top.layoutRelation, constant: top.layoutConstant))
            }
            else {
                superview.addConstraint(self.topAnchor.constraint(to: view.topAnchor, relation: top.layoutRelation, constant: top.layoutConstant))
            }
        }
        
        if let right = right {
            if #available(iOS 11, *) {
                let guide = view.safeAreaLayoutGuide
                superview.addConstraint(guide.rightAnchor.constraint(to: self.rightAnchor, relation: right.layoutRelation, constant: right.layoutConstant))
            } else {
                superview.addConstraint(view.rightAnchor.constraint(to: self.rightAnchor, relation: right.layoutRelation, constant: right.layoutConstant))
            }
        }
        
        if let bottom = bottom {
            if #available(iOS 11, *) {
                let guide = view.safeAreaLayoutGuide
                superview.addConstraint(guide.bottomAnchor.constraint(to: self.bottomAnchor, relation: bottom.layoutRelation, constant: bottom.layoutConstant))
            }
            else if let controller = view.viewController, controller.view === view {
                let guide = controller.bottomLayoutGuide
                superview.addConstraint(guide.topAnchor.constraint(to: self.bottomAnchor, relation: bottom.layoutRelation, constant: bottom.layoutConstant))
            }
            else {
                superview.addConstraint(view.bottomAnchor.constraint(to: self.bottomAnchor, relation: bottom.layoutRelation, constant: bottom.layoutConstant))
            }
        }
    }
    
    func attach(toView view: UIView? = nil, centerX: LayoutSpecifier? = nil, centerY: LayoutSpecifier? = nil, priority: Float = 1000) {
        guard let view = view ?? self.superview else {
            return
        }
        
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX {
            let constraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: centerX.layoutRelation, toItem: view, attribute: .centerX, multiplier: 1, constant: centerX.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
        }
        
        if let centerY = centerY {
            let constraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: centerY.layoutRelation, toItem: view, attribute: .centerY, multiplier: 1, constant: centerY.layoutConstant)
            constraint.priority = UILayoutPriority(priority)
            superview.addConstraint(constraint)
        }
    }
    
    func attach(toView view: UIView? = nil, baseline: LayoutSpecifier) {
        guard let view = view ?? self.superview else {
            return
        }
        
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .firstBaseline, relatedBy: baseline.layoutRelation, toItem: view, attribute: .lastBaseline, multiplier: 1, constant: baseline.layoutConstant))
    }
    
    func next(toView view: UIView, constant: LayoutSpecifier = 0, priority: Float = 1000) {
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: constant.layoutRelation, toItem: view, attribute: .right, multiplier: 1, constant: constant.layoutConstant)
        constraint.priority = UILayoutPriority(priority)
        superview.addConstraint(constraint)
    }
    
    @discardableResult
    func below(view: UIView, constant: LayoutSpecifier = 0, priority: Float = 1000) -> NSLayoutConstraint? {
        guard let superview = self.superview else {
            return nil
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: constant.layoutRelation, toItem: view, attribute: .bottom, multiplier: 1, constant: constant.layoutConstant)
        constraint.priority = UILayoutPriority(priority)
        superview.addConstraint(constraint)
        return constraint
    }
    
    func before(view: UIView, constant: LayoutSpecifier = 0, priority: Float = 1000) {
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: view, attribute: .left, relatedBy: constant.layoutRelation, toItem: self, attribute: .right, multiplier: 1, constant: constant.layoutConstant)
        constraint.priority = UILayoutPriority(priority)
        superview.addConstraint(constraint)
    }
    
    func above(view: UIView, constant: LayoutSpecifier = 0, priority: Float = 1000) {
        guard let superview = self.superview else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: constant.layoutRelation, toItem: self, attribute: .bottom, multiplier: 1, constant: constant.layoutConstant)
        constraint.priority = UILayoutPriority(priority)
        superview.addConstraint(constraint)
    }
}

extension NSLayoutAnchor where AnchorType == NSLayoutXAxisAnchor {
    
    func constraint(to anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, relation: NSLayoutConstraint.Relation, constant: CGFloat) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return self.constraint(equalTo: anchor, constant: constant)
            
        case .greaterThanOrEqual:
            return self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
            
        case .lessThanOrEqual:
            return self.constraint(lessThanOrEqualTo: anchor, constant: constant)
        }
    }
    
}

extension NSLayoutAnchor where AnchorType == NSLayoutYAxisAnchor {
    
    func constraint(to anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, relation: NSLayoutConstraint.Relation, constant: CGFloat) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return self.constraint(equalTo: anchor, constant: constant)
            
        case .greaterThanOrEqual:
            return self.constraint(greaterThanOrEqualTo: anchor, constant: constant)
            
        case .lessThanOrEqual:
            return self.constraint(lessThanOrEqualTo: anchor, constant: constant)
        }
    }
    
}
