//
//  PostsNavigationController.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

class PostsNavigationController: HBNavigationController {
    override func setup() {
        let dependency = PostsControllerDependecy(postsManager: dependencies.postsManager)
        let controller = PostsController(dependency: dependency)
        setViewControllers([controller], animated: false)
    }
    
    override func didTapOnAddPost(sender: Any?) {
        let controller = AddPostViewController(dependency: AddPostDependency())
        pushViewController(controller, animated: true)
    }
    
    override func didCreatePost(withName name: String, text: String, sender: Any?) {
        dependencies.postsManager.sendPost(withName: name, text: text)
        if viewControllers.last == sender as? AddPostViewController {
            popViewController(animated: true)
        }
    }
}
