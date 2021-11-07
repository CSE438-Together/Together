//
//  NewPostViewController.swift
//  Together
//
//  Created by lcx on 2021/11/6.
//

import UIKit

class NewPostViewController: UIViewController {
    @IBOutlet weak var postTitle: TextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTitle.placeHolder = "Title"
        if let view = datePicker.subviews.first {
            view.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension NewPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let view = textView as?  TextView,
              let placeHolder = view.placeHolder
        else {
            return
        }
        if view.text == placeHolder {
            view.text = ""
            view.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let view = textView as? TextView,
              let placeHolder = view.placeHolder
        else {
            return
        }
        if view.text == "" {
            view.text = placeHolder
            view.textColor = UIColor.black
        }
    }
}
