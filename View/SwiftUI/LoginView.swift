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
            Section {
                Text("Login")
                    .listRowBackground(Color(.systemGroupedBackground))
                    .font(.largeTitle.bold())
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            
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
            Section {
                Button(action: {
                    API.signIn(email, password) {
                        message in
                        error = message
                        hasError = true
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Login")
                        Spacer()
                    }
                }
                .accentColor(.white)
                .listRowBackground(Color.blue.opacity(email.isEmpty || password.isEmpty ? 0.5 : 1))
                .disabled(email.isEmpty || password.isEmpty)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
