//
//  VerificationView.swift
//  Together
//
//  Created by lcx on 2021/11/18.
//

import SwiftUI
import Amplify

struct VerificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var verificationCode = ""
    @State private var isVerifying = false
    @State private var error = ""
    @State private var showSuccessView = false
    @Binding var showLoginView: Bool
    var email: String
    
    var body: some View {
        ZStack {
            Spinner(isPresented: $isVerifying)
            SuccessView(isPresented: $showSuccessView, text: "Success")
            Form {
                ErrorSection(error: $error)
                Section(
                    header: Text("Please enter verification code we sent to your email address").textCase(.none)
                ) {
                    TextField("Verification Code", text: $verificationCode)
                }
                Section(
                    footer: HStack {
                        Spacer()
                        Button("Resend Code") {}.font(.body)
                        Spacer()
                    }
                    .padding()
                ) {
                    HStack {
                        Spacer()
                        Button("Verify") { confirmSignUp() }
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .disabled(verificationCode.isEmpty)
                    .listRowBackground(Color.blue.opacity(verificationCode.isEmpty ? 0.5 : 1))
                }
            }
            .disabled(isVerifying)
        }
        .navigationTitle("Verificaiton")
    }
    
    private func confirmSignUp() {
        isVerifying.toggle()
        DispatchQueue.global().async {
            Amplify.Auth.confirmSignUp(for: email, confirmationCode: verificationCode) {
                result in
                DispatchQueue.main.async {
                    isVerifying.toggle()
                    switch result {
                    case .success:
                        showSuccessView.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSuccessView.toggle()
                            presentationMode.wrappedValue.dismiss()
                            showLoginView.toggle()
                        }
                    case .failure(let error):
                        self.error = error.errorDescription
                    }
                }
            }
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(showLoginView: .constant(true), email: "123@wustl.edu")
    }
}
