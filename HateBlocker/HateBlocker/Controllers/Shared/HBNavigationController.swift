//
//  HBNavigationController.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

class HBNavigationController: UINavigationController, Injectable {
    var dependencies: AppDependency! {
        didSet {
            dependenciesUpdated()
        }
    }
    var childControllers: [WROH<UIResponder>] = []
    
    init(dependencies: AppDependency) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        
    }
    
    func dependenciesUpdated() {
        
    }
}
