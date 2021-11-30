//
//  ChangePasswordViewModel.swift
//  Together
//
//  Created by lcx on 2021/11/29.
//

import SwiftUI
import Combine

class ChangePasswordViewModel: ObservableObject {
    @Published var old = ""
    @Published var new = ""
    @Published var newConfirmation = ""
    
    @Published var message = ""
    
    private var cancellables = Set<AnyCancellable> ()
    private let lowercasePredicate = NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*")
    private let uppercasePredicate = NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*")
    private let specialCharPredicate = NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*")
    private let numberPredicate = NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*")
    
    private var isPasswordValidPublisher: AnyPublisher<String, Never> {
        Publishers.CombineLatest3($old, $new, $newConfirmation)
            .map { [self] in
                if $0.isEmpty {
                    return "Old password should not be empty"
                }
                if !lowercasePredicate.evaluate(with: $1) {
                    return PasswordStatus.noLowercase.rawValue
                }
                if !uppercasePredicate.evaluate(with: $1) {
                    return PasswordStatus.noUppercase.rawValue
                }
                if !numberPredicate.evaluate(with: $1) {
                    return PasswordStatus.noNumber.rawValue
                }
                if !specialCharPredicate.evaluate(with: $1) {
                    return PasswordStatus.noSpecialCharacter.rawValue
                }
                if $1.count < 8 {
                    return PasswordStatus.lengthNotEnough.rawValue
                }
                if $0 == $2 {
                    return "Old password should not be the same as new password"
                }
                if $1 != $2 {
                    return PasswordStatus.notMatch.rawValue
                }
                return PasswordStatus.valid.rawValue
            }
            .eraseToAnyPublisher()
    }
    
    init() {        
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .assign(to: \.message, on: self)
            .store(in: &cancellables)
    }
}
