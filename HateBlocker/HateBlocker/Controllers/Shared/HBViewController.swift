//
//  HBViewController.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

class HBViewController<Dependency>: UIViewController {
    var dependency: Dependency! {
        didSet {
            if isViewLoaded {
                dependencyUpdated()
            }
        }
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
    }
    
    func dependencyUpdated() {
        
    }
}
