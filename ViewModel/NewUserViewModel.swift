//
//  NewUserViewModel.swift
//  Together
//
//  Created by lcx on 2021/11/17.
//

import SwiftUI
import Combine

enum PasswordStatus: String {
    case noLowercase = "Password must contain at least 1 lowercase"
    case noUppercase = "Password must contain at least 1 uppercase"
    case noSpecialCharacter = "Password must contain at least 1 special character"
    case noNumber = "Password must contain at least 1 number"
    case lengthNotEnough = "Password must be at least 8 charactors long"
    case notMatch = "Password confirmation does not match password"
    case valid = "valid"
}

enum UserInfoStatus: String {
    case emptyEmail = "Email must not be empty"
    case emptyPhone = "Phone number should not be empty"
    case emptyNickname = "Username should not be empty"
    case invalidPhoneNumber = "Phone number must be 10 digits"
    case valid = ""
}

class NewUserViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var password = ""
    @Published var confirmedPassword = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var nickname = ""
    @Published var gender = "Male"
    
    var nameValidation = ""
    var passwordVlidation = PasswordStatus.valid
    var userInfoVlidation = ""
    var isUserProfileValid = false
    
    private var cancellables = Set<AnyCancellable> ()
    private let lowercasePredicate = NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*")
    private let uppercasePredicate = NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*")
    private let specialCharPredicate = NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*")
    private let numberPredicate = NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*")
    
    private var isNameValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($firstName, $lastName)
            .map { !$0.isEmpty && !$1.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordStatus, Never> {
        Publishers.CombineLatest($password, $confirmedPassword)
            .map { [self] in
                if !lowercasePredicate.evaluate(with: $0) {
                    return .noLowercase
                }
                if !uppercasePredicate.evaluate(with: $0) {
                    return .noUppercase
                }
                if !numberPredicate.evaluate(with: $0) {
                    return .noNumber
                }
                if !specialCharPredicate.evaluate(with: $0) {
                    return .noSpecialCharacter
                }
                if $0.count < 8 {
                    return .lengthNotEnough
                }
                if $0 != $1 {
                    return .notMatch
                }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isPersionInfoValidPublisher: AnyPublisher<UserInfoStatus, Never> {
        Publishers.CombineLatest3($email, $phone, $nickname)
            .map {
                if $0.isEmpty {
                    return .emptyEmail
                }
                if $1.isEmpty {
                    return .emptyPhone
                }
                if $1.count != 10 {
                    return .invalidPhoneNumber
                }
                if $2.isEmpty {
                    return .emptyNickname
                }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isUserProfileValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isNameValidPublisher, isPasswordValidPublisher, isPersionInfoValidPublisher)
            .map { $0 && $1 == .valid && $2 == .valid }
            .eraseToAnyPublisher()
    }
    
    init() {
        isNameValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { isValid in isValid ? "" : "Name should not be empty"}
            .assign(to: \.nameValidation, on: self)
            .store(in: &cancellables)
        
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .assign(to: \.passwordVlidation, on: self)
            .store(in: &cancellables)
        
        isPersionInfoValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { PersonalInfoStatus in PersonalInfoStatus.rawValue }
            .assign(to: \.userInfoVlidation, on: self)
            .store(in: &cancellables)
        
        isUserProfileValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .assign(to: \.isUserProfileValid, on: self)
            .store(in: &cancellables)
    }
}
