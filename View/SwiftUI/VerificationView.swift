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
    @State private var isVerifying = false
    @State private var error = ""
    private let email: String
    private let password: String
    
    init (email: String, password: String) {
        self.email = email
        self.password = password
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            BlurView(style: .systemUltraThinMaterial)
            if isVerifying {
                Spinner().zIndex(15)
            }
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text("Verification")
                        .font(.title)
                    Spacer()
                }
                .padding()
                Divider()
                HStack {
                    Spacer()
                    Text("Please enter verification code we sent to your email address")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                ErrorSection(error: $error)
                    .padding()
                Form {
                    Section {
                        TextField("Verification Code", text: $verificationCode)
                    }
                    Section(footer:
                        Button(action: {}) {
                            HStack {
                                Spacer()
                                Text("Resend Code")
                                    .font(.body)
                                Spacer()
                            }
                            .padding([.top], 10)
                        }
                        .animation(.none)
                    ) {
                        Button(action: {
                            isVerifying = true
                            confirmSignUp()
                        }) {
                            HStack {
                                Spacer()
                                Text("Verify")
                                Spacer()
                            }
                        }
                        .disabled(verificationCode.isEmpty)
                        .accentColor(.white)
                        .listRowBackground(Color.blue.opacity(verificationCode.isEmpty ? 0.5 : 1))
                    }
                }
                .animation(.easeInOut)
                .padding(EdgeInsets(top: -65, leading: 0, bottom: 0, trailing: 0))
            }
            .disabled(isVerifying)
        }
    }
    
    private func confirmSignUp() {
        DispatchQueue.global().async {
            Amplify.Auth.confirmSignUp(for: email, confirmationCode: verificationCode) {
                result in
                switch result {
                case .success:
                    API.signIn(email, password) {
                        result in
                        switch result {
                        case .success:
                            break
                        case .failure(let error):
                            self.error = error.errorDescription
                        }
                    }
                case .failure(let error):
                    self.error = error.errorDescription
                }
                isVerifying = false
            }
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(email: "123@wustl.edu", password: "123")
    }
}
