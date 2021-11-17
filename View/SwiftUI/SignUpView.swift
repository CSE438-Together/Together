//
//  SignUpView.swift
//  Together
//
//  Created by lcx on 2021/11/16.
//

import SwiftUI
import Combine

class NewUserViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var password = ""
    @Published var confirmedPassword = ""
    
    var nameValidation = ""
    
    private var cancellables = Set<AnyCancellable> ()
    
    private var isNameValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($firstName, $lastName)
            .map { !$0.isEmpty && !$1.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordMatchesPublisher: AnyPublisher<Bool, Never> {
        
    }
    
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        
    }
    
    init() {
        isNameValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { isValid in isValid ? "" : "Name should not be empty"}
            .assign(to: \.nameValidation, on: self)
            .store(in: &cancellables)
        
    }
}

struct SignUpView: View {
    @StateObject private var newUser = NewUserViewModel()
    @State var password = ""
    @State var confirmedPassword = ""
    @State var email = ""
    @State var phoneNumber = ""
    @State var nickName = ""
    @State var gender = "Male"

    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text(newUser.nameValidation).foregroundColor(.red)) {
                    HStack {
                        TextField("First Name", text: $newUser.firstName)
                        if !newUser.firstName.isEmpty {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                    HStack {
                        TextField("Last Name", text: $newUser.lastName)
                        if !newUser.lastName.isEmpty {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        }
                    }
                }
                Section(footer: Text("Password must be at least 1 uppercase, 1 lowercase, 1 number, 1 special character, 8 characters long")) {
                    SecureField("Create Password", text: $password)
                    SecureField("Confirm Password", text: $confirmedPassword)
                }
                Section {
                    TextField("Email", text: $email)
                    TextField("Phone Number", text: $phoneNumber)
                    HStack {
                        TextField("Username", text: $nickName)
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                }
                Section {
                    Picker(selection: $gender, label: Text("Gender")) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                }
                
                Section(header: Button(action: {}, label: {
                    Text("Sign Up")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40, maxHeight: .infinity, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(.body)
                })) {}
                .textCase(nil)
                
                Section(header: Button(action: {}, label: {
                    Text("Already have an account? Login here")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        .font(.subheadline)
                })) {}
                .textCase(nil)
            }
            .navigationTitle("Create Account")
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
