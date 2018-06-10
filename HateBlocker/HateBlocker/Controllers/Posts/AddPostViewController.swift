//
//  AddPostViewController.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

struct AddPostDependency {
    
}

class AddPostViewController: HBViewController<AddPostDependency> {
    private var nameTextField: UITextField!
    private var textView: UITextView!
    
    override func setup() {
        view.backgroundColor = .white
        
        navigationItem.title = "Add post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonTapped))
        
        nameTextField = UITextField()
        nameTextField.placeholder = "Your name"
        nameTextField.borderStyle = .roundedRect
        view.addSubview(nameTextField)
        
        textView = UITextView()
        textView.clipsToBounds = true
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.black.cgColor
        textView.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(textView)
        
        nameTextField.attachToSafeArea(left: 24, top: 16, right: 24)
        textView.attachToSafeArea(left: 24, right: 24, bottom: 16)
        textView.below(view: nameTextField, constant: 16)
    }
    
    @objc func doneButtonTapped() {
        let name: String
        if let text = nameTextField.text, !text.isEmpty {
            name = text
        }
        else {
            name = "<NONAME>"
        }
        didCreatePost(withName: name, text: textView.text, sender: self)
    }
}