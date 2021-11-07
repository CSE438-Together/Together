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
            text = placeHolder
            textColor = UIColor.systemGray2
        }
    }
}
