//
//  UIResponderExtension.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

// Inject parentController property into UIViewController
extension UIViewController {
    private struct AssociatedKeys {
        static var ParentController = "ParentController"
    }
    
    public weak var parentController: UIResponder? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ParentController) as? UIResponder
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ParentController, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

/**
 Driving engine of the message passing through the app, with no need for Delegate pattern nor Singletons.
 
 It piggy-backs on the UIResponder.next? in order to pass the message through UIView/UIVC hierarchy of any depth and complexity.
 However, it does not interfere with the regular UIResponder functionality.
 
 At the UIViewController level (see below), it‘s intercepted to switch up to the coordinator, if the UIVC has one.
 Once that happens, it stays in the Coordinator hierarchy, since coordinator can be nested only inside other coordinators.
 */
public extension UIResponder {
    @objc public var coordinatingResponder: UIResponder? {
        return next
    }
}

extension UIViewController {
    /**
     Returns `parentCoordinator` if the current UIViewController has one,
     or its view's `superview` if it doesn‘t.
     
     ---
     (Attention: from UIResponder.next documentation)
     
     The UIResponder class does not store or set the next responder automatically,
     instead returning nil by default.
     
     Subclasses must override this method to set the next responder.
     
     UIViewController implements the method by returning its view’s superview;
     UIWindow returns the application object, and UIApplication returns nil.
     ---
     
     We also check are there maybe `parent` UIViewController before finally
     falling back to `view.superview`
     */
    override open var coordinatingResponder: UIResponder? {
        guard let parentController = self.parentController else {
            guard let parentController = self.parent else {
                return view.superview
            }
            return parentController as UIResponder
        }
        return parentController
    }
}
