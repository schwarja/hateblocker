//
//  ConversationsController.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

struct PostsControllerDependecy {
    let postsManager: PostsManager
}

class PostsController: HBViewController<PostsControllerDependecy>, ContainerController, PostsManagerDelegate {
    var embededController: UIViewController?
    
    override func setup() {
        dependency.postsManager.delegate = self
        
        navigationItem.title = "Posts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addPostTapped))

        let controller = PostsContentViewController(dependency: contentDependency)
        embed(controller: controller)
    }
    
    override func dependencyUpdated() {
        if let controller = embededController as? PostsContentViewController {
            controller.dependency = contentDependency
        }
    }
    
    func postsManagerDidUpdate(_ manager: PostsManager) {
        if let controller = embededController as? PostsContentViewController {
            controller.dependency = contentDependency
        }
    }
    
    @objc func addPostTapped() {
        didTapOnAddPost(sender: self)
    }
}

private extension PostsController {
    var contentDependency: PostsContentDependency {
        return PostsContentDependency(posts: dependency.postsManager.posts)
    }
}
