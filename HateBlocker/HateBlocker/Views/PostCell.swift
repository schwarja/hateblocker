//
//  PostCell.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    let format = DateFormatter.dateFormat(fromTemplate: "EEE dM HH:mm", options: 0, locale: formatter.locale)
    formatter.dateFormat = format
    return formatter
}()

class PostCell: HBTableViewCell {
    private var timeLabel: UILabel!
    private var nameLabel: UILabel!
    private var titleLabel: UILabel!
    
    func configure(withPost post: Post) {
        timeLabel.text = dateFormatter.string(from: post.postedAt)
        nameLabel.text = post.author
        titleLabel.text = post.text
    }
    
    override func setup() {
        selectionStyle = .none
        
        timeLabel = UILabel()
        addSubview(timeLabel)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 24)
        addSubview(nameLabel)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        addSubview(titleLabel)
        
        timeLabel.attach(left: 16, top: 8, right: 8)
        nameLabel.attach(left: 16, right: 8)
        nameLabel.below(view: timeLabel, constant: 4)
        titleLabel.attach(left: 16, right: 8, bottom: 8)
        titleLabel.below(view: nameLabel, constant: 4)
    }
}
