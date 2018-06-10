//
//  UIResponder+Events.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

extension UIResponder {
    @objc func didTapOnAddPost(sender: Any?) {
        coordinatingResponder?.didTapOnAddPost(sender: sender)
    }
    
    @objc func didCreatePost(withName name: String, text: String, sender: Any?) {
        coordinatingResponder?.didCreatePost(withName: name, text: text, sender: sender)
    }
}
