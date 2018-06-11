//
//  AddPostViewController.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import UIKit

struct AddPostDependency {
    let nlpManager: NLPManager
}

class AddPostViewController: HBViewController<AddPostDependency>, UITextViewDelegate {
    private var nameTextField: UITextField!
    private var textView: UITextView!
    private var doneButton: UIBarButtonItem!
    
    var doneButtonEnabled: Bool {
        return !(nameTextField.text?.isEmpty ?? true) && !(textView.text?.isEmpty ?? true)
    }
    
    override func setup() {
        view.backgroundColor = .white
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonTapped))
        doneButton.isEnabled = false
        navigationItem.title = "Add post"
        navigationItem.rightBarButtonItem = doneButton
        
        nameTextField = UITextField()
        nameTextField.placeholder = "Your name"
        nameTextField.borderStyle = .roundedRect
        view.addSubview(nameTextField)
        
        textView = UITextView()
        textView.clipsToBounds = true
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.delegate = self
        view.addSubview(textView)
        
        nameTextField.attachToSafeArea(left: 24, top: 16, right: 24)
        textView.attachToSafeArea(left: 24, right: 24, bottom: 16)
        textView.below(view: nameTextField, constant: 16)
    }
    
    @objc func doneButtonTapped() {
        let text = textView.text ?? ""
        let hateClass = dependency.nlpManager.evaluate(text: text)
        
        switch hateClass {
        case .some(.hateful):
            presentDenialAlert(withMessage: "Your message is too hateful")
        case .some(.offensive):
            presentDenialAlert(withMessage: "Your message is too offensive")
        default:
            didCreatePost(withName: nameTextField.text ?? "", text: text, sender: self)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        
        doneButton.isEnabled = doneButtonEnabled
        
        let ranges = dependency.nlpManager.hatefulRanges(in: text)
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 17)])
        for range in ranges {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttributes([.foregroundColor: UIColor.red], range: nsRange)
        }
        textView.attributedText = attributedString
    }
}

private extension AddPostViewController {
    func presentDenialAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Denied", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
