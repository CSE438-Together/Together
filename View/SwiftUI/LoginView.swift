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
                            API.signIn(email, password)
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
