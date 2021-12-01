//
//  ResetPasswordView.swift
//  Together
//
//  Created by lcx on 2021/11/29.
//

import SwiftUI
import Amplify

struct ResetPasswordView: View {
    @StateObject private var reset = ResetPasswordViewModel()
    @State private var isLoading = false
    @State private var error = ""
    @State private var showSuccessView = false
    @Binding private var isPresenting: Bool
    private var email: String
    
    init(email: String, isPresenting: Binding<Bool>) {
        self._isPresenting = isPresenting
        self.email = email
    }
    
    var body: some View {
        ZStack {
            Spinner(isPresented: $isLoading)
            SuccessView(isPresented: $showSuccessView, text: "Success")
            Form {
                ErrorSection(error: $error)
                Section(footer:
                    Text(reset.message == PasswordStatus.valid.rawValue
                        ? ""
                        : reset.message
                    )
                    .foregroundColor(.red)
                ) {
                    TextField("Confirmation Code", text: $reset.confirmationCode)
                        .font(.body)
                        .foregroundColor(.primary)
                    SecureField("New Password", text: $reset.password)
                        .font(.body)
                        .foregroundColor(.primary)
                    SecureField("Confirm New Password", text: $reset.passwordConfirmation)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Reset") {
                            isLoading.toggle()
                            resetPassword()
                        }
                        .font(.body)
                        .foregroundColor(.white)
                        Spacer()
                    }
                    .listRowBackground(Color.blue.opacity(reset.message == PasswordStatus.valid.rawValue ? 1 : 0.5))
                    .disabled(reset.message == PasswordStatus.valid.rawValue ? false : true)
                }
            }
        }
        .navigationTitle("Reset Password")
    }
    
    private func resetPassword() {
        DispatchQueue.global().async {
            Amplify.Auth.confirmResetPassword(
                for: email,
                with: reset.password,
                confirmationCode: reset.confirmationCode
            ) {
                result in
                DispatchQueue.main.async {
                    isLoading.toggle()
                    switch result {
                    case .success(_):
                        showSuccessView.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSuccessView.toggle()
                            isPresenting.toggle()
                        }
                    case .failure(let error):
                        self.error = error.errorDescription
                    }
                }
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(email: "asdf", isPresenting: .constant(true))
    }
}
