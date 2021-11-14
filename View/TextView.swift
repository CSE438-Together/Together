//
//  TextView.swift
//  Together
//
//  Created by lcx on 2021/11/6.
//

import UIKit

class TextView: UITextView {
    var autocompleteTable: UITableView?
    var editButton: UIButton?
    
    var placeholder: String? {
        didSet {
            isEditable = true
            text = placeholder
        }
    }
    
    override var text: String! {
        didSet {
            textColor = text == placeholder ? .placeholderText : .label
        }
    }
    
    func loadSearchResults() {
        guard let table = autocompleteTable else { return }
        table.reloadData()
        if table.isHidden {
            UIView.animate(withDuration: 0.5) {
                table.isHidden = false
            }
        }        
    }
    
    func removeAutocompleteTable() {
        guard let table = autocompleteTable,
              let button = editButton
        else {
            return
        }
        UIView.animate(withDuration: 0.5) {
            table.isHidden = true
        }
        if text != placeholder {            
            isEditable = false
            UIView.animate(withDuration: 0.5) {
                button.isHidden = false
            }
        }
    }
}
