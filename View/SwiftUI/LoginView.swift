//
//  LoginView.swift
//  Together
//
//  Created by lcx on 2021/11/18.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var hasError = false
    @State private var error = ""
    @State private var isSigningIn = false

    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Image(systemName: "minus")
                    .foregroundColor(.blue)
                    .font(.custom("SuperLarge", size: 75))
                Spacer()
            }
            .zIndex(1)
            .position(x: UIScreen.main.bounds.midX, y: 10)
            
            if isSigningIn {
                Spinner().zIndex(5)
            }
            
            Form {
                Section {
                    Text("Login")
                        .foregroundColor(.primary)
                        .listRowBackground(Color(.systemGroupedBackground))
                        .font(.largeTitle.bold())
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                if hasError {
                    ErrorSectionView(error: $error)
                }
                Section {
                    TextField("Eamil", text: $email)
                        .font(.body)
                        .foregroundColor(.primary)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                Section {
                    Button(action: {
                        self.isSigningIn.toggle()
                        API.signIn(
                            email,
                            password,
                            completion: { self.isSigningIn.toggle() }
                        ) {
                            message in
                            self.error = message
                            self.hasError = true
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Login")
                                .font(.body)
                            Spacer()
                        }
                    }
                    .accentColor(.white)
                    .listRowBackground(Color.blue.opacity(email.isEmpty || password.isEmpty ? 0.5 : 1))
                    .disabled(email.isEmpty || password.isEmpty)
                }
            }
        }
        .disabled(isSigningIn)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
