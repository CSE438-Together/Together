//
//  VerificationView.swift
//  Together
//
//  Created by lcx on 2021/11/18.
//

import SwiftUI
import Amplify

struct VerificationView: View {
    @State private var verificationCode = ""
    private let email: String
    private let password: String
    @State private var isVerifying = false
    
    init (email: String, password: String) {
        self.email = email
        self.password = password
        print(email)
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            BlurView(style: .systemUltraThinMaterial)
            VStack {
                Text("Verification")
                    .font(.title)
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                Divider()
                Text("Please enter verification code we sent to your email address")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Form {
                    Section {
                        TextField("Verification Code", text: $verificationCode)
                    }
                    Section(
                        header: Button(
                            action: {
                                isVerifying = true
                                confirmSignUp()
                            },
                            label: {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(height: 40)
                                    .overlay(
                                        Text("Verify")
                                            .foregroundColor(.white)
                                            .font(.body)
                                    )
                            }
                        ).disabled(verificationCode.isEmpty)
                    ) {}.textCase(nil)
                    Section(header: Button(action: {}, label: {
                        Text("Resend Code")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .font(.subheadline)
                    })) {}
                    .textCase(nil)
                }
                .animation(.easeInOut)
                .padding(EdgeInsets(top: -65, leading: 0, bottom: 0, trailing: 0))
            }
            if isVerifying {
                BlurView(style: .light)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
        }
    }
    
    private func confirmSignUp() {
        DispatchQueue.global().async {
            Amplify.Auth.confirmSignUp(for: email, confirmationCode: verificationCode) {
                result in
                switch result {
                case .success:
                    API.signIn(email, password)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(email: "123@wustl.edu", password: "123")
    }
}
