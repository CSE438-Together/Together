//
//  LoginView.swift
//  Together
//
//  Created by lcx on 2021/11/18.
//

import SwiftUI
import Amplify

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var error = ""
    @State private var isSigningIn = false
    @State private var showConfirmEmailView = false
    
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
                ErrorSection(error: $error)
                
                Section {
                    HStack {
                        TextField("Email", text: $email)
                            .font(.body)
                            .foregroundColor(.primary)
                            .autocapitalization(.none)
                        Text("@wustl.edu")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    SecureField("Password", text: $password)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .disabled(isSigningIn)

                Section(footer:
                    HStack {
                        Spacer()
                        Button("Forget Password?") {
                            showConfirmEmailView.toggle()
                        }
                        .sheet(isPresented: $showConfirmEmailView) {
                            ConfirmEmailView()
                        }
                        Spacer()
                    }
                ) {
                    HStack {
                        Spacer()
                        Button("Login") {
                            self.isSigningIn.toggle()
                            API.signIn(email + "@wustl.edu", password) {
                                switch $0 {
                                case .success:
                                    break
                                case .failure(let error):
                                    self.error = error.errorDescription
                                }
                                self.isSigningIn.toggle()
                            }
                        }
                        .foregroundColor(.white)
                        Spacer()
                    }
                    .listRowBackground(Color.blue.opacity(email.isEmpty || password.isEmpty ? 0.5 : 1))
                    .disabled(email.isEmpty || password.isEmpty || isSigningIn)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
