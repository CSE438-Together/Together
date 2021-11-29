//
//  SignUpView.swift
//  Together
//
//  Created by lcx on 2021/11/16.
//

import SwiftUI
import Amplify

struct SignUpView: View {
    @StateObject private var newUser = NewUserViewModel()
    @State private var isSigningUp = false
    @State private var needVerification = false
    @State private var showLoginSheet = false
    @State private var error = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isSigningUp {                
                Spinner()
                    .zIndex(7)
                    .position(
                        x: UIScreen.main.bounds.midX,
                        y: UIScreen.main.bounds.midY
                    )
            }
            
            NavigationView {
                Form {
                    ErrorSection(error: $error)
                    Section(footer:
                        Text(newUser.nameValidation).foregroundColor(.red)
                    ) {
                        UserProfileField(placeholder: "First Name", text: $newUser.firstName)
                        UserProfileField(placeholder: "Last Name", text: $newUser.lastName)
                    }
                    Section(footer:
                        (newUser.passwordVlidation == .valid ?
                            Text("") :
                            Text(newUser.passwordVlidation.rawValue).foregroundColor(.red) + Text("\n"))
                            + Text("Password must have at least 1 uppercase, 1 lowercase, 1 number, 1 special character, 8 characters long")
                    ) {
                        PasswordField(
                            placeholder: "Create Password",
                            text: $newUser.password,
                            switchCondition: {
                                newUser.passwordVlidation == .valid ||
                                newUser.passwordVlidation == .notMatch
                            }
                        )
                        PasswordField(
                            placeholder: "Confirm Password",
                            text: $newUser.confirmedPassword,
                            switchCondition: {
                                newUser.passwordVlidation == .valid
                            }
                        )
                    }
                    Section(footer: Text(newUser.userInfoVlidation).foregroundColor(.red)
                    ) {
                        UserProfileField(placeholder: "Email", text: $newUser.email, rightItem: Text("@wustl.edu"))
                        UserProfileField(placeholder: "Phone Number", text: $newUser.phone, leftItem: Text("+1"))
                        UserProfileField(placeholder: "Username", text: $newUser.nickname)
                    }
                    Section {
                        Picker(selection: $newUser.gender, label: Text("Gender")) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                        }
                    }
                    Section(footer:
                        Button(action: { showLoginSheet.toggle() }) {
                            HStack {
                                Spacer()
                                Text("Already have an account? Login here")
                                    .font(.body)
                                Spacer()
                            }
                            .padding([.top], 10)
                        }
                        .sheet(isPresented: $showLoginSheet, content: {
                            LoginView()
                        })
                    ) {
                        Button(action: {
                            isSigningUp = true
                            signUp()
                        }) {
                            HStack {
                                Spacer()
                                Text("Sign Up")
                                Spacer()
                            }
                        }
                        .disabled(!newUser.isUserProfileValid)
                        .accentColor(.white)
                        .listRowBackground(Color.blue.opacity(!newUser.isUserProfileValid ? 0.5 : 1))
                    }
                }
                .disabled(needVerification)
                .navigationTitle("Create Account")
            }
            .zIndex(1.0)
            
            if needVerification {
                VerificationView(email: newUser.email + "@wustl.edu", password: newUser.password)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                    .cornerRadius(30)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut)
                    .zIndex(10)
            }
        }
        .ignoresSafeArea(.all, edges: .all)
    }
    
    private func signUp() {
        DispatchQueue.global().async {
            let userAttributes = [
                AuthUserAttribute(.givenName, value: newUser.firstName),
                AuthUserAttribute(.familyName, value: newUser.lastName),
                AuthUserAttribute(.phoneNumber, value: "+1" + newUser.phone),
                AuthUserAttribute(.gender, value: newUser.gender),
                AuthUserAttribute(.nickname, value: newUser.nickname)
            ]
            Amplify.Auth.signUp(
                username: newUser.email + "@wustl.edu",
                password: newUser.password,
                options: AuthSignUpRequest.Options(userAttributes: userAttributes)
            ) {
                switch $0 {
                case .success:
                    needVerification = true
                case .failure(let error):
                    self.error = error.errorDescription
                }
                isSigningUp = false
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpView()
        }
    }
}
