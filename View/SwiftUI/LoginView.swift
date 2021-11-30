//
//  LoginView.swift
//  Together
//
//  Created by lcx on 2021/11/18.
//

import SwiftUI
import Amplify

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    @State private var error = ""
    @State private var isSigningIn = false
    @State private var showConfirmEmailView = false
    
    var body: some View {
        ZStack {
            Spinner(isPresented: $isSigningIn)
            NavigationView {
                Form {
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
                            .font(.body)
                            .sheet(isPresented: $showConfirmEmailView) {
                                ConfirmEmailView()
                            }
                            Spacer()
                        }
                        .padding([.top], 20)
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
                            .font(.body)
                            Spacer()
                        }
                        .listRowBackground(Color.blue.opacity(email.isEmpty || password.isEmpty ? 0.5 : 1))
                        .disabled(email.isEmpty || password.isEmpty || isSigningIn)
                    }
                }
                .navigationTitle("Login")
                .toolbar() {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
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
