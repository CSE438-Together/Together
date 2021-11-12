//
//  Alert.swift
//  Together
//
//  Created by lcx on 2021/11/11.
//

import Foundation
import UIKit

class Alert {
    public static func showWarning(_ viewController: UIViewController, _ title: String, _ message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}
