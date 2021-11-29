//
//  ChangePasswordView.swift
//  Together
//
//  Created by lcx on 2021/11/29.
//

import SwiftUI
import Amplify

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var password = ChangePasswordViewModel()
    @State private var error = ""
    @State private var isLoading = false
    @State private var showSuccessView = false
    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    ErrorSection(error: $error)
                    Section(footer:
                        Text(password.message == PasswordStatus.valid.rawValue
                             ? ""
                             : password.message)
                            .foregroundColor(Color.red)
                    ) {
                        SecureField("Old Password", text: $password.old)
                        SecureField("New Password", text: $password.new)
                        SecureField("Confirm New Password", text: $password.newConfirmation)
                    }
                    Section {
                        HStack {
                            Spacer()
                            Button("Submit") {
                                isLoading.toggle()
                                changePassword()
                            }
                            .foregroundColor(.white)
                            Spacer()
                        }
                        .listRowBackground(Color.blue.opacity(password.message == PasswordStatus.valid.rawValue ? 1 : 0.5))
                        .disabled(password.message == PasswordStatus.valid.rawValue ? false : true)
                    }
                }
                .navigationTitle("Change Password")
            }
            Image(systemName: "xmark")
                .resizable()
                .scaledToFill()
                .foregroundColor(.primary)
                .frame(width: 25, height: 25, alignment: .center)
                .padding([.leading, .top], 20)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
                .position(x: 20, y: 20)
            if isLoading {
                Spinner().zIndex(5)
            }
            if showSuccessView {
                SuccessView().zIndex(15)
            }
        }
    }
    
    private func changePassword() {
        Amplify.Auth.update(oldPassword: password.old, to: password.new) {
            result in
            DispatchQueue.main.async {
                isLoading.toggle()
                switch result {
                case .success:
                    showSuccessView.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSuccessView.toggle()
                        presentationMode.wrappedValue.dismiss()
                    }
                case .failure(let error):
                    self.error = error.errorDescription
                }
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
