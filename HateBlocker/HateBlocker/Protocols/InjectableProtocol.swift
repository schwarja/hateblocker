//
//  InjectableProtocol.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

protocol Injectable: class {
    var dependencies: AppDependency! { get set }
    var childControllers: [WROH<UIResponder>] { get set }
}

extension Injectable {
    func addChildController<T: UIResponder>(_ controller: T) where T: Injectable {
        childControllers.append(WROH(object: controller))
        controller.dependencies = dependencies
        (controller as? UIViewController)?.parentController = self as? UIResponder
    }
    
    func updateChildControllers() {
        childControllers = childControllers.filter({ $0.object != nil })
        for child in childControllers {
            (child.object as? Injectable)?.dependencies = dependencies
        }
    }
}
