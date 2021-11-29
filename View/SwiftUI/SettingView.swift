//
//  SettingView.swift
//  Together
//
//  Created by lcx on 2021/11/28.
//

import SwiftUI
import Amplify

struct SettingView: View {
    @StateObject private var user = UserViewModel()
    @State private var isShowingPhotoPicker = false
    @State private var isEditing = false
    @State private var error = ""
    @State private var needChangePassword = false
    
    var body: some View {
        NavigationView {
            Form {
                ErrorSection(error: $error)
                Section {
                    HStack {
                        if let image = user.profilePhoto {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 75, alignment: .center)
                                .clipShape(Circle())
                                .onTapGesture {
                                    isShowingPhotoPicker = true
                                }
                                .sheet(isPresented: $isShowingPhotoPicker, content: {
                                    PhotoPicker(image: $user.profilePhoto, error: $error)
                                })
                        }
                        VStack(alignment: .leading) {
                            Text(user.nickname)
                                .foregroundColor(.primary)
                            Text(user.email)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Section(header: HStack {
                    Text("Profile")
                    Spacer()
                    if isEditing {
                        Button("Done") {
                            UIApplication.shared.endEditing()
                            isEditing.toggle()
                            updateAttributes()
                        }
                        .textCase(.none)
                        .transition(AnyTransition.opacity.animation(.easeIn))
                    } else {
                        Button("Edit") {
                            isEditing.toggle()
                        }
                        .textCase(.none)
                        .transition(AnyTransition.opacity.animation(.easeIn))
                    }
                    
                }) {
                    HStack {
                        Text("First Name")
                        TextField("", text: $user.firstName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                            .disabled(!isEditing)
                    }
                    HStack {
                        Text("Last Name")
                        TextField("", text: $user.lastName)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                            .disabled(!isEditing)
                    }
                    Picker(selection: $user.gender, label: Text("Gender")) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                    .disabled(!isEditing)
                    HStack {
                        Text("Phone Number")
                        TextField("", text: $user.phone)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                            .disabled(!isEditing)
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        Button("Change Password") {
                            needChangePassword.toggle()
                        }
                        .sheet(isPresented: $needChangePassword) {
                            ChangePasswordView()
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button("Log Out") {
                            signOut()
                        }
                        .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Setting")
        }
    }
    
    private func signOut() {
        Amplify.Auth.signOut() {
            switch $0 {
            case .success:
                DispatchQueue.global().async {
                    Amplify.DataStore.stop { _ in
                        DispatchQueue.main.async {
                            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: SignUpView())
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.error = error.errorDescription
                }
            }
        }
    }
    
    private func updateAttributes() {
        DispatchQueue.global().async {
            let userAttributes = [
                AuthUserAttribute(.givenName, value: user.firstName),
                AuthUserAttribute(.familyName, value: user.lastName),
                AuthUserAttribute(.phoneNumber, value: user.phone),
                AuthUserAttribute(.gender, value: user.gender)
            ]
            Amplify.Auth.update(userAttributes: userAttributes) {
                switch $0 {
                case .success(_):
                    break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.error = error.errorDescription
                    }
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
