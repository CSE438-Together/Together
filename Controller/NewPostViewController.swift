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
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var maxParticipants: UILabel!
    @IBOutlet weak var descriptions: TextView!
    @IBOutlet weak var addDeparturePlace: UIButton!
    @IBOutlet weak var addDestination: UIButton!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTitle.placeHolder = "Title"
        descriptions.placeHolder = "Description"
        if post == nil {
            post = Post()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navViewController = segue.destination as? UINavigationController,
              let viewController = navViewController.topViewController as? LocationSearchViewController
        else {
            return
        }
        viewController.delegate = self
        if segue.identifier == "AddDestination" {
            viewController.title = "Destination"
            if addDestination.title(for: .normal) != "Add Destination" {
                viewController.currentAddress = post.destination
            }
        } else {
            viewController.title = "Departure Place"
            if addDeparturePlace.title(for: .normal) != "Add Departure Place" {
                viewController.currentAddress = post.source
            }
        }                
    }
    
    func updateAddress(_ target: String?, _ addressLine1: String?, _ address: String?) {
        if target == "Destination" {
            if post.destination != address {
                post.destination = address
                addDestination.setTitle(addressLine1, for: .normal)
            }
        } else {
            if post.source != address {
                post.source = address
                addDeparturePlace.setTitle(addressLine1, for: .normal)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        let num = maxParticipants.toInt() - 1
        if num == 2 {
            minus.isEnabled = false
        }
        maxParticipants.text = "\(num)"
        plus.isEnabled = true
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        let num = maxParticipants.toInt() + 1
        if num == 20 {
            plus.isEnabled = false
        }
        maxParticipants.text = "\(num)"
        minus.isEnabled = true
    }
}

extension NewPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let view = textView as? TextView else { return }
        if view.isShowingPlaceHolder() {
            view.hidePlaceHolder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let view = textView as? TextView else { return }
        if view.endEditingWithEmpty() {
            view.showPlaceHolder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
}

extension UILabel {
    func toInt() -> Int {
        guard let text = self.text,
              let num = Int(text)
        else {
            return 0
        }
        return num
    }
}
