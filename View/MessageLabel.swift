//
//  MessageLabel.swift
//  Together
//
//  Created by lcx on 2021/11/12.
//

import UIKit

class MessageLabel: UILabel {
    private func showMessage(_ text: String, _ color: UIColor) {
        DispatchQueue.main.async {
            self.backgroundColor = color
            self.text = text
            UIView.animate(withDuration: 0.5) {
                self.isHidden = false
            }
            Timer.scheduledTimer(
                timeInterval: 2.0,
                target: self,
                selector: #selector(self.fireTimer),
                userInfo: nil,
                repeats: false
            )
        }
    }
    
    func showSuccessMessage(_ message: String) {
        showMessage(message, .systemBlue)
    }
    
    func showFailureMessage(_ message: String) {
        showMessage(message, .systemRed)
    }
    
    @objc func fireTimer() {
        UIView.animate(withDuration: 0.5) {
            self.isHidden = true
        }
    }
}
