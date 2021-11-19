//
//  SignUpView.swift
//  Together
//
//  Created by lcx on 2021/11/16.
//

import SwiftUI
import Amplify

struct UserProfileField: View {
    let placeholder: String
    @Binding var text: String
    var leftItem: Text? = nil
    var rightItem: Text? = nil
    
    var body: some View {
        HStack {
            leftItem
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
            rightItem
            if !text.isEmpty {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
            }
        }
    }
}

struct PasswordField: View {
    let placeholder: String
    @Binding var text: String
    let switchCondition: () -> Bool
    
    var body: some View {
        HStack {
            SecureField(placeholder, text: $text)
            if !text.isEmpty {
                switchCondition() ?
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green) :
                Image(systemName: "exclamationmark.circle")
                    .foregroundColor(.red)
            }
        }
    }
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct SignUpView: View {
    @StateObject private var newUser = NewUserViewModel()
    @State private var isSigningUp = false
    @State private var needVerification = false
    @State private var showLoginSheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                Form {
                    Section(
                        footer: Text(newUser.nameValidation).foregroundColor(.red),
                        content: {
                            UserProfileField(placeholder: "First Name", text: $newUser.firstName)
                            UserProfileField(placeholder: "Last Name", text: $newUser.lastName)
                            }
                    )
                    Section(
                        footer: (newUser.passwordVlidation == .valid ? Text("") : Text(newUser.passwordVlidation.rawValue).foregroundColor(.red) + Text("\n"))
                            + Text("Password must have at least 1 uppercase, 1 lowercase, 1 number, 1 special character, 8 characters long"),
                        content: {
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
                    )
                    Section(footer: Text(newUser.userInfoVlidation).foregroundColor(.red)) {
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
                    Section(
                        header: Button(
                            action: {
                                isSigningUp = true
                                signUp()
                            },
                            label: {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(height: 40)
                                    .overlay(
                                        Text("Sign Up")
                                            .foregroundColor(.white)
                                            .font(.body)
                                    )
                            }
                        ).disabled(!newUser.isUserProfileValid)
                    ) {}.textCase(.none)
                    
                    Section(header: Button(action: {
                        showLoginSheet.toggle()
                    }, label: {
                        Text("Already have an account? Login here")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            .font(.subheadline)
                    }).sheet(isPresented: $showLoginSheet, content: {
                        LoginView()
                    })
                    ) {}
                    .textCase(.none)
                    
                }
                .navigationTitle("Create Account")
            }
            .disabled(needVerification)
            .zIndex(1.0)
            
            if isSigningUp {
                BlurView(style: .light)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.5)
            }
            if needVerification {
                VerificationView(email: newUser.email + "@wustl.edu", password: newUser.password)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                    .cornerRadius(30)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut)
                    .zIndex(4)
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
                result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        isSigningUp = false
                        needVerification = true
                    }
                case .failure(let error):
                    print(error)
                }
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
