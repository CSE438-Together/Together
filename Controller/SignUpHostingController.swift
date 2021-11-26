//
//  SignUpHostingController.swift
//  Together
//
//  Created by lcx on 2021/11/25.
//

import SwiftUI
import UIKit

class SignUpHostingController: UIHostingController<SignUpView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: SignUpView());
    }
}
