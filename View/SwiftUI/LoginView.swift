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
    
    var body: some View {
        VStack {
            Form {
                Section(
                    header: HStack {
                        Spacer()
                        Image(systemName: "minus")
                        .font(.custom("SuperLarge", size: 75))
                        .foregroundColor(.blue)
                        Spacer()
                    }
                ) {}
                Section(header: HStack {
                    Text("Login")
                    .font(.largeTitle.bold())
                    .textCase(.none)
                    .foregroundColor(.primary)
                }
                ) {}
                
                if hasError {
                    Section(header: HStack(alignment: .top) {
                            Image(systemName: "exclamationmark.icloud")
                                .foregroundColor(.red)
                                .font(.title)
                            Text(error)
                                .foregroundColor(.red)
                                .textCase(.none)
                                .font(.body)
                        }
                    ) {}
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
                Section(
                    header: Button(
                        action: {
                            API.signIn(email, password) {
                                message in
                                self.error = message
                                self.hasError = true
                            }
                        },
                        label: {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 40)
                                .overlay(
                                    Text("Login")
                                        .foregroundColor(.white)
                                        .font(.body)
                                        .textCase(.none)
                                )
                        }
                    ).disabled(email.isEmpty || password.isEmpty)
                ) {}
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
