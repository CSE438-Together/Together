//
//  TextView.swift
//  Together
//
//  Created by lcx on 2021/11/6.
//

import UIKit

class TextView: UITextView {
    var placeHolder: String? {
        didSet {
            showPlaceHolder()
        }
    }
    
    func showPlaceHolder() {
        text = placeHolder
        textColor = UIColor.placeholderText
    }
    
    func hidePlaceHolder() {
        text = ""
        textColor = UIColor.label
    }
    
    func isShowingPlaceHolder() -> Bool {
        return text == placeHolder
    }
    
    func endEditingWithEmpty() -> Bool {
        return text == ""
    }
}
