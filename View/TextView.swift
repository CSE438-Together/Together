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
            showPlaceholder()
        }
    }
    
    func showPlaceholder() {
        text = placeholder
        textColor = UIColor.placeholderText
    }
    
    func hidePlaceholder() {
        text = ""
        textColor = UIColor.label
    }
    
    func isShowingPlaceholder() -> Bool {
        return text == placeholder
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
        if !isShowingPlaceholder() {            
            isEditable = false
            UIView.animate(withDuration: 0.5) {
                button.isHidden = false
            }
        }
    }
}
