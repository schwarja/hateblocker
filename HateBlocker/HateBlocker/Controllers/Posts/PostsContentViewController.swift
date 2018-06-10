//
//  PostsContentViewController.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

struct PostsContentDependency {
    let posts: [Post]
}

class PostsContentViewController: HBViewController<PostsContentDependency>, UITableViewDataSource {
    private var tableView: UITableView!
    
    override func dependencyUpdated() {
        tableView.reloadData()
    }
    
    override func setup() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        view.addSubview(tableView)
        
        tableView.attach(left: 0, top: 0, right: 0, bottom: 0)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dependency.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: indexPath) as! PostCell
        
        cell.configure(withPost: dependency.posts[indexPath.row])
        
        return cell
    }
}
