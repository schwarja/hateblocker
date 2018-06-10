//
//  RootViewController.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, Injectable, ContainerController {
    var dependencies: AppDependency!
    var childControllers: [WROH<UIResponder>] = []
    var embededController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension RootViewController {
    func setup() {
        setupDependencies()
        
        let navigation = PostsNavigationController(dependencies: dependencies)
        addChildController(navigation)
        embed(controller: navigation)
    }
    
    func setupDependencies() {
        let firebase = FirebaseManager()
        let postsManager = PostsManager(firebase: firebase)
        dependencies = AppDependency(firebaseManager: firebase, postsManager: postsManager)
    }
}
