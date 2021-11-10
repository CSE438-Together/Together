//
//  Extension.swift
//  Together
//
//  Created by lcx on 2021/11/10.
//

import Foundation
import UIKit
import Amplify

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

extension Optional where Wrapped == Temporal.DateTime {
    func toString() -> String {
        guard let date = self else { return "" }
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss a"
        return formatter.string(from: date.foundationDate)
    }
}
